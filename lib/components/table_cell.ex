defmodule Components.TableCell do
  use Phoenix.Component

  attr :data, :map, required: true
  attr :columns, :list, default: []

  def main(assigns) do
    columns =
      if assigns.columns == [] do
        assigns.data |> List.first() |> Map.keys()
      else
        assigns.columns
      end

    assigns = assigns |> Map.put(:columns, columns)

    ~H"""
    <div class="flex flex-col justify-start w-full gap-2">
      <div class="w-full overflow-x-auto">
        <table class="w-full divide-y divide-gray-200 table-auto">
          <thead class="bg-gray-50">
            <tr class="h-8">
              <th
                :for={col <- @columns}
                class="px-4 py-2 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
              >
                {col
                |> to_string()
                |> String.replace("_", " ")
                |> String.capitalize()}
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <%= for row <- @data do %>
              <tr class="h-8">
                <%= for col <- @columns do %>
                  <td class="px-4 py-1 text-xs text-gray-700 whitespace-nowrap">
                    {Map.get(row, col)}
                  </td>
                <% end %>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
