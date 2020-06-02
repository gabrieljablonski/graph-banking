defmodule GraphBanking.Web.Resolvers.Accounts do
  @moduledoc """
  The Absinthe resolvers associated directly to bank accounts.
  """

  alias GraphBanking.Accounts
  alias GraphBanking.Accounts.{Account, Transaction}

  @type account :: Account.t()
  @type transaction :: Transaction.t()

  @doc """
  Retrieve all accounts registered.

  Returns `{:ok, [%GraphBanking.Accounts.Account{}, ...]}`.

  ## Examples

      iex > GraphBanking.Web.Resolvers.Accounts.all_accounts()
      [
        %GraphBanking.Accounts.Account{
          id: "6f5e4190-50a0-43c0-ac32-7b0d6f6ed4e3",
          current_balance: #Decimal<100.00>
        },
        ...
      ]
  """
  @spec all_accounts(any, any, any) :: {:ok, list(account())}
  def all_accounts(_root, _args, _info) do
    {:ok, Accounts.list_accounts()}
  end

  @doc """
  Retrieve all transactions performed.

  Returns `{:ok, [%GraphBanking.Accounts.Transaction{}, ...]}`.

  ## Examples

      iex > GraphBanking.Web.Resolvers.Accounts.all_transactions()
      [
        %GraphBanking.Accounts.Transaction{
          id: "cb0306b5-7e8e-49c4-8090-819117a401b7",
          sender_id: "253c7262-90ac-4a03-abd6-46590f15e503",
          recipient_id: "2c1bbf32-3634-4d26-822b-98cdbb49c36a",
          amount: #Decimal<10.00>,
          when: ~U[2018-11-15 11:00:00Z]
        },
        ...
      ]
  """
  @spec all_transactions(any, any, any) :: {:ok, list(transaction())}
  def all_transactions(_root, _args, _info) do
    {:ok, Accounts.list_transactions()}
  end

  @doc """
  Retrieve account with identifier `id`.

  When account exists, returns `{:ok, %GraphBanking.Accounts.Account{}}`.

  ## Examples

      iex > GraphBanking.Web.Resolvers.Accounts.account_by_id(
      ... >   _, %{id: "cb0306b5-7e8e-49c4-8090-819117a401b7"}, _
      ... > )
      %GraphBanking.Accounts.Account{
        id: "6f5e4190-50a0-43c0-ac32-7b0d6f6ed4e3",
        current_balance: #Decimal<100.00>
      }
  """
  @spec account_by_id(any, %{id: any}, any) ::
          {:error, any} | {:ok, account()}
  def account_by_id(_root, %{id: id}, _info) do
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

  @doc """
  Open a new account with a starting balance of `balance` and returns it.
  `balance` must be non-negative.

  When balance is non_negative, returns `{:ok, %GraphBanking.Accounts.Account{}}`.

  ## Examples

    iex > GraphBanking.Web.Resolvers.Accounts.open_account(
    ... >   _, %{balance: 100.10}, _
    ... > )
    %GraphBanking.Accounts.Account{
      id: "6f5e4190-50a0-43c0-ac32-7b0d6f6ed4e3",
      current_balance: #Decimal<100.10>
    }
  """
  @spec open_account(any, %{balance: number()}, any) :: {:error, any} | {:ok, account()}
  def open_account(_root, %{balance: balance}, _info) do
    do_open_account(balance)
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

  @doc """
  Transfer money from `sender`'s account to `recipient`'s account,
  returning the transaction generated.

  Returns `GraphBanking.Accounts.Transaction`.

  ## Examples

      iex > GraphBanking.Web.Resolvers.Accounts.transfer_money(
      ... >   _, %{sender: "<sender uuid>", recipient: "<recipient uuid>", amount: 100.0}, _
      ... > )
      %Transaction{
        id: "<transaction uuid>",
        sender_id: "<sender uuid>",
        recipient_id: "<recipient uuid>",
        amount: 100.0,
        when: "<utc timestamp>"
      }
  """
  @spec transfer_money(any, %{amount: any, sender: :id, recipient: :id}, number()) ::
          {:error, transaction()}
  def transfer_money(_root, %{sender: sender, recipient: recipient, amount: amount}, _info) do
    do_transfer_money(sender, recipient, amount)
  end

  defp do_transfer_money(sender, sender, _) do
    {:error, "sender and recipient must be different"}
  end

  defp do_transfer_money(_, _, amount) when is_float(amount) and amount <= 0 do
    {:error, "amount tranfered must be positive"}
  end

  defp do_transfer_money(sender, recipient, amount)
       when is_binary(sender) and is_binary(recipient) and is_float(amount) do
    with %Account{} = sender_account <- try_get_account(sender),
         %Account{} = recipient_account <- try_get_account(recipient) do
      do_transfer_money(sender_account, recipient_account, Decimal.from_float(amount))
    else
      {:not_found, message} -> {:error, message}
    end
  end

  defp do_transfer_money(%Account{current_balance: balance}, _, amount)
       when balance < amount do
    {:error, "sender's balance ($#{balance}) is insufficient"}
  end

  defp do_transfer_money(
         %Account{id: sender_id, current_balance: sender_balance} = sender_account,
         %Account{id: recipient_id, current_balance: recipient_balance} = recipient_account,
         amount
       ) do
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

    Accounts.create_transaction(%{
      sender_id: sender_id,
      recipient_id: recipient_id,
      amount: amount,
      when: DateTime.utc_now()
    })
  end
end
