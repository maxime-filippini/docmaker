defmodule FileWatcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  @impl true
  def handle_info({:file_event, _watcher_pid, {path, events}}, state) do
    IO.puts("📂 Events detected!")

    event_str =
      events
      |> Enum.map(&Atom.to_string/1)
      |> Enum.join(", ")

    IO.puts("Path: #{path} - Events: #{event_str}")

    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}
end

folder = "/Users/maximefilippini/personal/dev/serious/docmaker/data"

# Start the GenServer that will watch our folder
FileWatcher.start_link(dirs: [folder])

# Create a file in the folder
Path.join([folder, "helloworld"])
|> File.write!("Hello, World!")

# 📂 Events detected!
# Path: /Users/maximefilippini/personal/dev/serious/docmaker/data/helloworld - Events: created, modified
