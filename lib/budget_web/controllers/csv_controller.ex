defmodule BudgetWeb.CsvController do
  use BudgetWeb, :controller

  alias Budget.Transactions.Transaction

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    action = Routes.csv_path(conn,:import)
    render(conn, "import.html", action: action)
  end
  def import(conn, %{"upload" => %{"file" => file}}) do
    file.path
    |> File.stream!()
    |> CSV.decode
    |> Enum.map(fn(transaction) ->
      {:ok, [category,description,price,transaction_time]} = transaction
      Budget.Transactions.Transaction.changeset(%Transaction{},%{category: category, description: description, price: price,transaction_time: transaction_time})
      |> Budget.Repo.insert
    end)
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end
end
