defmodule TodoWeb.AdminController do
  use TodoWeb, :controller

  alias Todo.Accounts
  alias Todo.Tasks
  # alias Todo.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_non_admin_users
    render(conn, :index, users: users)
  end

def delete(conn, %{"id" => id}) do
  user = Accounts.get_user_by_id!(id)
  {:ok, _user} = Accounts.soft_delete_user(user)

  conn
  |> put_flash(:info, "User deleted successfully!")
  |> redirect(to: "/admin")
end

def view_user_tasks(conn, %{"id" => id}) do
  user = Accounts.get_user_by_id!(id)
  tasks = Tasks.list_tasks(user.id)
  render(conn, "view_user_tasks.html", user: user, tasks: tasks)
end

end
