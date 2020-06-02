defmodule GraphBanking.Web.Schema do
  use Absinthe.Schema

  alias GraphBanking.{Web, Accounts}

  import_types GraphBanking.Web.Schema.Types.Accounts

  query do
    field :all_accounts, :account |> non_null() |> list_of() |>  non_null() do
      resolve &Web.Resolvers.Accounts.all_accounts/3
    end
  end
end
