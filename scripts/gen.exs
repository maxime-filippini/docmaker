# Simulated data

ptfs = Simulator.portfolios(1)

for ptf <- ptfs do
  target_path = "/Users/maximefilippini/personal/dev/serious/docmaker/output/out.html"

  IO.inspect(ptf)

  Docmaker.render_file(
    target_path,
    Layouts.Grid.main(%{
      ptf: ptf,
      current_date: ~D"2024-12-31",
      css_path: "/Users/maximefilippini/personal/dev/serious/docmaker/output/app.css"
    })
  )

  ChromicPDF.print_to_pdf({:file, target_path}, output: "output/output_#{ptf.id}.pdf")
end
