defmodule SlackAPI.Web.Emoji do
  use SlackAPI.Web.DefMethods

  defget :list, "emoji.list"
end
