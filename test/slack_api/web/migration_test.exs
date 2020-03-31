defmodule SlackAPI.Web.MigrationTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Migration

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "exchange" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/migration.exchange", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "users" => "users"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Migration.exchange(client, "users") == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/migration.exchange", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "users" => "users", "to_old" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Migration.exchange(client, "users", to_old: true) == %{ok: true}
    end
  end
end
