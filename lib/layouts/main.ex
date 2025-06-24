defmodule Layouts.Main do
  use Phoenix.Component

  def main(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      rel="stylesheet"
      href={"file:///#{@css_path}"}
    />
    <style>
    @page {
      margin: 0;
    }
    </style>
    <title>Document</title>
    </head>
    <body class="bg-white h-screen w-screen flex flex-col p-8">
        <%= render_slot(@inner_block) %>
    </body>
    </html>
    """
  end
end
