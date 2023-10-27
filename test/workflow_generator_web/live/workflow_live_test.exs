defmodule WorkflowGeneratorWeb.WorkflowLiveTest do
  use WorkflowGeneratorWeb.ConnCase

  import Phoenix.LiveViewTest
  import WorkflowGenerator.SystemFixtures

  @create_attrs %{description: "some description", enabled: true, input: %{}, name: "some name"}
  @update_attrs %{description: "some updated description", enabled: false, input: %{}, name: "some updated name"}
  @invalid_attrs %{description: nil, enabled: false, input: nil, name: nil}

  defp create_workflow(_) do
    workflow = workflow_fixture()
    %{workflow: workflow}
  end

  describe "Index" do
    setup [:create_workflow]

    test "lists all workflows", %{conn: conn, workflow: workflow} do
      {:ok, _index_live, html} = live(conn, ~p"/workflows")

      assert html =~ "Listing Workflows"
      assert html =~ workflow.description
    end

    test "saves new workflow", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/workflows")

      assert index_live |> element("a", "New Workflow") |> render_click() =~
               "New Workflow"

      assert_patch(index_live, ~p"/workflows/new")

      assert index_live
             |> form("#workflow-form", workflow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#workflow-form", workflow: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workflows")

      html = render(index_live)
      assert html =~ "Workflow created successfully"
      assert html =~ "some description"
    end

    test "updates workflow in listing", %{conn: conn, workflow: workflow} do
      {:ok, index_live, _html} = live(conn, ~p"/workflows")

      assert index_live |> element("#workflows-#{workflow.id} a", "Edit") |> render_click() =~
               "Edit Workflow"

      assert_patch(index_live, ~p"/workflows/#{workflow}/edit")

      assert index_live
             |> form("#workflow-form", workflow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#workflow-form", workflow: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workflows")

      html = render(index_live)
      assert html =~ "Workflow updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes workflow in listing", %{conn: conn, workflow: workflow} do
      {:ok, index_live, _html} = live(conn, ~p"/workflows")

      assert index_live |> element("#workflows-#{workflow.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#workflows-#{workflow.id}")
    end
  end

  describe "Show" do
    setup [:create_workflow]

    test "displays workflow", %{conn: conn, workflow: workflow} do
      {:ok, _show_live, html} = live(conn, ~p"/workflows/#{workflow}")

      assert html =~ "Show Workflow"
      assert html =~ workflow.description
    end

    test "updates workflow within modal", %{conn: conn, workflow: workflow} do
      {:ok, show_live, _html} = live(conn, ~p"/workflows/#{workflow}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Workflow"

      assert_patch(show_live, ~p"/workflows/#{workflow}/show/edit")

      assert show_live
             |> form("#workflow-form", workflow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#workflow-form", workflow: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/workflows/#{workflow}")

      html = render(show_live)
      assert html =~ "Workflow updated successfully"
      assert html =~ "some updated description"
    end
  end
end
