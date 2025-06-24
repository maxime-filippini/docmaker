defmodule Components.TableCell do
  use Phoenix.Component

  def main(assigns) do
    assigns =
      assigns
      |> Map.put(
        :columns,
        assigns.data
        |> List.first()
        |> Map.keys()
      )

    ~H"""
    <div class="flex flex-col gap-2 w-full">
      <h2 class="text-xl font-semibold">{@title}</h2>
      <div class="overflow-x-auto w-full">
        <table class="table-auto w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>

                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider" :for={col <- @columns}>
                  <%= col
                    |> to_string()
                    |> String.replace("_", " ")
                    |> String.capitalize() %>
                </th>

            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <%= for row <- @data do %>
              <tr>
                <%= for col <- @columns do %>
                  <td class="px-4 py-2 whitespace-nowrap text-sm text-gray-700">
                    <%= Map.get(row, col) %>
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
