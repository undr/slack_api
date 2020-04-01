defmodule SlackAPI.Web.Team.ProfileTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Team.Profile

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "get" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.profile.get", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Profile.get(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/team.profile.get", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "visibility" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Profile.get(client, visibility: true) == %{ok: true}
    end
  end
end
