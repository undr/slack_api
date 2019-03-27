defmodule Test.SlackServer.Websocket do
  @behaviour :cowboy_websocket

  def init(req, opts) do
    {:cowboy_websocket, req, opts}
  end

  def websocket_init(opts) do
    testpid = Keyword.get(opts, :testpid)
    {:ok, %{testpid: testpid}}
  end

  def websocket_handle({:text, message}, state) do
    {:reply, {:text, ~c[{"type":"message_type", "key":"#{message}"}]}, state}
  end

  def websocket_handle({:ping, message}, state) do
    {:reply, {:pong, message}, state}
  end

  def websocket_info(message, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
