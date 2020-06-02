defmodule GraphBanking.Web.Schema.Types.Accounts do
  @moduledoc """
  Absinthe schema type definitions.
  """

  use Absinthe.Schema.Notation

  alias GraphBanking.Repo
  alias GraphBanking.Web.Resolvers
  alias GraphBanking.Accounts.{Account, Transaction}

  object :transaction do
    field :id, non_null(:id)
    field :sender_id, non_null(:id)
    field :recipient_id, non_null(:id)
    field :when, non_null(:string)

    field :amount, non_null(:float) do
      resolve(fn %Transaction{amount: amount}, _, _ ->
        {:ok, Decimal.to_float(amount)}
      end)
    end

    field :sender, non_null(:account) do
      resolve(fn %Transaction{sender_id: id} = transaction, _args, info ->
        Resolvers.Accounts.account_by_id(transaction, %{id: id}, info)
      end)
    end

    field :recipient, non_null(:account) do
      resolve(fn %Transaction{recipient_id: id} = transaction, _args, info ->
        Resolvers.Accounts.account_by_id(transaction, %{id: id}, info)
      end)
    end
  end

  object :account do
    field :id, non_null(:id)

    field :current_balance, non_null(:float) do
      resolve(fn %Account{current_balance: current_balance}, _, _ ->
        {:ok, Decimal.to_float(current_balance)}
      end)
    end

    field :sent_transactions, :transaction |> non_null() |> list_of() |> non_null() do
      resolve(fn %Account{} = account, _, _ ->
        transactions =
          account
          |> Ecto.assoc(:sent_transactions)
          |> Repo.all()

        {:ok, transactions}
      end)
    end

    field :received_transactions, :transaction |> non_null() |> list_of() |> non_null() do
      resolve(fn %Account{} = account, _, _ ->
        transactions =
          account
          |> Ecto.assoc(:received_transactions)
          |> Repo.all()

        {:ok, transactions}
      end)
    end
  end
end
