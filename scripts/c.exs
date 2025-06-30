alias VegaLite, as: Vl

ptf =
  Simulator.portfolios(1)
  |> Enum.at(0)

IO.inspect(ptf[:perf_data])

chart =
  Vl.new(width: 800, height: 200)
  |> Vl.config(padding: 20)
  |> Vl.data(values: ptf[:perf])
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
  |> VegaLite.Convert.save!("hi.png")
