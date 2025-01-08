defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do

    field :title, :string
    field :description, :string
    field :done, :boolean, default: false
    field :deleted_at, :utc_datetime
    field :user_id, :integer

    timestamps()

  end


  def changeset(task,attrs) do
    task
    |> cast(attrs,[:title, :description, :done, :deleted_at, :user_id])
    |> validate_required([:title, :description, :user_id])
  end

end
