defmodule Todo.Repo.Migrations.AddAForeignKeyConstraint do
  use Ecto.Migration

  def change do
    alter table(:task) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:task, [:user_id])
  end
end
