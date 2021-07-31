defmodule Isketo.Ingredients do
  @keto_banned_ingredients Application.get_env(:isketo, :keto_banned_ingredients)

  def are_keto(ingredients) when is_list(ingredients) do
    ingredients
    |> Enum.map(fn ingredient -> is_keto(ingredient) end)
    |> Enum.all?()
  end

  def is_keto(ingredient) do
    case @keto_banned_ingredients
         |> Enum.find(fn banned_ingredient_regex ->
           Regex.match?(banned_ingredient_regex, String.downcase(ingredient))
         end) do
      nil -> true
      _ -> false
    end
  end
end
