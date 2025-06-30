defmodule Layouts.Main do
  use Phoenix.Component

  attr :css_path, :string, required: true
  attr :watermark?, :boolean, default: false
  slot :inner_block

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href={"file:///#{@css_path}"} />
        <style>
          @page {
            margin: 0;
            size: A4;
          }
        </style>
        <title>Document</title>
      </head>
      <body class="bg-white max-h-[1122px] overflow-auto w-screen flex flex-col p-2">
        <div class="w-full h-full">
          {render_slot(@inner_block)}
        </div>
        <%= if @watermark? do %>
          <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
            <p class="text-[10rem] font-bold text-gray-300 opacity-40 rotate-[-45deg] whitespace-nowrap">
              SAMPLE
            </p>
          </div>
        <% end %>
      </body>
    </html>
    """
  end
end
