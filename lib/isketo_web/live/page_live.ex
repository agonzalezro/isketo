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

  def parse_ingredients(html) do
    document = Floki.parse_document!(html)

    case Floki.find(document, "script[type='application/ld+json']")
         |> List.first() do
      nil ->
        # It uses itemprop(s) instead
        # TODO: cover the 20% -> https://www.benawad.com/scraping-recipe-websites/
        document
        |> Floki.find("span[itemprop='recipeIngredient']")
        |> Enum.map(fn {_, _, [ingredient | _]} -> ingredient end)

      {_, _, [ld | _]} ->
        ld |> Jason.decode!() |> Map.get("recipeIngredient")
    end
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
