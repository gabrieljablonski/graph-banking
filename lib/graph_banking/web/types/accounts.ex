defmodule GraphBanking.Web.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  alias GraphBanking.Web.Resolvers.Accounts

  object :transaction do
    field :id, non_null(:id)
    field :sender_id, non_null(:id)
    field :recipient_id, non_null(:id)
    field :amount, non_null(:string)
    field :when, non_null(:string)

    field :sender, non_null(:account) do
      resolve &Accounts.sender_account/3
    end
    field :recipient, non_null(:account) do
      resolve &Accounts.recipient_account/3
    end
  end

  object :account do
    field :id, non_null(:id)
    field :current_balance, non_null(:string)
    field :transactions, :transaction |> non_null() |> list_of() |> non_null() do
      resolve &Accounts.account_transactions/3
    end
  end
end
