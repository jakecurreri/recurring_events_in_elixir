defmodule RecurringEventsWeb.EventControllerTest do
  use RecurringEventsWeb.ConnCase

  import RecurringEvents.SocialFixtures

  alias RecurringEvents.Social.Event

  @create_attrs %{
    duration: 42,
    end_date_utc: ~U[2022-08-09 19:11:00.000000Z],
    is_all_day: true,
    start_date_utc: ~U[2022-08-09 19:11:00.000000Z],
    title: "some title"
  }
  @update_attrs %{
    duration: 43,
    end_date_utc: ~U[2022-08-10 19:11:00.000000Z],
    is_all_day: false,
    start_date_utc: ~U[2022-08-10 19:11:00.000000Z],
    title: "some updated title"
  }
  @invalid_attrs %{duration: nil, end_date_utc: nil, is_all_day: nil, start_date_utc: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "duration" => 42,
               "end_date_utc" => "2022-08-09T19:11:00.000000Z",
               "is_all_day" => true,
               "start_date_utc" => "2022-08-09T19:11:00.000000Z",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "duration" => 43,
               "end_date_utc" => "2022-08-10T19:11:00.000000Z",
               "is_all_day" => false,
               "start_date_utc" => "2022-08-10T19:11:00.000000Z",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
