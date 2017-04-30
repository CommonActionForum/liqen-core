# Configures Dogma
use Mix.Config

config :dogma,
  exclude: [
    ~r(\Atest/),
    ~r(\Aconfig/),
    ~r(\Atest/)
  ],

  override: [
    %Dogma.Rule.ModuleDoc{ enabled: false }
  ]
