defmodule IsketoWeb.PageLiveTest do
  use IsketoWeb.ConnCase

  import Phoenix.LiveViewTest
  import IsketoWeb.PageLive, only: [is_keto: 1, parse_ingredients: 1]

  defp fixture(name) do
    File.read!("test/isketo_web/live/fixtures/#{name}.html")
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "isketo.com"
    assert render(page_live) =~ "isketo.com"
  end

  test "is_keto on an empty list returns :i_do_not_know" do
    assert is_keto([]) == :i_do_not_know
  end

  test "is_keto returns false for a list of keto compatible ingredients" do
    assert is_keto(["chicken", "cheese"])
  end

  test "is_keto returns false for banned ingredients" do
    assert is_keto(["banana"]) == false
  end

  test "we can parse ld+json ingredients" do
    assert parse_ingredients(fixture("ld")) == [
             "2 c. <p>shredded mozzarella</p>",
             "1 c. <p>almond flour</p>",
             "1 tsp. <p>kosher salt</p>",
             "1 tsp. <p>garlic powder</p>",
             "1/2 tsp. <p>chili powder</p>",
             "<p>Freshly ground black pepper</p>"
           ]
  end

  test "we can parse itemprop ingredients" do
    assert parse_ingredients(fixture("itemprop")) == ["banana", "egg", "sugar"]
  end

  test "we return an empty list for a unknown list of ingredients" do
    assert parse_ingredients("/dev/null") == []
  end
end
