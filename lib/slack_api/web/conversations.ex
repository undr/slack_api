defmodule SlackAPI.Web.Conversations do
  alias SlackAPI.Web

  def archive(client, channel),
    do: Web.post(client, "conversations.archive", {:json, %{channel: channel}})

  def close(client, channel),
    do: Web.post(client, "conversations.close", {:json, %{channel: channel}})

  def create(client, name, params \\ %{})
  def create(client, name, params) when is_list(params),
    do: create(client, name, Enum.into(params, %{}))
  def create(client, name, params),
    do: Web.post(client, "conversations.create", {:json, Map.merge(params, %{name: name})})

  def history(client, channel, params \\ %{})
  def history(client, channel, params) when is_list(params),
    do: history(client, channel, Enum.into(params, %{}))
  def history(client, channel, params),
    do: Web.get(client, "conversations.history", Map.merge(params, %{channel: channel}))

  def info(client, channel, params \\ %{})
  def info(client, channel, params) when is_list(params),
    do: info(client, channel, Enum.into(params, %{}))
  def info(client, channel, params),
    do: Web.get(client, "conversations.info", Map.merge(params, %{channel: channel}))

  def invite(client, channel, users),
    do: Web.post(client, "conversations.invite", {:json, %{channel: channel, users: users}})

  def join(client, channel),
    do: Web.post(client, "conversations.join", {:json, %{channel: channel}})

  def kick(client, channel, user),
    do: Web.post(client, "conversations.kick", {:json, %{channel: channel, user: user}})

  def leave(client, channel),
    do: Web.post(client, "conversations.leave", {:json, %{channel: channel}})

  def list(client, params \\ %{})
  def list(client, params) when is_list(params),
    do: list(client, Enum.into(params, %{}))
  def list(client, params),
    do: Web.get(client, "conversations.list", params)

  def members(client, channel, params \\ %{})
  def members(client, channel, params) when is_list(params),
    do: members(client, channel, Enum.into(params, %{}))
  def members(client, channel, params),
    do: Web.get(client, "conversations.members", Map.merge(params, %{channel: channel}))

  def open(client, params \\ %{}),
    do: Web.post(client, "conversations.open", {:json, params})

  def rename(client, channel, name),
    do: Web.post(client, "conversations.rename", {:json, %{channel: channel, name: name}})

  def replies(client, channel, ts, params \\ %{})
  def replies(client, channel, ts, params) when is_list(params),
    do: replies(client, channel, ts, Enum.into(params, %{}))
  def replies(client, channel, ts, params),
    do: Web.get(client, "conversations.replies", Map.merge(params, %{channel: channel, ts: ts}))

  def set_purpose(client, channel, purpose),
    do: Web.post(client, "conversations.setPurpose", {:json, %{channel: channel, purpose: purpose}})

  def set_topic(client, channel, topic),
    do: Web.post(client, "conversations.setTopic", {:json, %{channel: channel, topic: topic}})

  def unarchive(client, channel),
    do: Web.post(client, "conversations.unarchive", {:json, %{channel: channel}})
end
