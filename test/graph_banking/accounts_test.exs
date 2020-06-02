defmodule GraphBanking.AccountsTest do
  use GraphBanking.DataCase

  alias GraphBanking.Accounts

  describe "transactions" do
    alias GraphBanking.Accounts.Transaction

    @valid_attrs %{
      address: "some address",
      amount: "120.5",
      uuid: "7488a646-e31f-11e4-aace-600308960662",
      when: "2010-04-17T14:00:00Z"
    }
    @update_attrs %{
      address: "some updated address",
      amount: "456.7",
      uuid: "7488a646-e31f-11e4-aace-600308960668",
      when: "2011-05-18T15:01:01Z"
    }
    @invalid_attrs %{address: nil, amount: nil, uuid: nil, when: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.address == "some address"
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Accounts.update_transaction(transaction, @update_attrs)

      assert transaction.address == "some updated address"
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "accounts" do
    alias GraphBanking.Accounts.Account

    @valid_attrs %{currentBalance: "120.5", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{currentBalance: "456.7", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{currentBalance: nil, uuid: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.currentBalance == Decimal.new("120.5")
      assert account.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.currentBalance == Decimal.new("456.7")
      assert account.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "transactions" do
    alias GraphBanking.Accounts.Transaction

    @valid_attrs %{
      amount: "120.5",
      recipient: "7488a646-e31f-11e4-aace-600308960662",
      sender: "7488a646-e31f-11e4-aace-600308960662",
      uuid: "7488a646-e31f-11e4-aace-600308960662",
      when: "2010-04-17T14:00:00Z"
    }
    @update_attrs %{
      amount: "456.7",
      recipient: "7488a646-e31f-11e4-aace-600308960668",
      sender: "7488a646-e31f-11e4-aace-600308960668",
      uuid: "7488a646-e31f-11e4-aace-600308960668",
      when: "2011-05-18T15:01:01Z"
    }
    @invalid_attrs %{amount: nil, recipient: nil, sender: nil, uuid: nil, when: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.recipient == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.sender == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Accounts.update_transaction(transaction, @update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.recipient == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.sender == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "accounts" do
    alias GraphBanking.Accounts.Account

    @valid_attrs %{currentBalance: "120.5", id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{currentBalance: "456.7", id: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{currentBalance: nil, id: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.currentBalance == Decimal.new("120.5")
      assert account.id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.currentBalance == Decimal.new("456.7")
      assert account.id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "transactions" do
    alias GraphBanking.Accounts.Transaction

    @valid_attrs %{
      amount: "120.5",
      id: "7488a646-e31f-11e4-aace-600308960662",
      recipient: "7488a646-e31f-11e4-aace-600308960662",
      sender: "7488a646-e31f-11e4-aace-600308960662",
      when: "2010-04-17T14:00:00Z"
    }
    @update_attrs %{
      amount: "456.7",
      id: "7488a646-e31f-11e4-aace-600308960668",
      recipient: "7488a646-e31f-11e4-aace-600308960668",
      sender: "7488a646-e31f-11e4-aace-600308960668",
      when: "2011-05-18T15:01:01Z"
    }
    @invalid_attrs %{amount: nil, id: nil, recipient: nil, sender: nil, when: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.id == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.recipient == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.sender == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Accounts.update_transaction(transaction, @update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.id == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.recipient == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.sender == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "transactions" do
    alias GraphBanking.Accounts.Transaction

    @valid_attrs %{
      amount: "120.5",
      uuid: "7488a646-e31f-11e4-aace-600308960662",
      when: "2010-04-17T14:00:00Z"
    }
    @update_attrs %{
      amount: "456.7",
      uuid: "7488a646-e31f-11e4-aace-600308960668",
      when: "2011-05-18T15:01:01Z"
    }
    @invalid_attrs %{amount: nil, uuid: nil, when: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Accounts.update_transaction(transaction, @update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "accounts" do
    alias GraphBanking.Accounts.Account

    @valid_attrs %{currentBalance: "120.5"}
    @update_attrs %{currentBalance: "456.7"}
    @invalid_attrs %{currentBalance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.currentBalance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.currentBalance == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "transactions" do
    alias GraphBanking.Accounts.Transaction

    @valid_attrs %{amount: "120.5", when: "2010-04-17T14:00:00Z"}
    @update_attrs %{amount: "456.7", when: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{amount: nil, when: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Accounts.update_transaction(transaction, @update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "accounts" do
    alias GraphBanking.Accounts.Account

    @valid_attrs %{current_balance: "120.5"}
    @update_attrs %{current_balance: "456.7"}
    @invalid_attrs %{current_balance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.current_balance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.current_balance == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
