# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :isketo, IsketoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UOvXHGhbjJtNPqJHbx8k7WVyO7NYv7jOEYo4HosBv2qXcJY4xukdCzveaXarBFtu",
  render_errors: [view: IsketoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Isketo.PubSub,
  live_view: [signing_salt: "Njs4TDD8"]

import_config "keto_banned_ingredients.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :isketo, :scraper_http_adapter, Isketo.Scraper.Http.Client

config :isketo, :cookiebot,
  enabled: false,
  id: "1105dd25-7423-42cf-9362-3d2b9ca4a80b"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
