defmodule WorkflowGeneratorWeb.Router do
  use WorkflowGeneratorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WorkflowGeneratorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WorkflowGeneratorWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/workflows", WorkflowLive.Index, :index
    live "/workflows/new", WorkflowLive.Index, :new
    live "/workflows/:id/edit", WorkflowLive.Index, :edit

    live "/workflows/:id", WorkflowLive.Show, :show
    live "/workflows/:id/show/edit", WorkflowLive.Show, :edit

    live "/workflow_steps", WorkflowStepLive.Index, :index
    live "/workflow_steps/new", WorkflowStepLive.Index, :new
    live "/workflow_steps/:id/edit", WorkflowStepLive.Index, :edit

    live "/workflow_steps/:id", WorkflowStepLive.Show, :show
    live "/workflow_steps/:id/show/edit", WorkflowStepLive.Show, :edit

    live "/steps", StepLive.Index, :index
    live "/steps/new", StepLive.Index, :new
    live "/steps/:id/edit", StepLive.Index, :edit

    live "/steps/:id", StepLive.Show, :show
    live "/steps/:id/show/edit", StepLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WorkflowGeneratorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:workflow_generator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WorkflowGeneratorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
