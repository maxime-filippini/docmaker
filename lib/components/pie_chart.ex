defmodule Components.PieChart do
  use Phoenix.Component
  alias VegaLite, as: Vl
  import Phoenix.HTML, only: [raw: 1]

  attr :values, :list, required: true
  attr :labels, :list, required: true
  attr :categories, :list, required: true
  attr :cat_label, :string, required: true

  def render(assigns) do
    base =
      Vl.new(width: 200, height: 200)
      |> Vl.data_from_values(
        values: assigns[:values],
        labels: assigns[:labels],
        categories: assigns[:categories]
      )
      |> Vl.encode_field(:theta, "values", type: :quantitative, stack: true)
      |> Vl.encode(:order, field: "values", type: :quantitative, sort: "descending")
      |> Vl.encode_field(:color, "categories",
        type: :nominal,
        scale: [scheme: "set2"],
        legend: [title: assigns[:cat_label], orient: "right"]
      )

    arc_layer =
      base
      |> Vl.mark(:arc, outerRadius: 80)

    text_layer =
      base
      |> Vl.mark(:text, radius: 50, font_size: 12)
      |> Vl.encode_field(:text, "labels", type: :nominal)
      |> Vl.encode(:color, value: "white")

    graph =
      Vl.layers(base, [arc_layer, text_layer])

    svg =
      graph
      |> VegaLite.Convert.to_svg()

    assigns = assigns |> Map.put(:graph, svg)

    ~H"""
    <div class="w-full h-full">
      {raw(@graph)}
    </div>
    """
  end
end
