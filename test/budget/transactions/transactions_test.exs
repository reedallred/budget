defmodule Budget.TransactionsTest do
  use Budget.DataCase

  alias Budget.Transactions

  describe "transactions" do
    alias Budget.Transactions.Transaction

    @valid_attrs %{category: "some category", description: "some description", price: "120.5", transaction_time: ~N[2010-04-17 14:00:00]}
    @update_attrs %{category: "some updated category", description: "some updated description", price: "456.7", transaction_time: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{category: nil, description: nil, price: nil, transaction_time: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction.category == "some category"
      assert transaction.description == "some description"
      assert transaction.price == Decimal.new("120.5")
      assert transaction.transaction_time == ~N[2010-04-17 14:00:00]
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert transaction.category == "some updated category"
      assert transaction.description == "some updated description"
      assert transaction.price == Decimal.new("456.7")
      assert transaction.transaction_time == ~N[2011-05-18 15:01:01]
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
