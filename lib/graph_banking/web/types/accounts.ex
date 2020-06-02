defmodule GraphBanking.Web.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  alias GraphBanking.Accounts.{Account, Transaction}

  object :transaction do
    field :id, non_null(:id)
    field :sender_id, non_null(:id)
    field :recipient_id, non_null(:id)
    field :amount, non_null(:string)
    field :when, non_null(:string)

    field :sender, non_null(:account) do
      resolve fn (%Transaction{sender: sender}, _, _) -> {:ok, sender} end
    end
    field :recipient, non_null(:account) do
      resolve fn (%Transaction{recipient: recipient}, _, _) -> {:ok, recipient} end
    end
  end

  object :account do
    field :id, non_null(:id)
    field :current_balance, non_null(:string)
    field :transactions, :transaction |> non_null() |> list_of() |> non_null() do
      resolve fn (%Account{transactions: transactions}, _, _) -> {:ok, transactions} end
    end
  end
end
