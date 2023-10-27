defmodule WorkflowGenerator.SystemTest do
  use WorkflowGenerator.DataCase

  alias WorkflowGenerator.System

  describe "workflows" do
    alias WorkflowGenerator.System.Workflow

    import WorkflowGenerator.SystemFixtures

    @invalid_attrs %{description: nil, enabled: nil, input: nil, name: nil}

    test "list_workflows/0 returns all workflows" do
      workflow = workflow_fixture()
      assert System.list_workflows() == [workflow]
    end

    test "get_workflow!/1 returns the workflow with given id" do
      workflow = workflow_fixture()
      assert System.get_workflow!(workflow.id) == workflow
    end

    test "create_workflow/1 with valid data creates a workflow" do
      valid_attrs = %{description: "some description", enabled: true, input: %{}, name: "some name"}

      assert {:ok, %Workflow{} = workflow} = System.create_workflow(valid_attrs)
      assert workflow.description == "some description"
      assert workflow.enabled == true
      assert workflow.input == %{}
      assert workflow.name == "some name"
    end

    test "create_workflow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System.create_workflow(@invalid_attrs)
    end

    test "update_workflow/2 with valid data updates the workflow" do
      workflow = workflow_fixture()
      update_attrs = %{description: "some updated description", enabled: false, input: %{}, name: "some updated name"}

      assert {:ok, %Workflow{} = workflow} = System.update_workflow(workflow, update_attrs)
      assert workflow.description == "some updated description"
      assert workflow.enabled == false
      assert workflow.input == %{}
      assert workflow.name == "some updated name"
    end

    test "update_workflow/2 with invalid data returns error changeset" do
      workflow = workflow_fixture()
      assert {:error, %Ecto.Changeset{}} = System.update_workflow(workflow, @invalid_attrs)
      assert workflow == System.get_workflow!(workflow.id)
    end

    test "delete_workflow/1 deletes the workflow" do
      workflow = workflow_fixture()
      assert {:ok, %Workflow{}} = System.delete_workflow(workflow)
      assert_raise Ecto.NoResultsError, fn -> System.get_workflow!(workflow.id) end
    end

    test "change_workflow/1 returns a workflow changeset" do
      workflow = workflow_fixture()
      assert %Ecto.Changeset{} = System.change_workflow(workflow)
    end
  end

  describe "workflow_steps" do
    alias WorkflowGenerator.System.WorkflowStep

    import WorkflowGenerator.SystemFixtures

    @invalid_attrs %{}

    test "list_workflow_steps/0 returns all workflow_steps" do
      workflow_step = workflow_step_fixture()
      assert System.list_workflow_steps() == [workflow_step]
    end

    test "get_workflow_step!/1 returns the workflow_step with given id" do
      workflow_step = workflow_step_fixture()
      assert System.get_workflow_step!(workflow_step.id) == workflow_step
    end

    test "create_workflow_step/1 with valid data creates a workflow_step" do
      valid_attrs = %{}

      assert {:ok, %WorkflowStep{} = workflow_step} = System.create_workflow_step(valid_attrs)
    end

    test "create_workflow_step/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System.create_workflow_step(@invalid_attrs)
    end

    test "update_workflow_step/2 with valid data updates the workflow_step" do
      workflow_step = workflow_step_fixture()
      update_attrs = %{}

      assert {:ok, %WorkflowStep{} = workflow_step} = System.update_workflow_step(workflow_step, update_attrs)
    end

    test "update_workflow_step/2 with invalid data returns error changeset" do
      workflow_step = workflow_step_fixture()
      assert {:error, %Ecto.Changeset{}} = System.update_workflow_step(workflow_step, @invalid_attrs)
      assert workflow_step == System.get_workflow_step!(workflow_step.id)
    end

    test "delete_workflow_step/1 deletes the workflow_step" do
      workflow_step = workflow_step_fixture()
      assert {:ok, %WorkflowStep{}} = System.delete_workflow_step(workflow_step)
      assert_raise Ecto.NoResultsError, fn -> System.get_workflow_step!(workflow_step.id) end
    end

    test "change_workflow_step/1 returns a workflow_step changeset" do
      workflow_step = workflow_step_fixture()
      assert %Ecto.Changeset{} = System.change_workflow_step(workflow_step)
    end
  end

  describe "steps" do
    alias WorkflowGenerator.System.Step

    import WorkflowGenerator.SystemFixtures

    @invalid_attrs %{code: nil, input: nil, name: nil}

    test "list_steps/0 returns all steps" do
      step = step_fixture()
      assert System.list_steps() == [step]
    end

    test "get_step!/1 returns the step with given id" do
      step = step_fixture()
      assert System.get_step!(step.id) == step
    end

    test "create_step/1 with valid data creates a step" do
      valid_attrs = %{code: "some code", input: %{}, name: "some name"}

      assert {:ok, %Step{} = step} = System.create_step(valid_attrs)
      assert step.code == "some code"
      assert step.input == %{}
      assert step.name == "some name"
    end

    test "create_step/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System.create_step(@invalid_attrs)
    end

    test "update_step/2 with valid data updates the step" do
      step = step_fixture()
      update_attrs = %{code: "some updated code", input: %{}, name: "some updated name"}

      assert {:ok, %Step{} = step} = System.update_step(step, update_attrs)
      assert step.code == "some updated code"
      assert step.input == %{}
      assert step.name == "some updated name"
    end

    test "update_step/2 with invalid data returns error changeset" do
      step = step_fixture()
      assert {:error, %Ecto.Changeset{}} = System.update_step(step, @invalid_attrs)
      assert step == System.get_step!(step.id)
    end

    test "delete_step/1 deletes the step" do
      step = step_fixture()
      assert {:ok, %Step{}} = System.delete_step(step)
      assert_raise Ecto.NoResultsError, fn -> System.get_step!(step.id) end
    end

    test "change_step/1 returns a step changeset" do
      step = step_fixture()
      assert %Ecto.Changeset{} = System.change_step(step)
    end
  end
end
