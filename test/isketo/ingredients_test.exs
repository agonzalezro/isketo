defmodule Isketo.IngredientsTest do
  use ExUnit.Case

  import Isketo.Ingredients

  @valid_ingredients [
    "chicken",
    "cheese",
    "almond dough"
  ]

  @banned_ingredients_with_human_readable [
    ["sweet potato", "potato"],
    ["sweet potatos", "potato"],
    ["white potato", "potato"],
    ["banana", "banana"],
    ["pizza dough", "pizza dough"]
  ]

  test "are_keto checks the content of a list to return its validity or not" do
    banned_ingredients =
      @banned_ingredients_with_human_readable
      |> Enum.map(&List.first/1)

    assert [true, nil] == are_keto(@valid_ingredients)
    assert [false, "banana, pizza dough & potato"] == are_keto(banned_ingredients)

    assert [false, "banana, pizza dough & potato"] ==
             are_keto(banned_ingredients ++ @valid_ingredients)
  end

  test "is_keto checks the validity of a particular ingredient" do
    @valid_ingredients
    |> Enum.each(fn ingredient ->
      assert [true, nil] == is_keto(ingredient)
    end)

    @banned_ingredients_with_human_readable
    |> Enum.each(fn [ingredient, human_readable_ingredient] ->
      assert [false, human_readable_ingredient] == is_keto(ingredient)
    end)
  end
end
