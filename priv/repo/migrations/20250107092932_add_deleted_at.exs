defmodule Todo.Repo.Migrations.AddDeletedAt do
  use Ecto.Migration

  def change do
    alter table(:task) do
      add :deleted_at, :utc_datetime
    end
  end
end
