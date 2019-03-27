defmodule SlackAPI.Web.Groups do
  alias SlackAPI.Web

  def archive(client, channel),
    do: Web.post(client, "groups.archive", {:json, %{channel: channel}})

  def create(client, name, [validate: validate]),
    do: do_create(client, %{name: name, validate: validate})
  def create(client, name, %{validate: validate}),
    do: do_create(client, %{name: name, validate: validate})
  def create(client, name),
    do: do_create(client, %{name: name})

  defp do_create(client, params),
    do: Web.post(client, "groups.create", {:json, params})

  def create_child(client, channel),
    do: Web.get(client, "groups.createChild", %{channel: channel})

  def history(client, channel, params \\ %{})
  def history(client, channel, %{} = params),
    do: history(client, channel, Enum.into(params, []))
  def history(client, channel, params) when is_list(params),
    do: Web.get(client, "groups.history", Keyword.put(params, :channel, channel))

  def info(client, channel, [include_locale: include_locale]),
    do: do_info(client, channel: channel, include_locale: include_locale)
  def info(client, channel, %{include_locale: include_locale}),
    do: do_info(client, channel: channel, include_locale: include_locale)
  def info(client, channel),
    do: do_info(client, channel: channel)

  defp do_info(client, params),
    do: Web.get(client, "groups.info", params)

  def invite(client, channel, user),
    do: Web.post(client, "groups.invite", {:json, %{channel: channel, user: user}})

  def kick(client, channel, user),
    do: Web.post(client, "groups.kick", {:json, %{channel: channel, user: user}})

  def leave(client, channel),
    do: Web.post(client, "groups.leave", {:json, %{channel: channel}})

  def list(client, params \\ %{}),
    do: Web.get(client, "groups.list", params)

  def mark(client, channel, ts),
    do: Web.post(client, "groups.mark", {:json, %{channel: channel, ts: ts}})

  def open(client, params \\ %{}),
    do: Web.post(client, "groups.open", {:json, params})

  def rename(client, channel, name),
    do: Web.post(client, "groups.rename", {:json, %{channel: channel, name: name}})

  def replies(client, channel, ts, params \\ %{})
  def replies(client, channel, ts, params) when is_list(params),
    do: replies(client, channel, ts, Enum.into(params, %{}))
  def replies(client, channel, ts, params),
    do: Web.get(client, "groups.replies", Map.merge(params, %{channel: channel, ts: ts}))

  def set_purpose(client, channel, purpose),
    do: Web.post(client, "groups.setPurpose", {:json, %{channel: channel, purpose: purpose}})

  def set_topic(client, channel, topic),
    do: Web.post(client, "groups.setTopic", {:json, %{channel: channel, topic: topic}})

  def unarchive(client, channel),
    do: Web.post(client, "groups.unarchive", {:json, %{channel: channel}})
end
