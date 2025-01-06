defmodule TodoWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller
  # alias TodoWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        # Redirect to the login page if user is not logged in
        conn
        |> put_flash(:error, "You must log in first.")
        |> redirect(to: "/tasks")
        |> halt()

      _user_id ->
        conn
    end
  end
end
