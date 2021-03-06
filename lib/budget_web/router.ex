defmodule BudgetWeb.Router do
  use BudgetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BudgetWeb do
    pipe_through :browser

    get "/", TransactionController, :index
    resources "/transactions", TransactionController
    get "/csv", CsvController, :index
    post "/csv", CsvController, :import
  end

  # Other scopes may use custom stacks.
  # scope "/api", BudgetWeb do
  #   pipe_through :api
  # end
end
