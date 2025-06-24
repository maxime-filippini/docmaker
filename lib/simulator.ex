defmodule Simulator do
  def integers(low, high, n_sim) do
    1..n_sim
    |> Enum.map(fn _ -> Enum.random(low..high) end)
  end

  def strings(len, n_sim) do
    1..n_sim
    |> Enum.map(fn _ -> string(len) end)
  end

  def norm(len, loc, scale) do
    Nx.Random.key(42)
    |> Nx.Random.normal(loc, scale, shape: {len})
    |> elem(0)
    |> Nx.to_list()
  end

  def uniform(len, low, high) do
    Nx.Random.key(42)
    |> Nx.Random.uniform(low, high, shape: {len})
    |> elem(0)
    |> Nx.to_list()
  end

  defp string(len) when is_integer(len) and len >= 0 do
    alphabet =
      ~c"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    for _ <- 1..len, into: "", do: <<Enum.random(alphabet)>>
  end

  def portfolios(n) do
    n_inst = Simulator.integers(5, 20, n)
    ptf_ids = Simulator.strings(5, n)
    inst_ids = n_inst |> Enum.map(fn nn -> Simulator.strings(5, nn) end)
    mean_values = Simulator.uniform(n, 500, 10000)

    values =
      mean_values
      |> Enum.zip(n_inst)
      |> Enum.map(fn {mean, nn} ->
        Simulator.norm(nn, mean, 500)
        |> Enum.map(&Float.round(&1, 2))
      end)

    Enum.zip(ptf_ids, inst_ids)
    |> Enum.zip(values)
    |> Enum.map(fn {{ptf_id, inst_ids_}, values_} ->
      %{
        id: ptf_id,
        data:
          Enum.zip(inst_ids_, values_)
          |> Enum.map(fn {inst_id, value} -> %{id: inst_id, value: value} end)
      }
    end)
  end
end
