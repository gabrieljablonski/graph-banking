defmodule GraphBanking.Web.Resolvers.Accounts do
  alias GraphBanking.Accounts
  alias GraphBanking.Accounts.Account

  @spec all_accounts(any, any, any) :: {:ok, any}
  def all_accounts(_root, _args, _info) do
    {:ok, Accounts.list_accounts()}
  end

  @spec all_transactions(any, any, any) :: {:ok, any}
  def all_transactions(_root, _args, _info) do
    {:ok, Accounts.list_transactions()}
  end

  @spec account(any, %{id: any}, any) :: any
  def account(_root, %{id: id}, _info) do
    case account = try_get_account(id) do
      %Account{} -> {:ok, account}
      {:not_found, message} -> {:error, message}
    end
  end

  defp try_get_account(id) do
    case Accounts.get_account(id) do
      nil -> {:not_found, "account #{id} not found"}
      account -> account
    end
  end

  defp do_open_account(balance) when balance < 0 do
    {:error, "balance must be non-negative"}
  end

  defp do_open_account(balance) do
    case Accounts.create_account(%{current_balance: Decimal.from_float(balance)}) do
      {:ok, account} -> {:ok, account}
      {:error, message} -> {:error, message}
    end
  end

  @spec open_account(any, %{balance: any}, any) :: {:error, any} | {:ok, any}
  def open_account(_root, %{balance: balance}, _info) do
    do_open_account(balance)
  end

  defp perform_transaction(%Account{current_balance: balance}, _, amount)
       when balance < amount do
    {:error, "sender's balance ($#{balance}) is insufficient"}
  end

  defp perform_transaction(sender_account, recipient_account, amount) do
    %Account{id: sender_id, current_balance: sender_balance} = sender_account
    %Account{id: recipient_id, current_balance: recipient_balance} = recipient_account

    {:ok, _} =
      Accounts.update_account(
        sender_account,
        %{current_balance: Decimal.sub(sender_balance, amount)}
      )

    {:ok, _} =
      Accounts.update_account(
        recipient_account,
        %{current_balance: Decimal.add(recipient_balance, amount)}
      )

    case Accounts.create_transaction(%{
           sender_id: sender_id,
           recipient_id: recipient_id,
           amount: amount,
           when: DateTime.utc_now()
         }) do
      {:ok, transaction} -> {:ok, transaction}
      {:error, message} -> {:error, message}
    end
  end

  defp do_transfer_money(sender, sender, _) do
    {:error, "sender and recipient must be different"}
  end

  defp do_transfer_money(_, _, amount) when amount <= 0 do
    {:error, "amount tranfered must be positive"}
  end

  defp do_transfer_money(sender, recipient, amount) do
    with %Account{} = sender_account <- try_get_account(sender),
         %Account{} = recipient_account <- try_get_account(recipient) do
      perform_transaction(sender_account, recipient_account, Decimal.from_float(amount))
    else
      {:not_found, message} -> {:error, message}
    end
  end

  @spec transfer_money(any, %{amount: any, recipient: any, sender: any}, any) :: {:error, any}
  def transfer_money(_root, %{sender: sender, recipient: recipient, amount: amount}, _info) do
    do_transfer_money(sender, recipient, amount)
  end
end
