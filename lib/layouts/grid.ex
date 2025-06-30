defmodule Layouts.Grid do
  use Phoenix.Component
  import Phoenix.HTML, only: [raw: 1]

  alias VegaLite, as: Vl

  defp prepare_data(assigns) do
    tna =
      assigns.ptf["data"]
      |> Enum.reduce(0, &(&2 + &1["value"]))

    top_5_positions =
      assigns.ptf["data"]
      |> Enum.sort_by(& &1["value"], &>=/2)
      |> Enum.map(&Map.put(&1, :weight_raw, &1["value"] / tna))
      |> Enum.map(&Map.put(&1, :weight, format_percentage(&1[:weight_raw])))
      |> Enum.take(5)

    asset_class_breakdown =
      assigns.ptf["data"]
      |> Enum.reduce(%{}, fn %{"category" => c, "value" => v}, acc ->
        Map.update(acc, c, v, fn vv -> vv + v end)
      end)
      |> Enum.to_list()
      |> Enum.map(fn {cat, value} ->
        %{
          asset_class: cat,
          value: Float.round(value * 1.0, 2),
          weight_raw: value / tna,
          weight: format_percentage(value / tna)
        }
      end)
      |> Enum.sort_by(& &1[:value], &>=/2)

    static_data_left = [
      %{parameter: "Fund name", value: assigns.ptf["id"]},
      %{parameter: "Reporting date", value: assigns.current_date},
      %{parameter: "Total Net Assets (EUR)", value: tna |> Float.round(2)}
    ]

    static_data_right = [
      %{parameter: "Number of positions", value: length(assigns.ptf["data"])},
      %{parameter: "Number of asset classes", value: length(asset_class_breakdown)},
      %{parameter: "", value: ""}
    ]

    assigns
    |> Map.put(:tna, tna)
    |> Map.put(:top_5_data, top_5_positions)
    |> Map.put(:ac_breakdown, asset_class_breakdown)
    |> Map.put(:static_data_left, static_data_left)
    |> Map.put(:static_data_right, static_data_right)
  end

  def render(assigns) do
    assigns = prepare_data(assigns)

    ~H"""
    <Layouts.Main.render css_path={@css_path} watermark?={@watermark?}>
      <div class="flex items-center justify-center w-full py-4">
        <h1 class="w-full text-xl font-semibold text-center">
          Summary report
        </h1>
      </div>
      <h2 class="w-full p-1 px-2 my-2 text-base font-semibold text-white bg-black">
        Static data
      </h2>
      <div class="flex items-center justify-center w-full p-2">
        <Components.TableCell.main data={@static_data_left} columns={[:parameter, :value]} />
        <Components.TableCell.main data={@static_data_right} columns={[:parameter, :value]} />
      </div>

      <h2 class="w-full p-1 px-2 my-2 text-base font-semibold text-white bg-black">
        Performance chart
      </h2>
      <div class="flex items-center justify-center h-[222px] w-full">
        <%!-- <.perf_chart ptf={@ptf} /> --%>
        <Components.LineChart.render
          data={@ptf["perf"]}
          x_col="date"
          value_col="value"
          title="Performance"
        />
      </div>

      <div class="grid grid-cols-2 p-2">
        <h2 class="w-full col-span-2 p-1 px-2 my-2 text-base font-semibold text-white bg-black">
          Asset class breakdown
        </h2>
        <div class="flex flex-col items-center justify-start p-2">
          <Components.PieChart.render
            values={@ac_breakdown |> Enum.map(& &1[:weight_raw])}
            labels={@ac_breakdown |> Enum.map(& &1[:weight])}
            categories={@ac_breakdown |> Enum.map(& &1[:asset_class])}
            cat_label="Asset class"
          />
        </div>
        <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main data={@ac_breakdown} columns={[:asset_class, :weight]} />
        </div>
        <h2 class="w-full col-span-2 p-1 px-2 my-2 text-base font-semibold text-white bg-black">
          Top 5 positions
        </h2>
        <div class="flex flex-col items-center justify-start p-2">
          <Components.PieChart.render
            values={@top_5_data |> Enum.map(& &1[:weight_raw])}
            labels={@top_5_data |> Enum.map(& &1[:weight])}
            categories={@top_5_data |> Enum.map(& &1["id"])}
            cat_label="ID"
          />
        </div>
        <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main data={@top_5_data} columns={["id", :weight]} />
        </div>
      </div>
    </Layouts.Main.render>
    """
  end

  attr :ptf, :map, required: true

  def perf_chart(assigns) do
    data = assigns[:ptf]["perf"]

    chart_str =
      Vl.new(width: 700, height: 100)
      |> Vl.config(padding: 20)
      |> Vl.data(values: data)
      |> Vl.mark(:line)
      |> Vl.encode_field(:x, "date",
        type: :temporal,
        title: "Date",
        axis: [format: "%b %Y"]
      )
      |> Vl.encode_field(:y, "value",
        type: :quantitative,
        scale: [zero: false],
        title: "Performance"
      )
      |> Vl.encode_field(:color, "series",
        type: :nominal,
        scale: [scheme: "set2"],
        legend: [title: "Series", orient: "bottom"]
      )
      |> VegaLite.Convert.to_svg()

    assigns = assigns |> Map.put(:graph, chart_str)

    ~H"""
    <div class="w-full h-full">
      {raw(@graph)}
    </div>
    """
  end

  defp format_percentage(value, decimals \\ 2)
       when is_number(value) and is_integer(decimals) and decimals >= 0 do
    percent = value * 100

    formatted_number =
      :io_lib.format("~.#{decimals}f", [percent])
      |> IO.iodata_to_binary()

    formatted_number <> "%"
  end
end
