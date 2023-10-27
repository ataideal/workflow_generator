defmodule WorkflowGeneratorWeb.WorkflowStepLive.FormComponent do
  use WorkflowGeneratorWeb, :live_component

  alias WorkflowGenerator.System

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage workflow_step records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="workflow_step-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Workflow step</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{workflow_step: workflow_step} = assigns, socket) do
    changeset = System.change_workflow_step(workflow_step)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"workflow_step" => workflow_step_params}, socket) do
    changeset =
      socket.assigns.workflow_step
      |> System.change_workflow_step(workflow_step_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"workflow_step" => workflow_step_params}, socket) do
    save_workflow_step(socket, socket.assigns.action, workflow_step_params)
  end

  defp save_workflow_step(socket, :edit, workflow_step_params) do
    case System.update_workflow_step(socket.assigns.workflow_step, workflow_step_params) do
      {:ok, workflow_step} ->
        notify_parent({:saved, workflow_step})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow step updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_workflow_step(socket, :new, workflow_step_params) do
    case System.create_workflow_step(workflow_step_params) do
      {:ok, workflow_step} ->
        notify_parent({:saved, workflow_step})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow step created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
