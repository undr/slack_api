defmodule SlackAPI.Web.Apps.PermissionsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Apps.Permissions

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "info", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/apps.permissions.info", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Permissions.info(client) == %{ok: true}
  end

  test "request", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/apps.permissions.request", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"scopes" => "scopes", "trigger_id" => "trigger_id", "token" => "token"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Permissions.request(client, "scopes", "trigger_id") == %{ok: true}
  end
end
