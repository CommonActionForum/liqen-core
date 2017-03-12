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
config :core, Core.Endpoint,
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
  secret_key: %{"alg" => "ES512", "crv" => "P-521",
                "d" => "ATUHSE9CfgNnQshfcxP8RZLmFPqHC8Wuocxwfs6DZYLB1GvKQ3M0i3PKkfCejtsTJ_Xbj_F6wVb5ob9a_8vM6v22",
                "kty" => "EC", "use" => "sig",
                "x" => "AR7X_sDJSljrkaCvrsC6c2ND744EvHzYPG-izN05tvWnhBt8f0lILsK_J16Vx70nO5Dzm7xA8LL82fsCzkbYqEVE",
                "y" => "AVftR96nyPfF_s4MCMXswxnuL-PqK9y0LMRw745TPPDSb10jRlgbVdz_p-eVz8i1VszkxP7ORbzrD18X3aufc4Bk"},
  serializer: MyApp.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
