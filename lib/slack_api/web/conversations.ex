defmodule SlackAPI.Web.Conversations do
  use SlackAPI.Web.DefMethods

  defpost :archive, "conversations.archive", ~w[channel]a
  defpost :close, "conversations.close", ~w[channel]a
  defpost :create, "conversations.create", ~w[name]a, ~w[validate]a
  defget :history, "conversations.history", ~w[channel]a, ~w[count inclusive latest oldest unreads]a
  defget :info, "conversations.info", ~w[channel]a, ~w[include_locale]a
  defpost :invite, "conversations.invite", ~w[channel user]a
  defpost :join, "conversations.join", ~w[name]a, ~w[validate]a
  defpost :kick, "conversations.kick", ~w[channel user]a
  defpost :leave, "conversations.leave", ~w[channel]a
  defget :list, "conversations.list", [], ~w[cursor exclude_archived exclude_members limit]a
  defget :members, "conversations.members", ~w[channel]a, ~w[cursor limit]a
  defpost :open, "conversations.open", [], ~w[channel return_im users]a
  defpost :rename, "conversations.rename", ~w[channel name]a
  defget :replies, "conversations.replies", ~w[channel thread_ts]a, ~w[cursor inclusive latest limit oldest]a
  defpost :set_purpose, "conversations.setPurpose", ~w[channel purpose]a
  defpost :set_topic, "conversations.setTopic", ~w[channel topic]a
  defpost :unarchive, "conversations.unarchive", ~w[channel]a
end
