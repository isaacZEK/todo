defmodule Todo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :title, :string
      add :description, :string
      add :done, :boolean, default: false

      timestamps()
    end
  end
end
