defmodule TodoWeb.TaskController do
  use TodoWeb, :controller

  alias Todo.Repo
  alias Todo.Task
  alias Todo.Tasks

   # Action to display the index page
   def tasks(conn, _params) do
    tasks = Repo.all(Task)  # Fetch all tasks from the database
    render(conn, "show.html", tasks: tasks)
  end

  #show new form validation
  def new(conn, _params) do
    # so skip the default app layout.
    changeset = Task.changeset(%Task{}, %{})
    render(conn, :new, changeset: changeset)
  end


  #create a task in the database
  def create(conn,%{"task" => task_params}) do

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

  #deleting a task
  def delete(conn, %{"id" => id}) do
    task=Repo.get!(Task, id)

    #delete task
    Repo.delete!(task)

    #success flash redirect
    flash = put_flash(conn,:info, "Task deleted sucessfully,")
    redirect(flash, to: "/todo")
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
