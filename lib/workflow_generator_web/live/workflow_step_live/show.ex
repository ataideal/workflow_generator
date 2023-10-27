defmodule WorkflowGeneratorWeb.WorkflowStepLive.Show do
  use WorkflowGeneratorWeb, :live_view

  alias WorkflowGenerator.System

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:workflow_step, System.get_workflow_step!(id))}
  end

  defp page_title(:show), do: "Show Workflow step"
  defp page_title(:edit), do: "Edit Workflow step"
end
