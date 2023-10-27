defmodule WorkflowGenerator.System.WorkflowStep do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workflow_steps" do

    field :step_id, :id
    field :workflow_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workflow_step, attrs) do
    workflow_step
    |> cast(attrs, [])
    |> validate_required([])
  end
end
