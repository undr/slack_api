defmodule SlackAPI.Web.Channels do
  use SlackAPI.Web.DefMethods

  defpost :archive, "channels.archive", ~w[channel]a
  defpost :create, "channels.create", ~w[name]a, ~w[validate]a
  defget :history, "channels.history", ~w[channel]a, ~w[count inclusive latest oldest unreads]a
  defget :info, "channels.info", ~w[channel]a, ~w[include_locale]a
  defpost :invite, "channels.invite", ~w[channel user]a
  defpost :join, "channels.join", ~w[name]a, ~w[validate]a
  defpost :kick, "channels.kick", ~w[channel user]a
  defpost :leave, "channels.leave", ~w[channel]a
  defget :list, "channels.list", [], ~w[cursor exclude_archived exclude_members limit]a
  defpost :mark, "channels.mark", ~w[channel ts]a
  defpost :rename, "channels.rename", ~w[channel name]a, ~w[validate]a
  defget :replies, "channels.replies", ~w[channel thread_ts]a
  defpost :set_purpose, "channels.setPurpose", ~w[channel purpose]a, ~w[name_tagging]a
  defpost :set_topic, "channels.setTopic", ~w[channel topic]a
  defpost :unarchive, "channels.unarchive", ~w[channel]a
end
