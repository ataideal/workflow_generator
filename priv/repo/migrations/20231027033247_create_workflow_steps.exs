defmodule WorkflowGenerator.Repo.Migrations.CreateWorkflowSteps do
  use Ecto.Migration

  def change do
    create table(:workflow_steps) do
      add :step_id, references(:steps, on_delete: :nothing)
      add :workflow_id, references(:workflows, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:workflow_steps, [:step_id])
    create index(:workflow_steps, [:workflow_id])
  end
end
