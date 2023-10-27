defmodule WorkflowGenerator.SystemFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WorkflowGenerator.System` context.
  """

  @doc """
  Generate a workflow.
  """
  def workflow_fixture(attrs \\ %{}) do
    {:ok, workflow} =
      attrs
      |> Enum.into(%{
        description: "some description",
        enabled: true,
        input: %{},
        name: "some name"
      })
      |> WorkflowGenerator.System.create_workflow()

    workflow
  end

  @doc """
  Generate a workflow_step.
  """
  def workflow_step_fixture(attrs \\ %{}) do
    {:ok, workflow_step} =
      attrs
      |> Enum.into(%{

      })
      |> WorkflowGenerator.System.create_workflow_step()

    workflow_step
  end

  @doc """
  Generate a step.
  """
  def step_fixture(attrs \\ %{}) do
    {:ok, step} =
      attrs
      |> Enum.into(%{
        code: "some code",
        input: %{},
        name: "some name"
      })
      |> WorkflowGenerator.System.create_step()

    step
  end
end
