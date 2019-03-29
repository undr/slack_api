defmodule SlackAPI.Web.Chat.ScheduledMessages do
  use SlackAPI.Web.DefMethods

  defpost :all, "chat.scheduledMessages.list", [], ~w[channel cursor latest limit oldest]a
end
