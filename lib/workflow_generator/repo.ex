defmodule WorkflowGenerator.Repo do
  use Ecto.Repo,
    otp_app: :workflow_generator,
    adapter: Ecto.Adapters.Postgres
end
