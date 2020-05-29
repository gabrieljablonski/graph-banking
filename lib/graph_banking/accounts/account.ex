defmodule GraphBanking.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :current_balance, :decimal

    timestamps()
  end

  @optional_fields ~w[]a
  @required_fields ~w[current_balance]a

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
