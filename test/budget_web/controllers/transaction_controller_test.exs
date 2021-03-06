defmodule BudgetWeb.TransactionControllerTest do
  use BudgetWeb.ConnCase

  alias Budget.Transactions

  @create_attrs %{category: "some category", description: "some description", price: "120.5", transaction_time: ~N[2010-04-17 14:00:00]}
  @update_attrs %{category: "some updated category", description: "some updated description", price: "456.7", transaction_time: ~N[2011-05-18 15:01:01]}
  @invalid_attrs %{category: nil, description: nil, price: nil, transaction_time: nil}

  def fixture(:transaction) do
    {:ok, transaction} = Transactions.create_transaction(@create_attrs)
    transaction
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  describe "new transaction" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "create transaction" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_path(conn, :show, id)

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "edit transaction" do
    setup [:create_transaction]

    test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
      conn = get(conn, Routes.transaction_path(conn, :edit, transaction))
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "redirects when data is valid", %{conn: conn, transaction: transaction} do
      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)
      assert redirected_to(conn) == Routes.transaction_path(conn, :show, transaction)

      conn = get(conn, Routes.transaction_path(conn, :show, transaction))
      assert html_response(conn, 200) =~ "some updated category"
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert redirected_to(conn) == Routes.transaction_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(_) do
    transaction = fixture(:transaction)
    {:ok, transaction: transaction}
  end
end
