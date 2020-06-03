# GraphBanking Challenge

Challenge for testing Elixir and GraphQL knowledge.
Project implemented with Elixir and the Phoenix Framework.

## Functionality

The project implements a GraphQL API simulating a bank, offering the following capabilities:

- Open a new account with an initial balance
- Transfer money between two accounts
- Query information about an account, including transactions

### Relevant API Criteria

- All fields are required on mutations
- On opening account, initial balance must be non-negative
- On transactions, sender must have sufficient balance
- On transactions, sender must be different from recipient

### Additional Project Elements

- ~~Event based architecture~~
- ~~Use a CI tool~~
- Follow an Elixir Style Guide ([The Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)) 
- In code documentation
- Unit testing

## GraphQL Commands

### Queries

```graphql
account(id: "<account_uuid>") {
  id
  currentBalance
  sentTransactions {
    id
    recipientId
    amount
    when
  }
  receivedTransactions {
    id
    senderId
    amount
    when
  }
}
```

### Mutations

```graphql
openAccount(balance: <balance>) {
  id
  currentBalance
}
```
```graphql
transferMoney(sender: "<account_uuid>", recipient: "<account_uuid>", amount: <amount>) {
  id
  recipient {
    id
    currentBalance
  }
  amount
  when
}
```

## Running

With [Elixir](https://elixir-lang.org/), [Phoenix Framework](https://www.phoenixframework.org/), and [PostgreSQL](https://www.postgresql.org/)
installed and configured, run the following command to acquire project dependencies:

```sh
mix deps.get
```

Edit the [config/dev.exs](./config/dev.exs) according to desired configurations, and run the following command to setup the database:

```sh
mix ecto.setup
```

Running the following command will boot up the server:

```sh
mix phx.server
```

The GraphiQL tool will be available at the configured host (default [`http://localhost:4000`](http://localhost:4000)) at the `/graphiql` address,
allowing GraphQL queries to be run manually.

## Testing

Unit tests can be run with the following command:

```sh
mix test --trace
```
