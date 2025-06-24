defmodule Layouts.Grid do
  use Phoenix.Component

  def main(assigns) do
    top_5 =
      assigns.ptf.data
      |> Enum.sort_by(& &1[:value], &>=/2)
      |> Enum.take(5)

    assigns = Map.put(assigns, :top_5_data, top_5)

    ~H"""
    <Layouts.Main.main css_path={@css_path}>
    <div class="flex items-center justify-center h-16 w-full">
      <h1 class="font-semibold text-xl w-full text-center">
        Report for {@ptf.id} - {@current_date}
      </h1>
    </div>
    <div class="grid flex-1 grid-rows-3 grid-cols-2">
      <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main title="Top 5 positions" data={@top_5_data} />
      </div>
      <div class="flex flex-col items-center justify-start p-2">
          <Components.PieCell.main title="Breakdown" ptf={@ptf}/>
      </div>
      <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main title="Top 5 positions" data={@top_5_data} />
      </div>
      <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main title="Top 5 positions" data={@top_5_data} />
      </div>
      <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main title="Top 5 positions" data={@top_5_data} />
      </div>
      <div class="flex flex-col items-center justify-start p-2">
          <Components.TableCell.main title="Top 5 positions" data={@top_5_data} />
      </div>
    </div>
    </Layouts.Main.main>
    """
  end

  def top_5(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 h-full">
    <h2 class="text-xl font-semibold">Top 5 positions</h2>



    </div>
    """
  end
end
