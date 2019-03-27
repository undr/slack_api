defmodule SlackAPI.Web.Chat do
  alias SlackAPI.Web
  alias SlackAPI.Web.Chat.ScheduledMessages

  def scheduled_messages,
    do: ScheduledMessages

  def delete(client, channel, ts, [as_user: as_user]),
    do: do_delete(client, %{channel: channel, ts: ts, as_user: as_user})
  def delete(client, channel, ts, %{as_user: as_user}),
    do: do_delete(client, %{channel: channel, ts: ts, as_user: as_user})
  def delete(client, channel, ts),
    do: do_delete(client, %{channel: channel, ts: ts})

  defp do_delete(client, params),
    do: Web.post(client, "chat.delete", {:json, params})

  def delete_scheduled_message(client, channel, message_id, [as_user: as_user]),
    do: do_delete_scheduled_message(client, channel: channel, scheduled_message_id: message_id, as_user: as_user)
  def delete_scheduled_message(client, channel, message_id, %{as_user: as_user}),
    do: do_delete_scheduled_message(client, channel: channel, scheduled_message_id: message_id, as_user: as_user)
  def delete_scheduled_message(client, channel, message_id),
    do: do_delete_scheduled_message(client, channel: channel, scheduled_message_id: message_id)

  defp do_delete_scheduled_message(client, params),
    do: Web.post(client, "chat.deleteScheduledMessage", {:json, params})

  def get_permalink(client, channel, message_ts),
    do: Web.get(client, "chat.getPermalink", channel: channel, message_ts: message_ts)

  def me_message(client, channel, text),
    do: Web.post(client, "chat.meMessage", {:json, %{channel: channel, text: text}})

  def post_ephemeral(client, channel, text, user, params \\ %{})
  def post_ephemeral(client, channel, text, user, params) when is_list(params),
    do: post_ephemeral(client, channel, text, user, Enum.into(params, %{}))
  def post_ephemeral(client, channel, text, user, params),
    do: Web.post(client, "chat.postEphemeral", {:json, Map.merge(params, %{channel: channel, text: text, user: user})})

  def post_message(client, channel, text, params \\ %{})
  def post_message(client, channel, text, params) when is_list(params),
    do: post_message(client, channel, text, Enum.into(params, %{}))
  def post_message(client, channel, text, params),
    do: Web.post(client, "chat.postMessage", {:json, Map.merge(params, %{channel: channel, text: text})})

  def schedule_message(client, channel, post_at, text, params \\ %{})
  def schedule_message(client, channel, post_at, text, params) when is_list(params),
    do: schedule_message(client, channel, post_at, text, Enum.into(params, %{}))
  def schedule_message(client, channel, post_at, text, params) do
    Web.post(
      client,
      "chat.scheduleMessage",
      {:json, Map.merge(params, %{channel: channel, post_at: post_at, text: text})}
    )
  end

  def unfurl(client, channel, ts, unfurls, params \\ %{})
  def unfurl(client, channel, ts, unfurls, params) when is_list(params),
    do: unfurl(client, channel, ts, unfurls, Enum.into(params, %{}))
  def unfurl(client, channel, ts, unfurls, params),
    do: Web.post(client, "chat.unfurl", {:json, Map.merge(params, %{channel: channel, ts: ts, unfurls: unfurls})})

  def update(client, channel, ts, text, params \\ %{})
  def update(client, channel, ts, text, params) when is_list(params),
    do: update(client, channel, ts, text, Enum.into(params, %{}))
  def update(client, channel, ts, text, params),
    do: Web.post(client, "chat.update", {:json, Map.merge(params, %{channel: channel, ts: ts, text: text})})
end
