defmodule Examples.Html do
  def interpolation(doc_title, body, output) do
    html = """
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
      </head>
      <body>
        <h1>#{doc_title}</h1>
        <p>#{body}</p>
      </body>
    </html>
    """

    File.write!(output, html)
  end
end

defmodule Examples.LinkList do
  use Phoenix.Component

  attr :title, :string, required: true
  attr :links, :list, default: []

  def render(assigns) do
    ~H"""
    <div>
      <h1>{@title}</h1>
      <ul>
        <li :for={link <- @links}>
          <a href={link.href}>{link.title}</a>
        </li>
      </ul>
    </div>
    """
  end
end

defmodule Examples.Multiplier do
  use Phoenix.Component

  attr :n, :integer, required: true
  attr :title, :string, required: true
  attr :links, :list, default: []

  def render(assigns) do
    ~H"""
    <div :for={_ <- 1..@n}>
      <Examples.LinkList.render title={@title} links={@links} />
    </div>
    """
  end
end

defmodule Examples.HigherOrderComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>{@doc_title}</title>
      </head>
      <body>
        {@inner_block}
      </body>
    </html>
    """
  end
end
