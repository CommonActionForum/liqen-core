# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :core,
  ecto_repos: [Core.Repo]

# Configures the endpoint
config :core, Core.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x8VkSW4hxZk6l0FHaopKzIhf+ek/Z/AitCEiOocQ6h6GGtpNBr2M6Fulomz34UtC",
  render_errors: [view: Core.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Core.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  verify_module: Guardian.JWT,
  issuer: "Liqen Core",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{"alg" => "HS512",
                "k" => "v0GI423FEIyK5HTCerjaGK8W3v0gSd9WkCnG6ExS1WJmWBQmrKaLIATGE72wnpwgrtfTueoobzwiY4LYfyRk_g",
                "kty" => "oct", "use" => "sig"},
  serializer: Core.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
