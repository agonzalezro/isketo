use Mix.Config

config :isketo,
  keto_banned_ingredients:
    [
      ["apples?", "apple"],
      ["bananas?", "banana"],
      ["beers?", "alcohol"],
      ["beans?", "beans"],
      ["biscuit?", "biscuit"],
      ["bread", "bread"],
      ["cand(y|ies)", "candy"],
      ["cassava", "cassava"],
      ["cereals?", "cereals"],
      ["chickpeas?", "chickpeas"],
      ["chocolate (milk|powder)", "non-dark chocolate"],
      ["ciabattas?", "cibatta"],
      ["corn", "corn"],
      ["cornstarch", "cornstach"],
      ["ice-?cream", "ice-cream"],
      ["lentils?", "lentils"],
      ["melons?", "melon"],
      ["salty snacks", "salty snacks"],
      ["((muscovado|refined) )?sugar", "sugar"],
      ["oats?", "oats"],
      ["parsnips?", "parsnips"],
      ["pasta", "pasta"],
      ["peas?", "peas"],
      ["pears?", "pear"],
      ["pizza dough", "pizza dough"],
      ["rice", "rice"],
      ["soy", "soy"],
      ["((sweet|white) )?potatos?", "potato"],
      ["toasts?", "toast"],
      ["vodka", "alcohol"],
      ["watermelons?", "watermelon"],
      ["wheat flour", "flour"],
      ["whisky", "alcohol"],
      ["wine", "alcohol"],
      ["yam", "yam"]
    ]
    |> Enum.map(fn [regex_to_parse, human_readable_ingredient] ->
      [~r/#{regex_to_parse}/iu, human_readable_ingredient]
    end)
