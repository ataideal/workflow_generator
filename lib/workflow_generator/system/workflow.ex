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

    has_many :workflow_steps, WorkflowStep
    has_many :steps, through: [:workflow_steps, :steps]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workflow, attrs) do
    attrs = cast_json(attrs, :input)

    workflow
    |> cast(attrs, [:name, :description, :enabled, :input])
    |> validate_required([:name, :description, :enabled])
  end

  defp cast_json(attrs, field) do
    if is_binary(attrs[field])  do
      Jason.decode(attrs[field])
    else
      attrs[field]
    end
  end
end
