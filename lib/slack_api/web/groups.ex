defmodule SlackAPI.Web.Groups do
  use SlackAPI.Web.DefMethods

  defpost :archive, "groups.archive", ~w[channel]a
  defpost :create, "groups.create", ~w[name]a, ~w[validate]a
  defget :create_child, "groups.createChild", ~w[channel]a
  defget :history, "groups.history", ~w[channel]a, ~w[count inclusive latest oldest unreads]a
  defget :info, "groups.info", ~w[channel]a, ~w[include_locale]a
  defpost :invite, "groups.invite", ~w[channel user]a
  defpost :kick, "groups.kick", ~w[channel user]a
  defpost :leave, "groups.leave", ~w[channel]a
  defget :list, "groups.list", [], ~w[cursor exclude_archived exclude_members limit]a
  defget :mark, "groups.mark", ~w[channel ts]a
  defpost :open, "groups.open", ~w[channel]a
  defpost :rename, "groups.rename", ~w[channel name]a
  defget :replies, "groups.replies", ~w[channel thread_ts]a
  defpost :set_purpose, "groups.setPurpose", ~w[channel purpose]a
  defpost :set_topic, "groups.setTopic", ~w[channel topic]a
  defpost :unarchive, "groups.unarchive", ~w[channel]a
end
