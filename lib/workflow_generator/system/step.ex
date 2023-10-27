defmodule WorkflowGenerator.System.Step do
  use Ecto.Schema
  import Ecto.Changeset
  alias WorkflowGenerator.System.WorkflowStep

  schema "steps" do
    field :code, :string
    field :input, :map
    field :name, :string

    has_many :workflow_steps, WorkflowStep
    has_many :workflows, through: [:workflow_steps, :workflow]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:name, :code, :input])
    |> validate_required([:name, :code])
  end
end
