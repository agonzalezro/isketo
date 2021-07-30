defmodule IsketoWeb.PageLive do
  use IsketoWeb, :live_view

  @keto_banned_ingredients Application.get_env(:isketo, :keto_banned_ingredients)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, url: "", result: Null)}
  end

  @impl true
  def handle_event("search", %{"url" => url}, socket) do
    %HTTPoison.Response{
      status_code: 200,
      body: html
    } = HTTPoison.get!(url, [], follow_redirect: true)

    {:noreply, socket |> assign(result: html |> parse_ingredients |> is_keto, url: url)}
  end

  defp parse_ld(document) do
    case Floki.find(document, "script[type='application/ld+json']")
         |> List.first() do
      {_, _, [ld | _]} ->
        case ld |> Jason.decode!() do
          lds when is_list(lds) ->
            lds
            |> Enum.map(fn ld -> ld |> Map.get("recipeIngredient") end)
            |> Enum.reject(&is_nil/1)
            |> List.flatten()

          ld ->
            ld |> Map.get("recipeIngredient")
        end

      _ ->
        nil
    end
  end

  defp parse_itemprop(document) do
    document
    |> Floki.find("span[itemprop='recipeIngredient']")
    |> Enum.map(fn {_, _, [ingredient | _]} -> ingredient end)
  end

  def parse_ingredients(html) do
    document = Floki.parse_document!(html)

    # TODO: cover the 20% -> https://www.benawad.com/scraping-recipe-websites/
    parse_ld(document) || parse_itemprop(document)
  end

  def is_keto([]) do
    :i_do_not_know
  end

  def is_keto(ingredients) when is_list(ingredients) do
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
