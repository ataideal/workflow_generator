defmodule WorkflowGeneratorWeb.WorkflowStepLive.Index do
  use WorkflowGeneratorWeb, :live_view

  alias WorkflowGenerator.System
  alias WorkflowGenerator.System.WorkflowStep

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :workflow_steps, System.list_workflow_steps())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Workflow step")
    |> assign(:workflow_step, System.get_workflow_step!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Workflow step")
    |> assign(:workflow_step, %WorkflowStep{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workflow steps")
    |> assign(:workflow_step, nil)
  end

  @impl true
  def handle_info({WorkflowGeneratorWeb.WorkflowStepLive.FormComponent, {:saved, workflow_step}}, socket) do
    {:noreply, stream_insert(socket, :workflow_steps, workflow_step)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workflow_step = System.get_workflow_step!(id)
    {:ok, _} = System.delete_workflow_step(workflow_step)

    {:noreply, stream_delete(socket, :workflow_steps, workflow_step)}
  end
end
