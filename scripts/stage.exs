dir_path = "/Users/maximefilippini/personal/dev/serious/docmaker/data"

# Allow for passing the number of portfolios as an argument
# to the script
n = System.argv() |> Enum.at(0) |> String.to_integer()

# This function simulates `n` portfolio at the date provided
Simulator.portfolios(n, ~D"2024-12-31")
|> Enum.map(fn ptf ->
  File.write!(
    "#{dir_path}/docreq_#{ptf.id}.json",
    JSON.encode!(ptf)
  )
end)

# Time the execution - i.e. until the data folder is empty
{time, result} =
  :timer.tc(fn ->
    Utils.Poller.watch(dir_path)
  end)

case result do
  :ok ->
    IO.puts("Ran in #{time / 1_000_000} seconds")

  {:error, reason} ->
    IO.puts("Error: #{reason}")
end
