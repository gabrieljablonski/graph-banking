defmodule GraphBanking.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphBanking.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    belongs_to :sender, Account
    belongs_to :recipient, Account
    field :amount, :decimal
    field :when, :utc_datetime

    timestamps()
  end

  @optional_fields ~w[]a
  @required_fields ~w[sender_id recipient_id amount when]a

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
