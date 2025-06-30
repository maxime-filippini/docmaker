# Used by "mix format"
[
  import_deps: [:phoenix],
  inputs: ["{mix,.formatter,config}.exs", "{config,lib,test,scripts}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
