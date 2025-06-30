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
    Nx.Random.key(System.os_time())
    |> Nx.Random.normal(loc, scale, shape: {len})
    |> elem(0)
    |> Nx.to_list()
  end

  def uniform(len, low, high) do
    Nx.Random.key(System.os_time())
    |> Nx.Random.uniform(low, high, shape: {len})
    |> elem(0)
    |> Nx.to_list()
  end

  defp string(len) when is_integer(len) and len >= 0 do
    alphabet =
      ~c"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    for _ <- 1..len, into: "", do: <<Enum.random(alphabet)>>
  end

  def sample(len, lst) do
    Nx.Random.key(System.os_time())
    |> Nx.Random.randint(0, length(lst), shape: {len})
    |> elem(0)
    |> Nx.to_list()
    |> Enum.map(&Enum.at(lst, &1))
  end

  def rebased_performance(len) do
    returns =
      Nx.Random.key(System.os_time())
      |> Nx.Random.normal(0, 0.01, shape: {len})
      |> elem(0)

    data =
      Nx.cumulative_sum(returns)
      |> Nx.exp()
      |> Nx.multiply(100)

    Nx.concatenate([Nx.tensor([100]), data], axis: 0)
    |> Nx.to_list()
  end

  def portfolios(n, ref_date) do
    n_inst = Simulator.integers(6, 20, n)
    ptf_ids = Simulator.strings(5, n)
    inst_ids = n_inst |> Enum.map(fn nn -> Simulator.strings(5, nn) end)

    inst_categories =
      n_inst |> Enum.map(fn nn -> Simulator.sample(nn, ["Equity", "Fixed income", "Cash"]) end)

    mean_values = Simulator.uniform(n, 500, 10000)

    values =
      Enum.zip([mean_values, n_inst])
      |> Enum.map(fn {mean, nn} ->
        Simulator.norm(nn, mean, 500) |> Enum.map(&Float.round(&1, 2))
      end)

    Enum.zip([ptf_ids, inst_ids, values, inst_categories])
    |> Enum.map(fn {ptf_id, inst_ids_, values_, inst_categories_} ->
      perf_dates = 1..500 |> Enum.reverse() |> Enum.map(&Date.add(ref_date, -&1 + 1))
      perf = rebased_performance(500)
      peer_perf = rebased_performance(500)

      perf_data =
        for {date, perf, peer_perf} <- Enum.zip([perf_dates, perf, peer_perf]),
            {label, value} <- [
              {"Fund performance", perf},
              {"Peer performance", peer_perf}
            ] do
          %{
            date: date,
            value: value,
            series: label
          }
        end

      %{
        id: ptf_id,
        perf: perf_data,
        data:
          Enum.zip([inst_ids_, values_, inst_categories_])
          |> Enum.map(fn {inst_id, value, cat} -> %{id: inst_id, value: value, category: cat} end)
      }
    end)
  end
end
