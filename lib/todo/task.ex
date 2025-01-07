defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do

    field :title, :string
    field :description, :string
    field :done, :boolean, default: false
    field :deleted_at, :utc_datetime

    timestamps()

  end


  def changeset(task,attrs) do
    task
    |> cast(attrs,[:title, :description, :done, :deleted_at])
    |> validate_required([:title, :description])
  end

end
