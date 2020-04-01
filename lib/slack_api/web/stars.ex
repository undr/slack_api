defmodule SlackAPI.Web.Stars do
  use SlackAPI.Web.DefMethods

  defpost :add, "stars.add", [], ~w[channel file file_comment timestamp]a
  defget :list, "stars.list", [], ~w[count cursor limit page]a
  defpost :remove, "stars.remove", [], ~w[channel file file_comment timestamp]a
end
