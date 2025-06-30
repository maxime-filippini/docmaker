defmodule Docmaker.Application do
  use Application

  @chromic_pdf_opts Application.compile_env!(:docmaker, ChromicPDF)

  @impl true
  def start(_type, _args) do
    app_conf = Application.fetch_env!(:docmaker, Docmaker.Application)
    doc_conf = app_conf[:document_builder]
    watcher_conf = app_conf[:file_watcher]

    children = [
      {ChromicPDF, @chromic_pdf_opts},
      {Docmaker.FileWatcher, watcher_conf},
      {Docmaker.DocumentBuilder, doc_conf}
    ]

    opts = [strategy: :one_for_one, name: Docmaker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
