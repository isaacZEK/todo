defmodule Todo.Repo.Migrations.DropTableInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :deleted_at
    end
  end
end
