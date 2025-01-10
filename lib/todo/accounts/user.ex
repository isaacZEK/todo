defmodule Todo.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset
  alias Pbkdf2

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :is_admin, :boolean, default: false
    field :deleted_at, :utc_datetime

    #virtual field
    field :password, :string, virtual: true

    timestamps()
  end

  #changeset for user registration
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name,:email, :password, :is_admin, :deleted_at])
    |> validate_required([:email,:password])
    |> validate_format(:email, ~r/@/, message: "must contain @")
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
    else
      changeset
    end
  end

end
