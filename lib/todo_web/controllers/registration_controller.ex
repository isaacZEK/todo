defmodule TodoWeb.RegistrationController do
  use TodoWeb, :controller
  alias Todo.Accounts
  alias Todo.Accounts.User

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, :index)
  end

 def new(conn, _params) do
  changeset = Accounts.change_user(%User{})
  render(conn, :new, changeset: changeset)
end

def create(conn,user_params) do
  result = Accounts.create_user(user_params)
    case result do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account created successfully!")
        |> redirect(to: if user.is_admin do
          "/admin"
        else
          "/todo"
        end)

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

end


  # ------------------------
  # SESSION HANDLING STARTS
  # ------------------------

 # Handle user authentication
 def authenticate(conn, %{"email" => email, "password" => password}) do

  query = Accounts.authenticate_user(email, password)

  case query do
    {:ok, user} ->
      conn
      |> put_session(:user_id, user.id) # Store user ID in session
      |> configure_session(renew: true) # Protect against session fixation
      |> put_flash(:info, "Logged in successfully!")
      |> redirect(to: if user.is_admin do
        "/admin"
      else
        "/todo"
      end)# Redirect to the tasks page

    {:error, _reason} ->
      conn
      |> put_flash(:error, "Invalid email or password.")
      |> render("index.html") # Re-render the login page
  end
end

  # Logs the user out
  def logout(conn, _params) do
    conn
    |> configure_session(drop: true) # Clear session
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: "/tasks")
  end

end
