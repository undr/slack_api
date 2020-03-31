defmodule SlackAPI.Web.Migration do
  use SlackAPI.Web.DefMethods

  defget :exchange, "migration.exchange", ~w[users]a, ~w[to_old]a
end
