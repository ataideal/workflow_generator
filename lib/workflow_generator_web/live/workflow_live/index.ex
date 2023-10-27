defmodule WorkflowGeneratorWeb.WorkflowLive.Index do
  use WorkflowGeneratorWeb, :live_view

  alias WorkflowGenerator.System
  alias WorkflowGenerator.System.Workflow

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      stream(socket, :workflows, System.list_workflows())
      |> assign(:steps, System.list_steps())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Workflow")
    |> assign(:workflow, System.get_workflow!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Workflow")
    |> assign(:workflow, %Workflow{steps: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workflows")
    |> assign(:workflow, nil)
  end

  @impl true
  def handle_info({WorkflowGeneratorWeb.WorkflowLive.FormComponent, {:saved, workflow}}, socket) do
    {:noreply, stream_insert(socket, :workflows, workflow)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workflow = System.get_workflow!(id)
    {:ok, _} = System.delete_workflow(workflow)

    {:noreply, stream_delete(socket, :workflows, workflow)}
  end
end
