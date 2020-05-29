defmodule GraphBanking.Web.Resolvers.Accounts do
  alias GraphBanking.Accounts

  def all_accounts(_root, _args, _info) do
    {:ok, Accounts.list_accounts()}
  end
end
