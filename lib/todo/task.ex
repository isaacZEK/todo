defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do

    field :title, :string
    field :description, :string
    field :done, :boolean, default: false

    timestamps()

  end


  def changeset(task,attrs) do
    task
    |> cast(attrs,[:title, :description, :done])
    |> validate_required([:title, :description])
  end

end
