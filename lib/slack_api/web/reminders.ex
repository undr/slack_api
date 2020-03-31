defmodule SlackAPI.Web.Reminders do
  use SlackAPI.Web.DefMethods

  defpost :add, "reminders.add", ~w[text time]a, ~w[user]a
  defpost :complete, "reminders.complete", ~w[reminder]a
  defpost :delete, "reminders.delete", ~w[reminder]a
  defget :info, "reminders.info", ~w[reminder]a
  defget :list, "reminders.list"
end
