defmodule SlackAPI.Web.AppsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Apps

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "uninstall", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/apps.uninstall", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"client_secret" => "client_secret", "client_id" => "client_id", "token" => "token"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Apps.uninstall(client, "client_id", "client_secret") == %{ok: true}
  end
end
