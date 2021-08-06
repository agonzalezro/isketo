defmodule IsketoWeb.PageLive do
  use IsketoWeb, :live_view

  import Isketo.Scraper
  import Isketo.Ingredients

  @impl true
  def mount(%{"url" => url}, _session, socket) do
    {:ok,
     case connected?(socket) do
       false ->
         assign(socket, result: :loading)

       true ->
         assign(socket, result: check_url(url))
     end
     |> assign(url: url)}
  end

  @impl true
  def mount(_params, _session, socket), do: {:ok, assign(socket, url: "", result: Null)}

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("search", %{"url" => url}, socket) do
    {:noreply,
     socket
     |> push_patch(to: Routes.page_path(socket, :index, %{url: url}))
     |> assign(url: url, result: check_url(url))}
  end

  defp check_url(url) do
    case ingredients(url) do
      nil -> :i_do_not_know
      [] -> :i_do_not_know
      ingredients -> if are_keto(ingredients), do: :yes, else: :no
    end
  end
end
