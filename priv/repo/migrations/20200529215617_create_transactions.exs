defmodule GraphBanking.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:sender_id, references(:accounts, on_delete: :nothing, type: :binary_id))
      add(:recipient_id, references(:accounts, on_delete: :nothing, type: :binary_id))
      add(:amount, :decimal)
      add(:when, :utc_datetime)

      timestamps()
    end

    create(index(:transactions, [:sender_id]))
    create(index(:transactions, [:recipient_id]))
  end
end
