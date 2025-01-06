defmodule TodoWeb.AuthPlug do

  #provides functions to work with HTTP connections
  import Plug.Conn

  #provides redirecting and flash message settings functions
  import Phoenix.Controller


  def init(default), do: default

  def call(conn, _opts) do
    if get_session(conn, :user_id) do
      # User is logged in, so continue processing the request
      conn
    else
      # Redirect to the login page if user is not logged in
      conn
      |> put_flash(:error, "You must log in first.")
      |> redirect(to: "/tasks")
      |> halt()
    end
  end

end
