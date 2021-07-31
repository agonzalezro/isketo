defmodule IsketoWeb.PageLiveTest do
  use IsketoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "isketo.com"
    assert render(page_live) =~ "isketo.com"
  end
end
