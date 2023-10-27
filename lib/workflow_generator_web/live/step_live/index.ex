defmodule WorkflowGeneratorWeb.StepLive.Index do
  use WorkflowGeneratorWeb, :live_view

  alias WorkflowGenerator.System
  alias WorkflowGenerator.System.Step

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :steps, System.list_steps())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Step")
    |> assign(:step, System.get_step!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Step")
    |> assign(:step, %Step{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Steps")
    |> assign(:step, nil)
  end

  @impl true
  def handle_info({WorkflowGeneratorWeb.StepLive.FormComponent, {:saved, step}}, socket) do
    {:noreply, stream_insert(socket, :steps, step)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    step = System.get_step!(id)
    {:ok, _} = System.delete_step(step)

    {:noreply, stream_delete(socket, :steps, step)}
  end
end
