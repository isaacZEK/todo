defmodule Todo.Repo.Migrations.AddColumnToUsers do
  use Ecto.Migration

  def change do
alter table(:users) do
  add :name, :string
end
  end
end
