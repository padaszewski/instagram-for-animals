# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :instagram_for_animals,
       ecto_repos: [InstagramForAnimals.Repo]

config :instagram_for_animals, :pow,
       user: InstagramForAnimals.Users.User,
       repo: InstagramForAnimals.Repo

# Configures the endpoint
config :instagram_for_animals,
       InstagramForAnimalsWeb.Endpoint,
       url: [
         host: "localhost"
       ],
       secret_key_base: "pRLZOIe1ROxyodoQ1vMGUGmuSugrmvJcQHUeNrx0KTq7dpt7Z+i23975HTMT0Fsy",
       render_errors: [
         view: InstagramForAnimalsWeb.ErrorView,
         accepts: ~w(html json)
       ],
       pubsub: [
         name: InstagramForAnimals.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]

# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id]

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :phoenix, :format_encoders,
       "json-api": Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
