defmodule Todo.Tasks do
 import Ecto.Query, warn: false
 alias Todo.Repo
 alias Todo.Task

 #fetch all records
 def list_tasks do
   Repo.all(Task)
 end

#get a single task ID
def get_task!(id) do
  task_schema = Task
  Repo.get!(task_schema, id)
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

#delete a task
def delete_task(%Task{}=task) do
  Repo.delete(task)
end

end
