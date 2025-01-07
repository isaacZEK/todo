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


  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(task,attrs) do
    task
    |> cast(attrs,[:title, :description, :done, :deleted_at, :user_id])
    |> validate_required([:title, :description, :user_id])
  end

end
