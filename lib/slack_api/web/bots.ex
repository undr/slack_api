defmodule SlackAPI.Web.Bots do
  alias SlackAPI.Web

  def info(client),
    do: Web.get(client, "bots.info")
  def info(client, name),
    do: Web.get(client, "bots.info", bot: name)
end
