defmodule SlackAPI.Web.Chat.ScheduledMessagesTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Chat.ScheduledMessages

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "list" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.scheduledMessages.list", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert ScheduledMessages.list(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.scheduledMessages.list", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"oldest":"1234567890.123456","limit":10,"latest":"1234567890.123456","cursor":"dXNlcjpVMDYxTkZUVDI=","channel":"channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert ScheduledMessages.list(
        client,
        channel: "channel",
        cursor: "dXNlcjpVMDYxTkZUVDI=",
        latest: "1234567890.123456",
        oldest: "1234567890.123456",
        limit: 10
      ) == %{ok: true}
    end
  end
end
