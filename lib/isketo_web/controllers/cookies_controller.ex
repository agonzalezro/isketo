defmodule IsketoWeb.CookiesController do
  use IsketoWeb, :controller

  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
