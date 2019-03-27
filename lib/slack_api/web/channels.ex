defmodule SlackAPI.Web.Channels do
  alias SlackAPI.Web

  def archive(client, channel),
    do: Web.post(client, "channels.archive", {:json, %{channel: channel}})

  def create(client, name, [validate: validate]),
    do: do_create(client, %{name: name, validate: validate})
  def create(client, name, %{validate: validate}),
    do: do_create(client, %{name: name, validate: validate})
  def create(client, name),
    do: do_create(client, %{name: name})

  defp do_create(client, params),
    do: Web.post(client, "channels.create", {:json, params})

  def history(client, channel, params \\ %{})
  def history(client, channel, %{} = params),
    do: history(client, channel, Enum.into(params, []))
  def history(client, channel, params) when is_list(params),
    do: Web.get(client, "channels.history", Keyword.put(params, :channel, channel))

  def info(client, channel, [include_locale: include_locale]),
    do: do_info(client, channel: channel, include_locale: include_locale)
  def info(client, channel, %{include_locale: include_locale}),
    do: do_info(client, channel: channel, include_locale: include_locale)
  def info(client, channel),
    do: do_info(client, channel: channel)

  defp do_info(client, params),
    do: Web.get(client, "channels.info", params)

  def invite(client, channel, user),
    do: Web.post(client, "channels.invite", {:json, %{channel: channel, user: user}})

  def join(client, channel, user, [validate: validate]),
    do: do_join(client, %{channel: channel, user: user, validate: validate})
  def join(client, channel, user, %{validate: validate}),
    do: do_join(client, %{channel: channel, user: user, validate: validate})
  def join(client, channel, user),
    do: do_join(client, %{channel: channel, user: user})

  defp do_join(client, params),
    do: Web.post(client, "channels.join", {:json, params})

  def kick(client, channel, user),
    do: Web.post(client, "channels.kick", {:json, %{channel: channel, user: user}})

  def leave(client, channel),
    do: Web.post(client, "channels.leave", {:json, %{channel: channel}})

  def list(client, params \\ %{}),
    do: Web.get(client, "channels.list", params)

  def mark(client, channel, ts),
    do: Web.post(client, "channels.mark", {:json, %{channel: channel, ts: ts}})

  def rename(client, channel, name, [validate: validate]),
    do: do_rename(client, %{channel: channel, name: name, validate: validate})
  def rename(client, channel, name, %{validate: validate}),
    do: do_rename(client, %{channel: channel, name: name, validate: validate})
  def rename(client, channel, name),
    do: do_rename(client, %{channel: channel, name: name})

  defp do_rename(client, params),
    do: Web.post(client, "channels.rename", {:json, params})

  def replies(client, channel, thread_ts),
    do: Web.get(client, "channels.replies", channel: channel, thread_ts: thread_ts)

  def set_purpose(client, channel, purpose),
    do: Web.post(client, "channels.setPurpose", {:json, %{channel: channel, purpose: purpose}})

  def set_topic(client, channel, topic),
    do: Web.post(client, "channels.setTopic", {:json, %{channel: channel, topic: topic}})

  def unarchive(client, channel),
    do: Web.post(client, "channels.unarchive", {:json, %{channel: channel}})
end
