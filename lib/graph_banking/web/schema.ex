defmodule GraphBanking.Web.Schema do
  use Absinthe.Schema

  alias GraphBanking.{Web, Accounts}

  object :account do
    field :id, non_null(:id)
    field :current_balance, non_null(:string)
  end

  query do
    field :all_accounts, :account |> non_null() |> list_of() |>  non_null() do
      resolve &Web.Resolvers.Accounts.all_accounts/3
    end
  end
end
