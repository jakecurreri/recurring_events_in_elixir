defmodule RecurringEventsWeb.EventExceptionControllerTest do
  use RecurringEventsWeb.ConnCase

  import RecurringEvents.SocialFixtures

  alias RecurringEvents.Social.EventException

  @create_attrs %{
    exception_date_utc: ~U[2022-08-09 19:48:00.000000Z]
  }
  @update_attrs %{
    exception_date_utc: ~U[2022-08-10 19:48:00.000000Z]
  }
  @invalid_attrs %{exception_date_utc: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all event_exceptions", %{conn: conn} do
      conn = get(conn, Routes.event_exception_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event_exception" do
    test "renders event_exception when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_exception_path(conn, :create), event_exception: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_exception_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "exception_date_utc" => "2022-08-09T19:48:00.000000Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_exception_path(conn, :create), event_exception: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event_exception" do
    setup [:create_event_exception]

    test "renders event_exception when data is valid", %{conn: conn, event_exception: %EventException{id: id} = event_exception} do
      conn = put(conn, Routes.event_exception_path(conn, :update, event_exception), event_exception: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_exception_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "exception_date_utc" => "2022-08-10T19:48:00.000000Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event_exception: event_exception} do
      conn = put(conn, Routes.event_exception_path(conn, :update, event_exception), event_exception: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event_exception" do
    setup [:create_event_exception]

    test "deletes chosen event_exception", %{conn: conn, event_exception: event_exception} do
      conn = delete(conn, Routes.event_exception_path(conn, :delete, event_exception))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_exception_path(conn, :show, event_exception))
      end
    end
  end

  defp create_event_exception(_) do
    event_exception = event_exception_fixture()
    %{event_exception: event_exception}
  end
end
