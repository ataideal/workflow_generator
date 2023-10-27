defmodule WorkflowGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WorkflowGeneratorWeb.Telemetry,
      WorkflowGenerator.Repo,
      {DNSCluster, query: Application.get_env(:workflow_generator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WorkflowGenerator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WorkflowGenerator.Finch},
      # Start a worker by calling: WorkflowGenerator.Worker.start_link(arg)
      # {WorkflowGenerator.Worker, arg},
      # Start to serve requests, typically the last entry
      WorkflowGeneratorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WorkflowGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WorkflowGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
