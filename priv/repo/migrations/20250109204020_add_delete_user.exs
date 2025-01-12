defmodule Todo.Repo.Migrations.AddDeleteUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :utc_datetime, default: nil
    end
  end
end
