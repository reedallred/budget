defmodule Budget.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :description, :string
      add :price, :decimal
      add :category, :string
      add :transaction_time, :naive_datetime

      timestamps()
    end

  end
end
