defmodule IsketoWeb.PageLive do
  use IsketoWeb, :live_view

  alias Isketo.Scraper
  alias Isketo.Ingredients

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, url: "", result: Null)}
  end

  @impl true
  def handle_event("search", %{"url" => url}, socket) do
    result =
      case Scraper.ingredients(url) do
        nil -> :i_do_not_know
        ingredients -> if Ingredients.are_keto(ingredients), do: :yes, else: :no
      end

    {:noreply, socket |> assign(result: result, url: url)}
  end
end
