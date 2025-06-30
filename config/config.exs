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

config :docmaker, ChromicPDF,
  session_pool: [size: 10, timeout: 10_000, checkout_timeout: 5_000, max_uses: 1000]

config :docmaker, Docmaker.Application,
  file_watcher: [
    folder: "/Users/maximefilippini/personal/dev/serious/docmaker/data",
    name: :file_watcher
  ],
  document_builder: [
    name: :document_builder,
    current_date: ~D[2024-12-31],
    css_path: "/Users/maximefilippini/personal/dev/serious/docmaker/output/app.css"
  ]
