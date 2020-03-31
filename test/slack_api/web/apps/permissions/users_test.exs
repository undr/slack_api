defmodule SlackAPI.Web.Apps.Permissions.UsersTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Apps.Permissions.Users

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "list" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/apps.permissions.users.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.list(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/apps.permissions.users.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "cursor" => "dXNlcjpVMDYxTkZUVDI=", "limit" => "10"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.list(client, cursor: "dXNlcjpVMDYxTkZUVDI=", limit: 10) == %{ok: true}
    end
  end

  test "request", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/apps.permissions.users.request", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{
        "token" => "token",
        "scopes" => "scopes",
        "trigger_id" => "trigger_id",
        "user" => "user"
      }
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Users.request(client, "scopes", "trigger_id", "user") == %{ok: true}
  end
end
