# Simulated data

ptfs = Simulator.portfolios(1)

for ptf <- ptfs do
  html =
    Docmaker.render(
      Layouts.Grid.main(%{
        ptf: ptf,
        current_date: ~D"2024-12-31",
        css_path: "/Users/maximefilippini/personal/dev/serious/docmaker/output/app.css"
      })
    )

  File.write!("/Users/maximefilippini/personal/dev/serious/docmaker/output/out.html", html)

  # ChromicPDF.print_to_pdf({:html, html}, output: "output/output_#{ptf.id}.pdf")
end
