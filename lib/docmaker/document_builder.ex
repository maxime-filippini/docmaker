defmodule Docmaker.DocumentBuilder do
  use GenStage

  def start_link(opts) do
    current_date = Keyword.fetch!(opts, :current_date)
    css_path = Keyword.fetch!(opts, :css_path)

    GenStage.start_link(__MODULE__, {current_date, css_path}, opts)
  end

  def init({current_date, css_path}) do
    pool_size =
      Application.fetch_env!(:docmaker, ChromicPDF)
      |> Keyword.get(:session_pool, [])
      |> Keyword.get(:size, System.schedulers_online())

    {:consumer, {current_date, css_path, pool_size},
     subscribe_to: [
       {:file_watcher, [max_demand: pool_size, min_demand: 1]}
     ]}
  end

  def handle_events(events, _from, {current_date, css_path, pool_size} = state) do
    events
    |> Task.async_stream(
      fn {path, ptf} ->
        html =
          %{
            ptf: ptf,
            current_date: current_date,
            css_path: css_path,
            watermark?: true
          }
          |> Layouts.Grid.render()
          |> Docmaker.render()

        File.write("output/output.html", html)
        ChromicPDF.print_to_pdf({:html, html}, output: "output/output_#{ptf["id"]}.pdf")
        File.rm(path)
      end,
      max_concurrency: pool_size,
      timeout: :infinity
    )
    |> Enum.to_list()

    {:noreply, [], state}
  end
end
