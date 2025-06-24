import Config

config :tailwind,
  version: "4.0.9",
  default: [
    args: ~w(
      --input=assets/css/app.css
      --output=output/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]
