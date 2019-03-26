defmodule Budget.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :category, :string
    field :description, :string
    field :price, :decimal
    field :transaction_time, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:description, :price, :category, :transaction_time])
    |> validate_required([:description, :price, :category, :transaction_time])
  end
end
