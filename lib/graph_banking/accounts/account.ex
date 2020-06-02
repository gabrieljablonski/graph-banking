defmodule GraphBanking.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphBanking.Accounts.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :current_balance, :decimal

    has_many :sent_transactions, Transaction, foreign_key: :sender_id
    has_many :received_transactions, Transaction, foreign_key: :recipient_id

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
