defmodule TodoWeb.AuthPlug do
  # Provides functions to work with HTTP connections
  import Plug.Conn

  # Provides redirecting and flash message settings functions
  import Phoenix.Controller
  alias Todo.Accounts

  # Initializes options (required for a plug)
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    # Get user_id from session
    user_id = get_session(conn, :user_id)

    # Fetch user if logged in
    user = if user_id, do: Accounts.get_user_by_id!(user_id)

    # Check if user exists
    if user do
      # Assign user to conn for later use
      conn
      |> assign(:current_user, user)
    else
      # Redirect if not logged in
      conn
      |> put_flash(:error, "You must log in first.")
      |> redirect(to: "/tasks")
      |> halt()
    end
  end

  @spec authenticate_admin(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def authenticate_admin(conn, _opts) do
    # Get current_user from connection assigns
    user = conn.assigns[:current_user]

    # Check if the user is an admin
    if user && user.is_admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access this page.")
      |> redirect(to: "/tasks")
      |> halt()
    end
  end
end
