# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todo.Accounts
admin_attrs = %{
  email: "admin@gmail.com",
  password: "password",
  is_admin: true
}

case Accounts.register_user(admin_attrs) do
  {:ok, _user} ->
    IO.puts("Admin user created successfully!")
  {:error, changeset} ->
    IO.inspect(changeset.errors)
end
