defmodule Utils.Poller do
  @sleep_interval 10

  def watch(path) when is_binary(path) do
    loop(path)
  end

  defp loop(path) do
    case File.ls(path) do
      {:ok, []} ->
        :ok

      {:ok, _files} ->
        Process.sleep(@sleep_interval)
        loop(path)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
