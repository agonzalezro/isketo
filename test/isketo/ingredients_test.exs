defmodule Isketo.IngredientsrTest do
  use ExUnit.Case

  import Isketo.Ingredients

  @valid_ingredients [
    "chicken",
    "cheese",
    "almond dough"
  ]

  @banned_ingredients [
    "sweet potato",
    "sweet potatos",
    "white potato",
    "banana",
    "pizza dough"
  ]

  test "are_keto checks the content of a list to return its validity or not" do
    assert are_keto(@valid_ingredients)
    assert not are_keto(@banned_ingredients)
    assert not are_keto(@banned_ingredients ++ @valid_ingredients)
  end

  test "is_keto checks the validity of a particular ingredient" do
    (@valid_ingredients ++ @banned_ingredients)
    |> Enum.each(fn ingredient ->
      assert is_keto(ingredient) == Enum.member?(@valid_ingredients, ingredient), ingredient
    end)
  end
end
