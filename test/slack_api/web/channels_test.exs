defmodule SlackAPI.Web.ChannelsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Channels

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "archive", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/channels.archive", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"channel":"#channel"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Channels.archive(client, "#channel") == %{ok: true}
  end

  describe "create" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/channels.create", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"name":"channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Channels.create(client, "channel") == %{ok: true}
    end

    test "with validation", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/channels.create", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"validate":"1","name":"channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Channels.create(client, "channel", validate: true) == %{ok: true}
    end

    test "without validation", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/channels.create", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"validate":"0","name":"channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Channels.create(client, "channel", validate: false) == %{ok: true}
    end
  end
end
