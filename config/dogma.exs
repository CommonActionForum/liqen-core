# Configures Dogma
use Mix.Config

config :dogma,
  exclude: [
    ~r(\Atest/),
    ~r(\Aconfig/),
    ~r(\Atest/),
    ~r(\Aweb/views/error_helpers.ex),
    ~r(\Aweb/web.ex)
  ],

  override: [
    %Dogma.Rule.ModuleDoc{ enabled: false }
  ]
