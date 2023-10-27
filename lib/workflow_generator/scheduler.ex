defmodule WorkflowGenerator.Scheduler do
  use GenServer
  alias WorkflowGenerator.System
  alias WorkflowGenerator.Generator
  # Callbacks

  @impl true
  def init(state \\ %{}) do
    {:ok, state, {:continue, :warmup}}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end
  WorkflowGenerator.Generator

  @impl true
  def handle_continue(:warmup, state) do
    Enum.each(System.list_workflows, &Generator.generate_module/1)

    {:noreply, state, {:continue, :start}}
  end


  @impl true
  def handle_continue(:start, state) do
    Process.send(self(), :run, [])

    {:noreply, state}
  end

  @impl true
  def handle_info(:run, state) do
    Enum.each(System.list_workflows, &Generator.execute_workflow/1)
    Process.send_after(self(), :run, 5000)

    {:noreply, state}
  end


end
