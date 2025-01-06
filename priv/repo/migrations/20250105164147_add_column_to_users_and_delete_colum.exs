defmodule Todo.Repo.Migrations.AddColumnToUsersAndDeleteColum do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      remove :age
    end
  end
end
