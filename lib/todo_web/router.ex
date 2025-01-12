defmodule TodoWeb.Router do
  # alias ElixirLS.LanguageServer.Providers.Completion.Reducers.DocsSnippets
  use TodoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoWeb.Layouts, :root}
    plug :put_secure_browser_headers
    # plug :protect_from_forgery

    # plug TodoWeb.AuthPlug
  end



  pipeline :authenticate do
    plug TodoWeb.AuthPlug
    plug :fetch_session
  end



  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", TodoWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  scope "/tasks", TodoWeb do
    pipe_through :browser

    #this is the  login page
    get "/", RegistrationController, :index

    #registration routes
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    #login routes/session routes
    get "/login", RegistrationController, :index
    post "/login", RegistrationController, :authenticate
    get "/logout", RegistrationController, :logout

  end

  scope "/todo", TodoWeb do
    pipe_through :browser # Authenticate using plug
    #fetch tasks homepage template
    get "/", TaskController, :tasks

    #fetch new task page
    get "/new", TaskController, :new

    #create new task template
    post "/create", TaskController, :create

    #fetch the edit task template
    get "/:id/edit", TaskController, :edit

    #update a task
    patch "/:id/update", TaskController, :update

    #delete a task
    get "/:id/delete", TaskController, :soft_delete

  end

  scope "/admin", TodoWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", AdminController, :index
    get "/:id/delete", AdminController, :delete
    get "/:id/tasks", AdminController, :view_user_tasks
    # get "/users/:id/tasks", TaskController, :tasks

  end


  # Other scopes may use custom stacks.
  # scope "/api", TodoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
