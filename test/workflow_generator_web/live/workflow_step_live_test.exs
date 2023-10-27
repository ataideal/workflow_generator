defmodule WorkflowGeneratorWeb.WorkflowStepLiveTest do
  use WorkflowGeneratorWeb.ConnCase

  import Phoenix.LiveViewTest
  import WorkflowGenerator.SystemFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_workflow_step(_) do
    workflow_step = workflow_step_fixture()
    %{workflow_step: workflow_step}
  end

  describe "Index" do
    setup [:create_workflow_step]

    test "lists all workflow_steps", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/workflow_steps")

      assert html =~ "Listing Workflow steps"
    end

    test "saves new workflow_step", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/workflow_steps")

      assert index_live |> element("a", "New Workflow step") |> render_click() =~
               "New Workflow step"

      assert_patch(index_live, ~p"/workflow_steps/new")

      assert index_live
             |> form("#workflow_step-form", workflow_step: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#workflow_step-form", workflow_step: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workflow_steps")

      html = render(index_live)
      assert html =~ "Workflow step created successfully"
    end

    test "updates workflow_step in listing", %{conn: conn, workflow_step: workflow_step} do
      {:ok, index_live, _html} = live(conn, ~p"/workflow_steps")

      assert index_live |> element("#workflow_steps-#{workflow_step.id} a", "Edit") |> render_click() =~
               "Edit Workflow step"

      assert_patch(index_live, ~p"/workflow_steps/#{workflow_step}/edit")

      assert index_live
             |> form("#workflow_step-form", workflow_step: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#workflow_step-form", workflow_step: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workflow_steps")

      html = render(index_live)
      assert html =~ "Workflow step updated successfully"
    end

    test "deletes workflow_step in listing", %{conn: conn, workflow_step: workflow_step} do
      {:ok, index_live, _html} = live(conn, ~p"/workflow_steps")

      assert index_live |> element("#workflow_steps-#{workflow_step.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#workflow_steps-#{workflow_step.id}")
    end
  end

  describe "Show" do
    setup [:create_workflow_step]

    test "displays workflow_step", %{conn: conn, workflow_step: workflow_step} do
      {:ok, _show_live, html} = live(conn, ~p"/workflow_steps/#{workflow_step}")

      assert html =~ "Show Workflow step"
    end

    test "updates workflow_step within modal", %{conn: conn, workflow_step: workflow_step} do
      {:ok, show_live, _html} = live(conn, ~p"/workflow_steps/#{workflow_step}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Workflow step"

      assert_patch(show_live, ~p"/workflow_steps/#{workflow_step}/show/edit")

      assert show_live
             |> form("#workflow_step-form", workflow_step: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#workflow_step-form", workflow_step: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/workflow_steps/#{workflow_step}")

      html = render(show_live)
      assert html =~ "Workflow step updated successfully"
    end
  end
end
