defmodule GraphBanking.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :decimal
    field :when, :utc_datetime
    field :sender, :binary_id
    field :recipient, :binary_id

    timestamps()
  end

  @optional_fields ~w[]a
  @required_fields ~w[amount when sender recipient]a

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
