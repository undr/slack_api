defmodule SlackAPI.Web.RTM do
  alias SlackAPI.Web

  def connect(client, params \\ %{}),
    do: Web.get(client, "rtm.connect", params)

  def start(client, params \\ %{}),
    do: Web.get(client, "rtm.start", params)
end
