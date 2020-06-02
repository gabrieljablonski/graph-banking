defmodule GraphBanking.Web.Schema do
  use Absinthe.Schema

  alias GraphBanking.Web.{Resolvers, Schema}

  import_types(Schema.Types.Accounts)

  query do
    @desc "Get a list of all accounts"
    field :all_accounts, :account |> non_null() |> list_of() |> non_null() do
      resolve(&Resolvers.Accounts.all_accounts/3)
    end

    @desc "Get a list of all transactions"
    field :all_transactions, :transaction |> non_null() |> list_of() |> non_null() do
      resolve(&Resolvers.Accounts.all_transactions/3)
    end

    @desc "Get information about an account"
    field :account, non_null(:account) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Accounts.account/3)
    end
  end

  mutation do
    @desc "Open a new account with a starting balance"
    field :open_account, non_null(:account) do
      arg(:balance, non_null(:float))

      resolve(&Resolvers.Accounts.open_account/3)
    end

    @desc "Transfer money between two accounts"
    field :transfer_money, non_null(:transaction) do
      arg(:sender, non_null(:id))
      arg(:recipient, non_null(:id))
      arg(:amount, non_null(:float))

      resolve(&Resolvers.Accounts.transfer_money/3)
    end
  end
end
