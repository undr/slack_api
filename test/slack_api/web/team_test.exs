defmodule SlackAPI.Web.TeamTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Team

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "access_logs" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.accessLogs", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.access_logs(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.accessLogs", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "before" => "1457989166", "count" => "10", "page" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.access_logs(client, before: "1457989166", count: 10, page: 1) == %{ok: true}
    end
  end

  describe "billable_info" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.billableInfo", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.billable_info(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.billableInfo", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "user" => "user"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.billable_info(client, user: "user") == %{ok: true}
    end
  end

  describe "info" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.info(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "team" => "team"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.info(client, team: "team") == %{ok: true}
    end
  end

  describe "integration_logs" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.integrationLogs", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.integration_logs(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.integrationLogs", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "app_id" => "app_id",
          "change_type" => "change_type",
          "count" => "10",
          "page" => "1",
          "service_id" => "service_id",
          "user" => "user"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Team.integration_logs(
        client,
        app_id: "app_id",
        change_type: "change_type",
        count: 10,
        page: 1,
        service_id: "service_id",
        user: "user"
      ) == %{ok: true}
    end
  end
end
