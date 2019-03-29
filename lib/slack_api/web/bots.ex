defmodule SlackAPI.Web.Bots do
  use SlackAPI.Web.DefMethods

  defget :info, "bots.info", [], ~w[bot]a
end
