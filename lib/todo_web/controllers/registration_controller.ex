defmodule TodoWeb.RegistrationController do
  use TodoWeb, :controller
  alias Todo.Accounts
  alias Todo.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

 def new(conn, _params) do
  changeset = Accounts.change_user(%User{})
  render(conn, :new, changeset: changeset)
end

def create(conn,user_params) do
  case Accounts.create_user(user_params) do
    {:ok, _user} ->
      conn
      |> put_flash(:info, "Account created successfully!")
      |> redirect(to: "/tasks")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
  end
 end





  # ------------------------
  # SESSION HANDLING STARTS
  # ------------------------

 # Handle user authentication
 def authenticate(conn, %{"email" => email, "password" => password}) do
  case Accounts.authenticate_user(email, password) do
    {:ok, user} ->
      conn
      |> put_session(:user_id, user.id) # Store user ID in session
      |> configure_session(renew: true) # Protect against session fixation
      |> put_flash(:info, "Logged in successfully!")
      |> redirect(to: "/todo") # Redirect to the tasks page

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
    |> redirect(to: "/tasks") # Redirect to login
  end

end
