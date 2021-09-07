defmodule Isketo.Ingredients do
  @keto_banned_ingredients Application.get_env(:isketo, :keto_banned_ingredients)

  defp human_join([]), do: nil
  defp human_join([h | t]) when length(t) > 0, do: "#{Enum.join(t, ", ")} & #{h}"
  defp human_join([h]), do: h

  def are_keto(ingredients) when is_list(ingredients) do
    banned =
      ingredients
      |> Enum.map(fn ingredient -> is_keto(ingredient) end)
      |> Enum.map(fn [_, human_readable] -> human_readable end)
      |> Enum.filter(& &1)
      |> Enum.uniq()
      |> human_join

    [banned == nil, banned]
  end

  def is_keto(ingredient) do
    case @keto_banned_ingredients
         |> Enum.find(fn [banned_ingredient_regex, _] ->
           Regex.match?(banned_ingredient_regex, String.downcase(ingredient))
         end) do
      nil -> [true, nil]
      [_, human_readable_ingredient] -> [false, human_readable_ingredient]
    end
  end
end
