defmodule WorkflowGenerator.System do
  @moduledoc """
  The System context.
  """

  import Ecto.Query, warn: false
  alias WorkflowGenerator.Repo

  alias WorkflowGenerator.System.Workflow

  @doc """
  Returns the list of workflows.

  ## Examples

      iex> list_workflows()
      [%Workflow{}, ...]

  """
  def list_workflows do
    Repo.all(Workflow) |> Repo.preload(:steps)
  end

  @doc """
  Gets a single workflow.

  Raises `Ecto.NoResultsError` if the Workflow does not exist.

  ## Examples

      iex> get_workflow!(123)
      %Workflow{}

      iex> get_workflow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workflow!(id), do: Repo.get!(Workflow, id) |> Repo.preload(:steps)

  @doc """
  Creates a workflow.

  ## Examples

      iex> create_workflow(%{field: value})
      {:ok, %Workflow{}}

      iex> create_workflow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workflow(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow.

  ## Examples

      iex> update_workflow(workflow, %{field: new_value})
      {:ok, %Workflow{}}

      iex> update_workflow(workflow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workflow(%Workflow{} = workflow, attrs) do
    workflow
    |> Workflow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workflow.

  ## Examples

      iex> delete_workflow(workflow)
      {:ok, %Workflow{}}

      iex> delete_workflow(workflow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workflow(%Workflow{} = workflow) do
    Repo.delete(workflow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow changes.

  ## Examples

      iex> change_workflow(workflow)
      %Ecto.Changeset{data: %Workflow{}}

  """
  def change_workflow(%Workflow{} = workflow, attrs \\ %{}) do
    Workflow.changeset(workflow, attrs)
  end

  alias WorkflowGenerator.System.WorkflowStep

  @doc """
  Returns the list of workflow_steps.

  ## Examples

      iex> list_workflow_steps()
      [%WorkflowStep{}, ...]

  """
  def list_workflow_steps do
    Repo.all(WorkflowStep)
  end

  @doc """
  Gets a single workflow_step.

  Raises `Ecto.NoResultsError` if the Workflow step does not exist.

  ## Examples

      iex> get_workflow_step!(123)
      %WorkflowStep{}

      iex> get_workflow_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workflow_step!(id), do: Repo.get!(WorkflowStep, id)

  @doc """
  Creates a workflow_step.

  ## Examples

      iex> create_workflow_step(%{field: value})
      {:ok, %WorkflowStep{}}

      iex> create_workflow_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workflow_step(attrs \\ %{}) do
    %WorkflowStep{}
    |> WorkflowStep.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow_step.

  ## Examples

      iex> update_workflow_step(workflow_step, %{field: new_value})
      {:ok, %WorkflowStep{}}

      iex> update_workflow_step(workflow_step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workflow_step(%WorkflowStep{} = workflow_step, attrs) do
    workflow_step
    |> WorkflowStep.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workflow_step.

  ## Examples

      iex> delete_workflow_step(workflow_step)
      {:ok, %WorkflowStep{}}

      iex> delete_workflow_step(workflow_step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workflow_step(%WorkflowStep{} = workflow_step) do
    Repo.delete(workflow_step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow_step changes.

  ## Examples

      iex> change_workflow_step(workflow_step)
      %Ecto.Changeset{data: %WorkflowStep{}}

  """
  def change_workflow_step(%WorkflowStep{} = workflow_step, attrs \\ %{}) do
    WorkflowStep.changeset(workflow_step, attrs)
  end

  alias WorkflowGenerator.System.Step

  @doc """
  Returns the list of steps.

  ## Examples

      iex> list_steps()
      [%Step{}, ...]

  """
  def list_steps do
    Repo.all(Step)
  end

  @doc """
  Gets a single step.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step!(123)
      %Step{}

      iex> get_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step!(id), do: Repo.get!(Step, id)

  @doc """
  Creates a step.

  ## Examples

      iex> create_step(%{field: value})
      {:ok, %Step{}}

      iex> create_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step(attrs \\ %{}) do
    %Step{}
    |> Step.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step.

  ## Examples

      iex> update_step(step, %{field: new_value})
      {:ok, %Step{}}

      iex> update_step(step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step(%Step{} = step, attrs) do
    step
    |> Step.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, step} ->
        %{workflows: workflows} = Repo.preload(step, workflows: [:steps])
        Enum.each(workflows, &WorkflowGenerator.Generator.generate_module/1)
        {:ok, step}
      {:error, error} ->
        {:error, error}
    end

  end

  @doc """
  Deletes a step.

  ## Examples

      iex> delete_step(step)
      {:ok, %Step{}}

      iex> delete_step(step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step(%Step{} = step) do
    Repo.delete(step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step changes.

  ## Examples

      iex> change_step(step)
      %Ecto.Changeset{data: %Step{}}

  """
  def change_step(%Step{} = step, attrs \\ %{}) do
    Step.changeset(step, attrs)
  end
end
