# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GraphBanking.Repo.insert!(%GraphBanking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias GraphBanking.Accounts.Account

GraphBanking.Repo.insert!(%Account{current_balance: 100.0})
GraphBanking.Repo.insert!(%Account{current_balance: 520.15})
GraphBanking.Repo.insert!(%Account{current_balance: 1008.37})
