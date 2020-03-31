defmodule SlackAPI.Web.Reactions do
  use SlackAPI.Web.DefMethods

  defpost :add, "reactions.add", ~w[channel name timestamp]a
  defget :get, "reactions.get", [], ~w[channel file file_comment full timestamp]a
  defget :list, "reactions.list", [], ~w[count cursor full limit page user]a
  defpost :remove, "reactions.remove", ~w[name]a, ~w[channel file file_comment timestamp]a
end
