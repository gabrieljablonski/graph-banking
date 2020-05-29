defmodule GraphBanking.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :decimal
      add :when, :utc_datetime
      add :sender, references(:accounts, on_delete: :nothing, type: :binary_id)
      add :recipient, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:sender])
    create index(:transactions, [:recipient])
  end
end
