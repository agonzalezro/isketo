defmodule IsketoWeb.PageLiveTest do
  use ExUnit.Case

  import Mox

  import Isketo.Scraper

  defp body_from_fixture(name), do: File.read!("test/isketo/fixtures/#{name}.html")

  test "we can parse ld+json ingredients" do
    ["ld_1", "ld_2"]
    |> Enum.each(fn name ->
      Isketo.Scraper.Http.Mock
      |> expect(:get!, fn url, _, _ when url == name ->
        %HTTPoison.Response{
          status_code: 200,
          body: body_from_fixture(name)
        }
      end)
    end)

    assert ingredients("ld_1") == [
             "2 c. <p>shredded mozzarella</p>",
             "1 c. <p>almond flour</p>",
             "1 tsp. <p>kosher salt</p>",
             "1 tsp. <p>garlic powder</p>",
             "1/2 tsp. <p>chili powder</p>",
             "<p>Freshly ground black pepper</p>"
           ]

    assert ingredients("ld_2") == [
             "1 pound ground beef",
             "1 onion, chopped",
             "4 cloves garlic, minced",
             "1 small green bell pepper, diced",
             "1 (28 ounce) can diced tomatoes",
             "1 (16 ounce) can tomato sauce",
             "1 (6 ounce) can tomato paste",
             "2 teaspoons dried oregano",
             "2 teaspoons dried basil",
             "1 teaspoon salt",
             "½ teaspoon black pepper"
           ]
  end

  test "we can parse itemprop ingredients" do
    Isketo.Scraper.Http.Mock
    |> expect(:get!, fn _, _, _ ->
      %HTTPoison.Response{
        status_code: 200,
        body: body_from_fixture("itemprop")
      }
    end)

    assert ingredients("itemprop") == ["banana", "egg", "sugar"]
  end

  test "we return an empty list for a unknown list of ingredients" do
    Isketo.Scraper.Http.Mock
    |> expect(:get!, fn _, _, _ ->
      %HTTPoison.Response{
        status_code: 200,
        body: ""
      }
    end)

    assert ingredients("") == []
  end
end
