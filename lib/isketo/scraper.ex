defmodule Isketo.Scraper.Http do
  @callback get!(url :: String.t(), headers :: list, follow_redirect :: Boolean.t()) :: String.t()
end

defmodule Isketo.Scraper.Http.Client do
  def get!(url, headers, follow_redirect), do: HTTPoison.get!(url, headers, follow_redirect)
end

defmodule Isketo.Scraper do
  @http_client Application.get_env(:isketo, :scraper_http_adapter)

  def ingredients(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: html
    } = @http_client.get!(url, [], follow_redirect: true)

    document = Floki.parse_document!(html)

    # TODO: cover the 20% -> https://www.benawad.com/scraping-recipe-websites/
    parse_itemprop(document) ||
      parse_ld(document) ||
      []
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
    case document
         |> Floki.find("span[itemprop='recipeIngredient']")
         |> Enum.map(fn {_, _, [ingredient | _]} -> ingredient end) do
      [] -> nil
      ingredients -> ingredients
    end
  end
end
