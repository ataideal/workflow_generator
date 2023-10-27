defmodule WorkflowGenerator.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :name, :string
      add :code, :text
      add :input, :map

      timestamps(type: :utc_datetime)
    end
  end
end
