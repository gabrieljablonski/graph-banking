defmodule GraphBanking.Test.Web.Resolvers.Accounts do
  use GraphBanking.Test.Support.Web.ConnCase

  alias Ecto.UUID
  alias GraphBanking.Web.Resolvers.Accounts

  import GraphBanking.Test.Support.Web.AbsintheUtils

  @new_account %{balance: 100.0}

  def account_query(id) do
    build_query("""
      {
        account(id: "#{id}") {
          id
          currentBalance
        }
      }
    """)
  end

  def open_account_mutation(balance) do
    build_mutation("""
      {
        openAccount(balance: #{balance}) {
          id
          currentBalance
        }
      }
    """)
  end

  def transfer_money_mutation(recipient, sender, amount) do
    build_mutation("""
      {
        transferMoney(amount: #{amount}, recipient: "#{recipient}", sender: "#{sender}") {
          id
          recipient {
            id
            currentBalance
          }
          sender {
            id
            currentBalance
          }
        }
      }
    """)
  end

  describe "Accounts Resolver" do
    test "account_by_id/3 returns the account with the given id", context do
      {:ok, %{id: account_id}} = Accounts.open_account(:root, @new_account, :info)

      query = account_query(account_id)

      response =
        context.conn
        |> post("/graphiql", query)

      assert json_response(response, 200)["data"]["account"]["id"] == account_id
    end

    test "account_by_id/3 with non-existent id returns error", context do
      uuid = UUID.generate()
      query = account_query(uuid)

      response =
        context.conn
        |> post("/graphiql", query)

      expected_message = "account #{uuid} not found"
      [error | _] = json_response(response, 200)["errors"]

      assert error["message"] == expected_message
    end

    test "open_account/3 with valid balance returns a new account", context do
      balance = 100.50
      query = open_account_mutation(balance)

      response =
        context.conn
        |> post("/graphiql", query)

      account = json_response(response, 200)["data"]["openAccount"]

      assert account["currentBalance"] == balance

      query = account_query(account["id"])

      response2 =
        context.conn
        |> post("/graphiql", query)

      data = json_response(response2, 200)["data"]

      assert data["account"]["id"] == account["id"]
      assert data["account"]["currentBalance"] == account["currentBalance"]
    end

    test "open_account/3 with invalid (negative) balance returns error", context do
      query = open_account_mutation(-100.50)

      response =
        context.conn
        |> post("/graphiql", query)

      [error | _] = json_response(response, 200)["errors"]
      expected_message = "balance must be non-negative"

      assert error["message"] == expected_message
    end

    test "transfer_money/3 with valid arguments returns new transaction and changes balances",
         context do
      {:ok, %{id: account1_id}} = Accounts.open_account(:root, @new_account, :info)
      {:ok, %{id: account2_id}} = Accounts.open_account(:root, @new_account, :info)

      amount = @new_account.balance
      query = transfer_money_mutation(account1_id, account2_id, amount)

      response =
        context.conn
        |> post("/graphiql", query)

      transaction = json_response(response, 200)["data"]["transferMoney"]
      recipient = transaction["recipient"]
      sender = transaction["sender"]

      assert recipient["id"] == account1_id
      assert recipient["currentBalance"] == @new_account.balance + amount
      assert sender["id"] == account2_id
      assert sender["currentBalance"] == @new_account.balance - amount
    end

    test "transfer_money/3 with sender same as recipient returns error", context do
      {:ok, %{id: account_id}} = Accounts.open_account(:root, @new_account, :info)

      query = transfer_money_mutation(account_id, account_id, @new_account.balance)

      response =
        context.conn
        |> post("/graphiql", query)

      [error | _] = json_response(response, 200)["errors"]
      expected_message = "sender and recipient must be different"

      assert error["message"] == expected_message
    end

    test "transfer_money/3 with invalid (non-positive) amount returns error", context do
      {:ok, %{id: account1_id}} = Accounts.open_account(:root, @new_account, :info)
      {:ok, %{id: account2_id}} = Accounts.open_account(:root, @new_account, :info)

      query = transfer_money_mutation(account1_id, account2_id, 0)

      response =
        context.conn
        |> post("/graphiql", query)

      [error | _] = json_response(response, 200)["errors"]
      expected_message = "amount transfered must be positive"

      assert error["message"] == expected_message
    end

    test "transfer_money/3 with non-existent sender or recipient returns error", context do
      uuid1 = UUID.generate()
      uuid2 = UUID.generate()
      query = transfer_money_mutation(uuid1, uuid2, 1)

      response =
        context.conn
        |> post("/graphiql", query)

      [error | _] = json_response(response, 200)["errors"]
      expected_message1 = "account #{uuid1} not found"
      expected_message2 = "account #{uuid2} not found"

      assert error["message"] == expected_message1 or error["message"] == expected_message2
    end

    test "transfer_money/3 with insufficient balance returns error", context do
      {:ok, %{id: account1_id}} = Accounts.open_account(:root, @new_account, :info)
      {:ok, %{id: account2_id}} = Accounts.open_account(:root, @new_account, :info)

      amount = @new_account.balance + 1
      query = transfer_money_mutation(account1_id, account2_id, amount)

      response =
        context.conn
        |> post("/graphiql", query)

      [error | _] = json_response(response, 200)["errors"]
      expected_message = "sender's balance ($#{@new_account.balance}) is insufficient"

      assert error["message"] == expected_message
    end
  end
end
