defmodule SlackAPI.Web.Pins do
  use SlackAPI.Web.DefMethods

  defpost :add, "pins.add", ~w[channel timestamp]a
  defget :list, "pins.list", ~w[channel]a
  defget :remove, "pins.remove", ~w[channel]a, ~w[file file_comment timestamp]a
end
