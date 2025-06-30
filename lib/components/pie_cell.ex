defmodule Components.PieCell do
  use Phoenix.Component
  import Phoenix.HTML, only: [raw: 1]
  alias VegaLite, as: Vl

  def main(assigns) do
    ptf = assigns[:ptf]
    spec = build_pie_chart(ptf["data"])

    bin = VegaLite.Convert.to_html(spec)
    safe_svg = raw(bin)

    assigns = assigns |> Map.put(:graph, safe_svg)

    ~H"""
    <div class="flex flex-col w-full gap-2">
      <h2 class="text-xl font-semibold">{@title}</h2>
      <div class="flex items-center justify-center">
        {@graph}
      </div>
    </div>
    """
  end

  defp build_pie_chart(data) do
    prepared =
      data
      |> prepare_top5()

    base =
      Vl.new(width: 400, height: 200)
      |> Vl.data_from_values(prepared)
      |> Vl.encode_field(:theta, "total", type: :quantitative, stack: true)
      |> Vl.encode_field(:color, "instrument", type: :nominal, scale: [scheme: "set2"])

    arc_layer =
      base
      |> Vl.mark(:arc, outerRadius: 80)

    text_layer =
      base
      |> Vl.mark(:text, radius: 120)
      |> Vl.encode_field(:text, "label", type: :nominal)
      |> Vl.encode_field(:tooltip, "instrument", type: :nominal)

    Vl.layers(base, [arc_layer, text_layer])
  end

  defp prepare_top5(data, count \\ 5) do
    sum = data |> Enum.sum_by(& &1["value"])

    sorted =
      data
      |> Enum.map(&Map.put(&1, "value", &1["value"] / sum))
      |> Enum.sort_by(& &1["value"], &>=/2)

    {top, rest} = Enum.split(sorted, count)

    others_total =
      rest
      |> Enum.map(& &1["value"])
      |> Enum.reduce(0, fn v, acc -> acc + v end)

    top_mapped =
      Enum.map(top, fn %{"id" => id, "value" => value} ->
        %{instrument: to_string(id), total: value}
      end)

    all = top_mapped ++ [%{instrument: "Others", total: others_total}]

    all
    |> Enum.map(fn m -> Map.put(m, :label, format_percentage(m[:total])) end)
  end

  defp format_percentage(value, decimals \\ 1)
       when is_number(value) and is_integer(decimals) and decimals >= 0 do
    percent = value * 100

    formatted_number =
      :io_lib.format("~.#{decimals}f", [percent])
      |> IO.iodata_to_binary()

    formatted_number <> "%"
  end
end
