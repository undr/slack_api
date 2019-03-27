defmodule SlackAPI.RTM.ErrorHandler.Behaviour do
  @callback handle(tuple()) :: any()
  @callback handle(map(), list()) :: any()
end

defmodule SlackAPI.RTM.ErrorHandler do
  @behaviour SlackAPI.RTM.ErrorHandler.Behaviour
  require Logger

  def handle(error),
    do: Logger.error(~c[RTM handler returns error clause: {:error, {:handler, "#{error}"}}])

  def handle(exception, strace),
    do: Logger.error("#{Exception.message(exception)}\n#{Exception.format_stacktrace(strace)}")
end
