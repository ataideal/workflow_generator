defmodule WorkflowGenerator.System.Step do
  use Ecto.Schema
  import Ecto.Changeset

  schema "steps" do
    field :code, :string
    field :input, :map
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:name, :code, :input])
    |> validate_required([:name, :code])
  end
end
