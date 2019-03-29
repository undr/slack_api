defmodule SlackAPI.Web.RTMTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.RTM

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "connect", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/rtm.connect", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token", "presence_sub" => "0"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert RTM.connect(client, presence_sub: false) == %{ok: true}
  end

  test "start", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/rtm.start", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token", "presence_sub" => "0"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert RTM.start(client, presence_sub: false) == %{ok: true}
  end
end
