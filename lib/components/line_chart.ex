defmodule Components.LineChart do
  use Phoenix.Component
  alias VegaLite, as: Vl
  import Phoenix.HTML, only: [raw: 1]

  attr :data, :list, required: true
  attr :x_col, :string, required: true
  attr :value_col, :string, required: true
  attr :title, :string, required: true

  def render(assigns) do
    svg =
      Vl.new(width: 700, height: 100)
      |> Vl.config(padding: 20)
      |> Vl.data(values: assigns[:data])
      |> Vl.mark(:line)
      |> Vl.encode_field(:x, "date",
        type: :temporal,
        title: "Date",
        axis: [format: "%b %Y"]
      )
      |> Vl.encode_field(:y, "value",
        type: :quantitative,
        scale: [zero: false],
        title: assigns[:title]
      )
      |> Vl.encode_field(:color, "series",
        type: :nominal,
        scale: [scheme: "set2"],
        legend: [title: "Series", orient: "bottom"]
      )
      |> VegaLite.Convert.to_svg()

    assigns = assigns |> Map.put(:graph, svg)

    ~H"""
    <div class="w-full h-full">
      {raw(@graph)}
    </div>
    """
  end
end
