defmodule WorkflowGeneratorWeb.WorkflowLive.Show do
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
     |> assign(:workflow, System.get_workflow!(id))}
  end

  defp page_title(:show), do: "Show Workflow"
  defp page_title(:edit), do: "Edit Workflow"
end
