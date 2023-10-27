defmodule WorkflowGenerator.Repo.Migrations.CreateWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add :name, :string
      add :description, :string
      add :enabled, :boolean, default: false, null: false
      add :input, :map

      timestamps(type: :utc_datetime)
    end
  end
end
