defmodule SlackAPI.Web.Usergroups.UsersTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Usergroups.Users

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "list" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/usergroups.users.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "usergroup" => "usergroup"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.list(client, "usergroup") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/usergroups.users.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "usergroup" => "usergroup", "include_disabled" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.list(client, "usergroup", include_disabled: true) == %{ok: true}
    end
  end

  describe "update" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.users.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"users":"users","usergroup":"usergroup"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.update(client, "usergroup", "users") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.users.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"users":"users","usergroup":"usergroup","include_count":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Users.update(client, "usergroup", "users", include_count: true) == %{ok: true}
    end
  end
end
