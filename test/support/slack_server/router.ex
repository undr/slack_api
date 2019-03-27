defmodule Test.SlackServer.Router do
  use Plug.Router

  import Plug.Conn

  plug :match
  plug :dispatch, builder_opts()

  get "/api/rtm.start" do
    conn = fetch_query_params(conn)

    response = ~S(
      {
        "ok": true,
        "url": "ws://localhost:51345/ws",
        "self": {"id": "UABCD1234", "name": "walle"},
        "team": {"id": "T1234ABCD", "name": "Example Team"},
        "bots": [{"id": "UABCD1234", "name": "walle"}],
        "channels": [],
        "groups": [],
        "users": [],
        "ims": []
      }
    )

    send_resp(conn, 200, response)
  end

  get "/error/api/rtm.start" do
    conn = fetch_query_params(conn)

    response = ~S(
      {
        "error": "missing_scope",
        "needed": "rtm:stream",
        "ok": false,
        "provided": "identify"
      }
    )

    send_resp(conn, 200, response)
  end
end
