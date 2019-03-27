defmodule Test.SlackServer do
  def start(opts \\ []),
    do: Plug.Cowboy.http(Test.SlackServer.Router, opts, port: 51345, dispatch: dispatch(opts))

  def stop,
    do: Plug.Cowboy.shutdown(Test.SlackServer.Router)

  defp dispatch(opts) do
    [
      {
        :_,
        [
          {"/ws", Test.SlackServer.Websocket, opts},
          {:_, Plug.Cowboy.Handler, {Test.SlackServer.Router, opts}}
        ]
      }
    ]
  end
end
