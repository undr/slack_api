defmodule SlackAPI.Web.Dialog do
  use SlackAPI.Web.DefMethods

  defpost :open, "dialog.open", ~w[dialog trigger_id]a
end
