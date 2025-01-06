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



#retrieves user by email
def get_user_by_email(email) do
  Repo.get_by(User, email: email)
end

#authenticate user
def authenticate_user(email, password) do
  case get_user_by_email(email) do
    nil -> {:error, "Invalid email or password"}
    user ->
      if Pbkdf2.verify_pass(password, user.password_hash) do
        {:ok, user}
      else
        {:error, "Invalid email or password"}
      end
    end
  end

end
