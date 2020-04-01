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

#### Supported endpoints:

**api**

- [api.test](https://api.slack.com/methods/api.test)

**apps**

- [apps.uninstall](https://api.slack.com/methods/apps.uninstall)
- [apps.permissions.info](https://api.slack.com/methods/apps.permissions.info)
- [apps.permissions.request](https://api.slack.com/methods/apps.permissions.request)
- [apps.permissions.resources.list](https://api.slack.com/methods/apps.permissions.resources.list)
- [apps.permissions.scopes.list](https://api.slack.com/methods/apps.permissions.scopes.list)
- [apps.permissions.users.list](https://api.slack.com/methods/apps.permissions.users.list)
- [apps.permissions.users.request](https://api.slack.com/methods/apps.permissions.users.request)

**auth**

- [auth.revoke](https://api.slack.com/methods/auth.revoke)
- [auth.test](https://api.slack.com/methods/auth.test)

**bots**

- [bots.info](https://api.slack.com/methods/bots.info)

**chat**

- [chat.delete](https://api.slack.com/methods/chat.delete)
- [chat.deleteScheduledMessage](https://api.slack.com/methods/chat.deleteScheduledMessage)
- [chat.getPermalink](https://api.slack.com/methods/chat.getPermalink)
- [chat.meMessage](https://api.slack.com/methods/chat.meMessage)
- [chat.postEphemeral](https://api.slack.com/methods/chat.postEphemeral)
- [chat.postMessage](https://api.slack.com/methods/chat.postMessage)
- [chat.scheduleMessage](https://api.slack.com/methods/chat.scheduleMessage)
- [chat.unfurl](https://api.slack.com/methods/chat.unfurl)
- [chat.update](https://api.slack.com/methods/chat.update)

**conversations**

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

**dialog**

- [dialog.open](https://api.slack.com/methods/dialog.open)

**dnd**

- [dnd.endDnd](https://api.slack.com/methods/dnd.endDnd)
- [dnd.endSnooze](https://api.slack.com/methods/dnd.endSnooze)
- [dnd.info](https://api.slack.com/methods/dnd.info)
- [dnd.setSnooze](https://api.slack.com/methods/dnd.setSnooze)
- [dnd.teamInfo](https://api.slack.com/methods/dnd.teamInfo)

**emoji**

- [emoji.list](https://api.slack.com/methods/emoji.list)

**files**

- [files.delete](https://api.slack.com/methods/files.delete)
- [files.info](https://api.slack.com/methods/files.info)
- [files.list](https://api.slack.com/methods/files.list)
- [files.revokePublicURL](https://api.slack.com/methods/files.revokePublicURL)
- [files.sharedPublicURL](https://api.slack.com/methods/files.sharedPublicURL)
- [files.upload](https://api.slack.com/methods/files.upload)
- [files.comments.delete](https://api.slack.com/methods/files.comments.delete)
- [files.remote.add](https://api.slack.com/methods/files.remote.add)
- [files.remote.info](https://api.slack.com/methods/files.remote.info)
- [files.remote.list](https://api.slack.com/methods/files.remote.list)
- [files.remote.remove](https://api.slack.com/methods/files.remote.remove)
- [files.remote.share](https://api.slack.com/methods/files.remote.share)
- [files.remote.update](https://api.slack.com/methods/files.remote.update)

**migration**

- [migration.exchange](https://api.slack.com/methods/migration.exchange)

**oauth**

- [oauth.access](https://api.slack.com/methods/oauth.access)
- [oauth.token](https://api.slack.com/methods/oauth.token)

**pins**

- [pins.add](https://api.slack.com/methods/pins.add)
- [pins.list](https://api.slack.com/methods/pins.list)
- [pins.remove](https://api.slack.com/methods/pins.remove)

**reactions**

- [reactions.add](https://api.slack.com/methods/reactions.add)
- [reactions.get](https://api.slack.com/methods/reactions.get)
- [reactions.list](https://api.slack.com/methods/reactions.list)
- [reactions.remove](https://api.slack.com/methods/reactions.remove)

**reminders**

- [reminders.add](https://api.slack.com/methods/reminders.add)
- [reminders.complete](https://api.slack.com/methods/reminders.complete)
- [reminders.delete](https://api.slack.com/methods/reminders.delete)
- [reminders.info](https://api.slack.com/methods/reminders.info)
- [reminders.list](https://api.slack.com/methods/reminders.list)

**rtm**

- [rtm.connect](https://api.slack.com/methods/rtm.connect)
- [rtm.start](https://api.slack.com/methods/rtm.start)

**search**

- [search.all](https://api.slack.com/methods/search.all)
- [search.files](https://api.slack.com/methods/search.files)
- [search.messages](https://api.slack.com/methods/search.messages)

**team**

- [team.accessLogs](https://api.slack.com/methods/team.accessLogs)
- [team.billableInfo](https://api.slack.com/methods/team.billableInfo)
- [team.info](https://api.slack.com/methods/team.info)
- [team.integrationLogs](https://api.slack.com/methods/team.integrationLogs)
- [team.profile.get](https://api.slack.com/methods/team.profile.get)

**usergroups**

- [usergroups.create](https://api.slack.com/methods/usergroups.create)
- [usergroups.disable](https://api.slack.com/methods/usergroups.disable)
- [usergroups.enable](https://api.slack.com/methods/usergroups.enable)
- [usergroups.list](https://api.slack.com/methods/usergroups.list)
- [usergroups.update](https://api.slack.com/methods/usergroups.update)
- [usergroups.users.list](https://api.slack.com/methods/usergroups.users.list)
- [usergroups.users.update](https://api.slack.com/methods/usergroups.users.update)

**users**

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
- [users.profile.get](https://api.slack.com/methods/users.profile.get)
- [users.profile.set](https://api.slack.com/methods/users.profile.set)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/slack_api](https://hexdocs.pm/slack_api).
