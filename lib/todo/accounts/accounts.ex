defmodule Todo.Accounts do
  import Ecto.Query, warn: false
alias Todo.Repo
alias Todo.Accounts.User
alias Pbkdf2


  # Creates a user by validating input and hashing the password
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)  # Use a new changeset for registration
    |> Repo.insert()
  end

  # Returns a changeset for rendering forms without applying changes
  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)  # Use the same changeset
  end

  def get_user_by_id!(id) do
    Repo.get(User, id)
  end


#retrieves user by email
def get_user_by_email(email) do
  Repo.get_by(User, email: email)
end

def list_non_admin_users do
  from(u in User, where: u.is_admin == false and is_nil(u.deleted_at))
  |> Repo.all()
end


#list users
# def list_users do
#   Repo.all(User)
# end

#update user
def update_user(%User{} = user, attrs) do
  user
  |> User.registration_changeset(attrs)
  |> Repo.update()
end

# def delete_user(%User{} = user) do
#   Repo.delete(user)
# end


# Soft delete a user by updating the `deleted_at` field
def soft_delete_user(user) do
  user
  |> Ecto.Changeset.change(deleted_at: DateTime.utc_now() |> DateTime.truncate(:second))
  |> Repo.update()
end


#authenticate user
def authenticate_user(email, password) do
  user = get_user_by_email(email)

    if user && is_nil(user.deleted_at) do
      #nested if statement
      if Pbkdf2.verify_pass(password, user.password_hash) do
        {:ok, user}
      else
        {:error, "Invalid email or password"}
      end
      #nested if statement
    else
      {:error, "Invalid email or password"}
    end
  end




end
