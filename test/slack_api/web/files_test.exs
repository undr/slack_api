defmodule SlackAPI.Web.FilesTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Files

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "comments" do
    assert Files.comments() == Files.Comments
  end

  test "remote" do
    assert Files.remote() == Files.Remote
  end

  test "delete", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/files.delete", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"file":"file"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Files.delete(client, "file") == %{ok: true}
  end

  test "revoke_public_url", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/files.revokePublicURL", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"file":"file"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Files.revoke_public_url(client, "file") == %{ok: true}
  end

  test "shared_public_url", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/files.sharedPublicURL", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"file":"file"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Files.shared_public_url(client, "file") == %{ok: true}
  end

  describe "info" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "file" => "file"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.info(client, "file") == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "file" => "file",
          "count" => "19",
          "cursor" => "dXNlcjpVMDYxTkZUVDI=",
          "limit" => "10",
          "page" => "1"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.info(client, "file", count: 19, cursor: "dXNlcjpVMDYxTkZUVDI=", limit: 10, page: 1) == %{ok: true}
    end
  end

  describe "list" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.list(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "channel" => "channel",
          "count" => "10",
          "page" => "1",
          "show_files_hidden_by_limit" => "1",
          "ts_from" => "1234567890",
          "ts_to" => "1234567890",
          "types" => "images",
          "user" => "user"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.list(
        client,
        channel: "channel",
        count: 10,
        page: 1,
        show_files_hidden_by_limit: true,
        ts_from: "1234567890",
        ts_to: "1234567890",
        types: "images",
        user: "user"
      ) == %{ok: true}
    end
  end

  describe "upload" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/files.upload", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.upload(client) == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/files.upload", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"title":"title","thread_ts":"1234567890.123456","initial_comment":"initial_comment","filetype":"filetype","filename":"filename","file":"file","content":"content","channels":"channels"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Files.upload(
        client,
        channels: "channels",
        content: "content",
        file: "file",
        filename: "filename",
        filetype: "filetype",
        initial_comment: "initial_comment",
        thread_ts: "1234567890.123456",
        title: "title"
      ) == %{ok: true}
    end
  end
end
