defmodule SlackAPI.Web.Chat do
  use SlackAPI.Web.DefMethods

  alias SlackAPI.Web.Chat.ScheduledMessages

  def scheduled_messages,
    do: ScheduledMessages

  defpost :delete, "chat.delete", ~w[channel ts]a, ~w[as_user]a
  defpost :delete_scheduled_message, "chat.deleteScheduledMessage", ~w[channel scheduled_message_id]a, ~w[as_user]a
  defget :get_permalink, "chat.getPermalink", ~w[channel message_ts]a
  defpost :me_message, "chat.meMessage", ~w[channel text]a
  defpost :post_ephemeral, "chat.postEphemeral", ~w[attachments channel text user]a,
    ~w[as_user blocks icon_emoji icon_url link_names parse thread_ts username]a

  defpost :post_message, "chat.postMessage", ~w[channel text]a,
    ~w[as_user attachments blocks link_names parse icon_emoji icon_url mrkdwn reply_broadcast thread_ts unfurl_links unfurl_media username]a

  defpost :schedule_message, "chat.scheduleMessage", ~w[channel post_at text]a,
    ~w[as_user attachments blocks link_names parse reply_broadcast thread_ts unfurl_links unfurl_media]a

  defpost :unfurl, "chat.unfurl", ~w[channel ts unfurls]a, ~w[user_auth_message user_auth_required user_auth_url]a
  defpost :update, "chat.update", ~w[channel ts text]a, ~w[as_user attachments blocks link_names parse]a
end
