defmodule SlackAPI.Web.UsergroupsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Usergroups

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "create" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.create", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"name":"name"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.create(client, "name") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.create", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"name":"name","include_count":"1","handle":"handle","description":"description","channels":"channels"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.create(
        client,
        "name",
        channels: "channels",
        description: "description",
        handle: "handle",
        include_count: true
      ) == %{ok: true}
    end
  end

  describe "disable" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.disable", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.disable(client, "usergroup") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.disable", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup","include_count":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.disable(client, "usergroup", include_count: true) == %{ok: true}
    end
  end

  describe "enable" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.enable", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.enable(client, "usergroup") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.enable", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup","include_count":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.enable(client, "usergroup", include_count: true) == %{ok: true}
    end
  end

  describe "list" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/usergroups.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.list(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/usergroups.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "include_count" => "1", "include_disabled" => "1", "include_users" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.list(client, include_count: true, include_disabled: true, include_users: true) == %{ok: true}
    end
  end

  describe "update" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.update(client, "usergroup") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/usergroups.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"usergroup":"usergroup","name":"name","include_count":"1","handle":"handle","description":"description","channels":"channels"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Usergroups.update(
        client,
        "usergroup",
        channels: "channels",
        description: "description",
        handle: "handle",
        include_count: true,
        name: "name"
      ) == %{ok: true}
    end
  end
end
