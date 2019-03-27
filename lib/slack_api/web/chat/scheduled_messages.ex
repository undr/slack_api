defmodule SlackAPI.Web.Chat.ScheduledMessages do
  alias SlackAPI.Web

  def all(client, params \\ %{}),
    do: Web.post(client, "chat.scheduledMessages.list", params)
end
