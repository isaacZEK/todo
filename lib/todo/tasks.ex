defmodule Todo.Tasks do
 import Ecto.Query, warn: false
 alias Todo.Repo
 alias Todo.Task

 #fetch all records
 def list_tasks(user_id) do
  Task
  |> where([task], is_nil(task.deleted_at) and task.user_id == ^user_id)
  |> Repo.all()
 end

#get a single task based on user
def get_task!(id) do
  Task
  |> where([t], is_nil(t.deleted_at) and t.id == ^id)
  |> Repo.one!()
end

#create tasks
def create_tasks(attrs \\%{}) do
 new_task = %Task{}
 changeset = Task.changeset(new_task, attrs)
 Repo.insert(changeset)
end

#update a task
def update_task(%Task{} = task, attrs) do
 changeset = Task.changeset(task,attrs)
 Repo.update(changeset)
end

def soft_delete_task(%Task{} = task) do
  task
  |> Task.changeset(%{"deleted_at" => DateTime.utc_now()})
  |> Repo.update()
end

end
