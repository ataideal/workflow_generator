defmodule WorkflowGeneratorWeb.WorkflowLive.FormComponent do
  use WorkflowGeneratorWeb, :live_component

  alias WorkflowGenerator.System

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage workflow records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="workflow-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:enabled]} type="checkbox" label="Enabled" />
        <label for={@uploads.input.ref}>Input</label>
        <.live_file_input upload={@uploads.input} />
        <.input field={@form[:steps]} type="select" label="Steps" options={Enum.map(@steps, & {&1.name, &1.id})} value={Enum.map(@workflow.steps, & &1.id)} multiple />

        <:actions>
          <.button phx-disable-with="Saving...">Save Workflow</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{workflow: workflow} = assigns, socket) do
    changeset = System.change_workflow(workflow)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:input, accept: ~w(.json), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"workflow" => workflow_params}, socket) do
    changeset =
      socket.assigns.workflow
      |> System.change_workflow(workflow_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"workflow" => workflow_params}, socket) do
    input_upload =
      consume_uploaded_entries(socket, :input, fn %{path: path}, _entry ->
        {:ok, file} = File.read(path)
        Jason.decode(file)
      end)
      |> List.first()

    workflow_params =
      if input_upload do
        Map.put(workflow_params, "input", input_upload)
      else
        workflow_params
      end

    workflow_params =
      if workflow_params["steps"] do
        steps = workflow_params["steps"] |> Enum.map(& %{"step_id" => &1})
        Map.put(workflow_params, "workflow_steps", steps)
      else
        workflow_params
      end

    dbg(workflow_params)

    save_workflow(socket, socket.assigns.action, workflow_params)
  end

  defp save_workflow(socket, :edit, workflow_params) do
    case System.update_workflow(socket.assigns.workflow, workflow_params) do
      {:ok, workflow} ->
        notify_parent({:saved, workflow})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_workflow(socket, :new, workflow_params) do
    case System.create_workflow(workflow_params) do
      {:ok, workflow} ->
        notify_parent({:saved, workflow})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow created successfully")
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
