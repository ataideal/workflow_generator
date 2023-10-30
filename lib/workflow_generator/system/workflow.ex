defmodule WorkflowGenerator.System.Workflow do
  use Ecto.Schema
  import Ecto.Changeset

  alias WorkflowGenerator.System.WorkflowStep
  alias WorkflowGenerator.System.Step


  schema "workflows" do
    field :description, :string
    field :enabled, :boolean, default: false
    field :input, :map
    field :name, :string

    has_many :workflow_steps, WorkflowStep, on_delete: :delete_all, on_replace: :delete
    has_many :steps, through: [:workflow_steps, :step]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:name, :description, :enabled, :input])
    |> cast_assoc(:workflow_steps)
    |> validate_required([:name, :description, :enabled])
    |> IO.inspect()
  end

end
