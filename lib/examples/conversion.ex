defmodule Examples.Conversion do
  @doc """
  Convert an HTML file to a PDF.
  """
  def convert_file(path_to_html, path_to_pdf) do
    ChromicPDF.print_to_pdf({:file, path_to_html}, output: path_to_pdf)
  end

  @doc """
  Convert an HTML string to a PDF.
  """
  def convert_string(html, path_to_pdf) do
    ChromicPDF.print_to_pdf({:html, html}, output: path_to_pdf)
  end

  def convert_many_files(html_paths, pdf_paths) do
    Enum.zip(html_paths, pdf_paths)
    # Perform asynchronous PDF conversions
    |> Task.async_stream(fn {html_path, pdf_path} ->
      ChromicPDF.print_to_pdf({:file, html_path}, output: pdf_path)
    end)
    # Collect the results
    |> Enum.to_list()
  end
end
