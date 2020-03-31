defmodule SlackAPI.Web.PinsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Pins

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "add", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/pins.add", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"timestamp":"1234567890","channel":"channel"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Pins.add(client, "channel", "1234567890") == %{ok: true}
  end

  test "list", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/pins.list", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token", "channel" => "channel"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Pins.list(client, "channel") == %{ok: true}
  end

  describe "remove" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/pins.remove", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "channel" => "channel"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Pins.remove(client, "channel") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/pins.remove", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "channel" => "channel",
          "file" => "file",
          "file_comment" => "file_comment",
          "timestamp" => "1234567890"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Pins.remove(
        client,
        "channel",
        file: "file",
        file_comment: "file_comment",
        timestamp: "1234567890"
        ) == %{ok: true}
    end
  end
end
