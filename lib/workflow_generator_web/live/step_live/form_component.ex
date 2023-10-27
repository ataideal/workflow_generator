defmodule WorkflowGeneratorWeb.StepLive.FormComponent do
  use WorkflowGeneratorWeb, :live_component

  alias WorkflowGenerator.System

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage step records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="step-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Step</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{step: step} = assigns, socket) do
    changeset = System.change_step(step)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"step" => step_params}, socket) do
    changeset =
      socket.assigns.step
      |> System.change_step(step_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"step" => step_params}, socket) do
    save_step(socket, socket.assigns.action, step_params)
  end

  defp save_step(socket, :edit, step_params) do
    case System.update_step(socket.assigns.step, step_params) do
      {:ok, step} ->
        notify_parent({:saved, step})

        {:noreply,
         socket
         |> put_flash(:info, "Step updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_step(socket, :new, step_params) do
    case System.create_step(step_params) do
      {:ok, step} ->
        notify_parent({:saved, step})

        {:noreply,
         socket
         |> put_flash(:info, "Step created successfully")
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
