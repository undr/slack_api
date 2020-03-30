# SlackAPI

A Slack RTM and Web APIs client.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `slack_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slack_api, "~> 0.1.0"}
  ]
end
```

## Real Time Messaging API

```elixir
defmodule ErrorHandler do
  @behaviour SlackAPI.RTM.ErrorHandler.Behaviour

  def handle(error) do
    # Handle an error
  end

  def handle(exception, strace) do
    # Handle an exception
  end
end
```

```elixir
defmodule RTMHandler do
  use SlackAPI.RTM.Handler

  error ErrorHandler

  def init(data, opts) do
    # prepare a state
    {:ok, state}
  end

  def handle_connect(conn, state) do
    # Handle `connect` event.
    {:ok, state}
  end

  def handle_disconnect(conn, state) do
    # Handle `disconnect` event.
    {:ok, state}
  end

  def handle_message(message, state) do
    # Handle `message` event.
    {:ok, state}
  end

  def handle_cast(message, state) do
    # Handle `cast` event.
    # WebSockex.cast(websocket, {:event, "data"})
    {:ok, state}
  end

  def handle_info(message, state) do
    # Handle `info` event.
    # send(websocket, {:event, "data"})
    {:ok, state}
  end
end
```

```elixir
{:ok, websocket} = SlackAPI.RTM.start({RTMHandler, [token: "TOKEN", url: "https://slack.com"]})
```


## Web API

```elixir
client = SlackAPI.Web.new(token: "TOKEN", url: "https://slack.com")
SlackAPI.Web.api().test(client, foo: "bar")
SlackAPI.Web.api().test(client, %{foo: "bar"})
```

All required params should be explicitly passed into a function as arguments. Order this arguments should be the same as in the list of params in [Slack docs](https://api.slack.com/methods).

Optional params should be passed as a `map()` or `Keyword.t()`. Excess arguments will be filtered out.

```elixir
client = SlackAPI.Web.new(token: "TOKEN", url: "https://slack.com")
SlackAPI.Web.channels().test(client, "channel-name", validate: true)
SlackAPI.Web.channels().create(client, "channel-name", %{validate: true})
```

**Supported endpoints:**

- [api.test](https://api.slack.com/methods/api.test)
- [auth.revoke](https://api.slack.com/methods/auth.revoke)
- [auth.test](https://api.slack.com/methods/auth.test)
- [bots.info](https://api.slack.com/methods/bots.info)
- [channels.archive](https://api.slack.com/methods/channels.archive)
- [channels.create](https://api.slack.com/methods/channels.create)
- [channels.history](https://api.slack.com/methods/channels.history)
- [channels.info](https://api.slack.com/methods/channels.info)
- [channels.invite](https://api.slack.com/methods/channels.invite)
- [channels.join](https://api.slack.com/methods/channels.join)
- [channels.kick](https://api.slack.com/methods/channels.kick)
- [channels.leave](https://api.slack.com/methods/channels.leave)
- [channels.list](https://api.slack.com/methods/channels.list)
- [channels.mark](https://api.slack.com/methods/channels.mark)
- [channels.rename](https://api.slack.com/methods/channels.rename)
- [channels.replies](https://api.slack.com/methods/channels.replies)
- [channels.setPurpose](https://api.slack.com/methods/channels.setPurpose)
- [channels.setTopic](https://api.slack.com/methods/channels.setTopic)
- [channels.unarchive](https://api.slack.com/methods/channels.unarchive)
- [chat.delete](https://api.slack.com/methods/chat.delete)
- [chat.deleteScheduledMessage](https://api.slack.com/methods/chat.deleteScheduledMessage)
- [chat.getPermalink](https://api.slack.com/methods/chat.getPermalink)
- [chat.meMessage](https://api.slack.com/methods/chat.meMessage)
- [chat.postEphemeral](https://api.slack.com/methods/chat.postEphemeral)
- [chat.postMessage](https://api.slack.com/methods/chat.postMessage)
- [chat.scheduleMessage](https://api.slack.com/methods/chat.scheduleMessage)
- [chat.unfurl](https://api.slack.com/methods/chat.unfurl)
- [chat.update](https://api.slack.com/methods/chat.update)
- [conversations.archive](https://api.slack.com/methods/conversations.archive)
- [conversations.close](https://api.slack.com/methods/conversations.close)
- [conversations.create](https://api.slack.com/methods/conversations.create)
- [conversations.history](https://api.slack.com/methods/conversations.history)
- [conversations.info](https://api.slack.com/methods/conversations.info)
- [conversations.invite](https://api.slack.com/methods/conversations.invite)
- [conversations.join](https://api.slack.com/methods/conversations.join)
- [conversations.kick](https://api.slack.com/methods/conversations.kick)
- [conversations.leave](https://api.slack.com/methods/conversations.leave)
- [conversations.list](https://api.slack.com/methods/conversations.list)
- [conversations.members](https://api.slack.com/methods/conversations.members)
- [conversations.open](https://api.slack.com/methods/conversations.open)
- [conversations.rename](https://api.slack.com/methods/conversations.rename)
- [conversations.replies](https://api.slack.com/methods/conversations.replies)
- [conversations.setPurpose](https://api.slack.com/methods/conversations.setPurpose)
- [conversations.setTopic](https://api.slack.com/methods/conversations.setTopic)
- [conversations.unarchive](https://api.slack.com/methods/conversations.unarchive)
- [dialog.open](https://api.slack.com/methods/dialog.open)
- [groups.archive](https://api.slack.com/methods/groups.archive)
- [groups.create](https://api.slack.com/methods/groups.create)
- [groups.createChild](https://api.slack.com/methods/groups.createChild)
- [groups.history](https://api.slack.com/methods/groups.history)
- [groups.info](https://api.slack.com/methods/groups.info)
- [groups.invite](https://api.slack.com/methods/groups.invite)
- [groups.kick](https://api.slack.com/methods/groups.kick)
- [groups.leave](https://api.slack.com/methods/groups.leave)
- [groups.list](https://api.slack.com/methods/groups.list)
- [groups.mark](https://api.slack.com/methods/groups.mark)
- [groups.open](https://api.slack.com/methods/groups.open)
- [groups.rename](https://api.slack.com/methods/groups.rename)
- [groups.replies](https://api.slack.com/methods/groups.replies)
- [groups.setPurpose](https://api.slack.com/methods/groups.setPurpose)
- [groups.setTopic](https://api.slack.com/methods/groups.setTopic)
- [groups.unarchive](https://api.slack.com/methods/groups.unarchive)
- [im.close](https://api.slack.com/methods/im.close)
- [im.history](https://api.slack.com/methods/im.history)
- [im.list](https://api.slack.com/methods/im.list)
- [im.mark](https://api.slack.com/methods/im.mark)
- [im.open](https://api.slack.com/methods/im.open)
- [im.replies](https://api.slack.com/methods/im.replies)
- [oauth.access](https://api.slack.com/methods/oauth.access)
- [oauth.token](https://api.slack.com/methods/oauth.token)
- [rtm.connect](https://api.slack.com/methods/rtm.connect)
- [rtm.start](https://api.slack.com/methods/rtm.start)
- [users.conversations](https://api.slack.com/methods/users.conversations)
- [users.deletePhoto](https://api.slack.com/methods/users.deletePhoto)
- [users.getPresence](https://api.slack.com/methods/users.getPresence)
- [users.identity](https://api.slack.com/methods/users.identity)
- [users.info](https://api.slack.com/methods/users.info)
- [users.list](https://api.slack.com/methods/users.list)
- [users.lookupByEmail](https://api.slack.com/methods/users.lookupByEmail)
- [users.setActive](https://api.slack.com/methods/users.setActive)
- [users.setPhoto](https://api.slack.com/methods/users.setPhoto)
- [users.setPresence](https://api.slack.com/methods/users.setPresence)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/slack_api](https://hexdocs.pm/slack_api).
