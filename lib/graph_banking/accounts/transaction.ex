defmodule GraphBanking.Accounts.Transaction do
  @moduledoc """
  The `Transaction` Ecto model.
  Represents a transaction between two accounts.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GraphBanking.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :decimal
    field :when, :utc_datetime

    belongs_to :sender, Account
    belongs_to :recipient, Account

    timestamps()
  end

  @optional_fields ~w[]a
  @required_fields ~w[sender_id recipient_id amount when]a

  @doc false
  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
