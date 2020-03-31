defmodule SlackAPI.Web.ReactionsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Reactions

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "add", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/reactions.add", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"timestamp":"1234567890","name":"name","channel":"channel"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Reactions.add(client, "channel", "name", "1234567890") == %{ok: true}
  end

  describe "get" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/reactions.get", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.get(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/reactions.get", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "channel" => "channel",
          "file" => "file",
          "file_comment" => "file_comment",
          "full" => "1",
          "timestamp" => "1234567890"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.get(
        client,
        channel: "channel",
        file: "file",
        file_comment: "file_comment",
        full: true,
        timestamp: "1234567890"
      ) == %{ok: true}
    end
  end

  describe "list" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/reactions.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.list(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/reactions.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "count" => "10",
          "cursor" => "dXNlcjpVMDYxTkZUVDI=",
          "full" => "1",
          "limit" => "10",
          "page" => "1",
          "user" => "user"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.list(
        client,
        count: 10,
        cursor: "dXNlcjpVMDYxTkZUVDI=",
        full: true,
        limit: 10,
        page: 1,
        user: "user"
      ) == %{ok: true}
    end
  end

  describe "remove" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/reactions.remove", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"name":"name"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.remove(client, "name") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/reactions.remove", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"timestamp":"1234567890","name":"name","file_comment":"file_comment","file":"file","channel":"channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Reactions.remove(
        client,
        "name",
        channel: "channel",
        file: "file",
        file_comment: "file_comment",
        timestamp: "1234567890"
      ) == %{ok: true}
    end
  end
end
