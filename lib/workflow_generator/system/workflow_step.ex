defmodule WorkflowGenerator.System.WorkflowStep do
  use Ecto.Schema
  import Ecto.Changeset
  alias WorkflowGenerator.System.Step
  alias WorkflowGenerator.System.Workflow

  schema "workflow_steps" do
    belongs_to :step, Step
    belongs_to :workflow, Workflow

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workflow_step, attrs) do
    workflow_step
    |> cast(attrs, [:step_id])
    |> validate_required([])
  end
end
