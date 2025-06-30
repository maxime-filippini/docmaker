defmodule Docmaker.FileWatcher do
  use GenStage

  def start_link(opts) do
    # Get the folder to watch from the provided options
    folder = Keyword.fetch!(opts, :folder)
    GenStage.start_link(__MODULE__, folder, opts)
  end

  @impl true
  def init(folder) do
    # Set up of file watcher
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [folder])
    FileSystem.subscribe(watcher_pid)

    # State for our pipeline step
    state = %{
      folder: folder,
      queue: :queue.new(),
      demand: 0
    }

    # We tell GenStage this is a producer step
    {:producer, state}
  end

  @impl true
  def handle_demand(incoming_demand, state) do
    # Upon demand, dispatch available events (i.e. file paths)
    new_state = %{state | demand: state.demand + incoming_demand}
    dispatch_events(new_state)
  end

  @impl true
  def handle_info({:file_event, _watcher_pid, {path, events}}, state) do
    # This is called upon receiving a file event. We queue the file
    # and immediately dispatch. If there is no demand, nothing will happen.
    # If there is demand, the file will be sent on its own.
    filename = Path.basename(path)
    pattern = ~r/^docreq_[\w-]+\.json$/

    if :created in events and :removed not in events and filename =~ pattern do
      {:ok, content} =
        File.read!(path)
        |> JSON.decode()

      queue = :queue.in({path, content}, state.queue)
      new_state = %{state | queue: queue}
      dispatch_events(new_state)
    else
      {:noreply, [], state}
    end
  end

  def handle_info(_msg, state), do: {:noreply, [], state}

  defp dispatch_events(%{demand: demand, queue: queue} = state) when demand > 0 do
    # Only dispatch events based on passed demand
    {events, new_queue} = dequeue(queue, demand, [])
    sent = length(events)
    new_state = %{state | queue: new_queue, demand: demand - sent}
    {:noreply, events, new_state}
  end

  defp dispatch_events(state) do
    # No demand or no files
    {:noreply, [], state}
  end

  defp dequeue(queue, 0, acc), do: {Enum.reverse(acc), queue}

  defp dequeue(queue, count, acc) do
    case :queue.out(queue) do
      {{:value, item}, rest} ->
        dequeue(rest, count - 1, [item | acc])

      {:empty, _} ->
        {Enum.reverse(acc), queue}
    end
  end
end
