defmodule TodoWeb.TaskController do
  use TodoWeb, :controller

  alias Todo.Repo
  alias Todo.Task
  alias Todo.Tasks
  alias Todo.Accounts

  #  # Action to display the index page
  #  def tasks(conn, _params) do
  #   tasks = Repo.all(Task)  # Fetch all tasks from the database
  #   render(conn, "show.html", tasks: tasks)
  # end

   # Action to display the index page
def tasks(conn, _params) do
  user = get_current_user(conn)
  tasks = Tasks.list_tasks(user.id)
  render(conn, "show.html", tasks: tasks)
end




  #show new form validation
  def new(conn, _params) do
    changeset = Task.changeset(%Task{}, %{})
    render(conn, :new, changeset: changeset)
  end


  #create a task in the database
  def create(conn,%{"task" => task_params}) do
    user = get_current_user(conn)
    task_params = Map.put(task_params, "user_id", user.id)

    #create a changeset with input parameters
   changeset = Task.changeset(%Task{}, task_params)

   #attempt to insert the new task into the database
   case Repo.insert(changeset) do
     {:ok, _task_params} ->
      flash = put_flash(conn, :info, "Task created sucessfully!")
      redirect(flash, to: "/todo")

      {:error, changeset} ->
        put_flash(conn, :info, "Task creation failed!")
        render(conn, "new.html", changeset: changeset)
     end
  end

 def soft_delete(conn, %{"id" => id}) do
   task = Repo.get!(Task, id)

   delete_result = Tasks.soft_delete_task(task)

   case delete_result do
    {:ok, _task} ->
      conn
      |> put_flash(:info, "Task deleted successfully")
      |> redirect(to: "/todo")

      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Failed to delete task!")
        |> redirect(to: "/todo")
   end
 end

 #Helper function to get the current user from the session or authentication context
defp get_current_user(conn) do
  user_id = get_session(conn, :user_id)
  Accounts.get_user_by_id(user_id)
end

  #editing a task
  def edit(conn,%{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "edit.html", task: task)
  end

  #updating a task
  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    IO.inspect(task, label: "Task 1")
    IO.inspect(task_params, label: "Task 2")

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: "/todo")

      {:error, changeset} ->
        IO.inspect(changeset)
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end
end
