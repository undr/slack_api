defmodule SlackAPI.RTM.ExampleHandler do
  require Logger
  use SlackAPI.RTM.Handler

  def init(data, _options) do
    ims = "#{length(data.ims)} ims"
    bots = "#{length(data.bots)} bots"
    users = "#{length(data.users)} users"
    groups = "#{length(data.groups)} groups"
    channels = "#{length(data.channels)} channels"

    Logger.info("#{bot_name(data.self)} is initialized with #{bots}, #{users}, #{groups}, #{channels}, and #{ims}.")

    {:ok, %{data: data}}
  end

  def handle_message(message, %{data: data}) do
    Logger.info("#{bot_name(data.self)} got message:\n#{inspect(message)}")
    {:ok, %{data: data}}
  end

  def handle_connect(_conn, %{data: data}) do
    Logger.info("Established a connection as #{bot_name(data.self)}")
    {:ok, %{data: data}}
  end

  def handle_disconnect(_, %{data: data}) do
    Logger.info("#{bot_name(data.self)} is disconnected")
    {:ok, %{data: data}}
  end

  def handle_cast(message, %{data: data}) do
    Logger.info("#{bot_name(data.self)} got cast event:\n#{inspect(message)}")
    {:ok, %{data: data}}
  end

  def handle_info(message, %{data: data}) do
    Logger.info("#{bot_name(data.self)} got info event:\n#{inspect(message)}")
    {:ok, %{data: data}}
  end

  defp bot_name(bot),
    do: "#{bot.name} (#{bot.id})"
end
