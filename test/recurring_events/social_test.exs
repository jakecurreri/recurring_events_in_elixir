defmodule RecurringEvents.SocialTest do
  use RecurringEvents.DataCase

  alias RecurringEvents.Social

  describe "events" do
    alias RecurringEvents.Social.Event

    import RecurringEvents.SocialFixtures

    @invalid_attrs %{duration: nil, end_date_utc: nil, is_all_day: nil, start_date_utc: nil, title: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Social.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Social.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{duration: 42, end_date_utc: ~U[2022-08-09 19:11:00.000000Z], is_all_day: true, start_date_utc: ~U[2022-08-09 19:11:00.000000Z], title: "some title"}

      assert {:ok, %Event{} = event} = Social.create_event(valid_attrs)
      assert event.duration == 42
      assert event.end_date_utc == ~U[2022-08-09 19:11:00.000000Z]
      assert event.is_all_day == true
      assert event.start_date_utc == ~U[2022-08-09 19:11:00.000000Z]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{duration: 43, end_date_utc: ~U[2022-08-10 19:11:00.000000Z], is_all_day: false, start_date_utc: ~U[2022-08-10 19:11:00.000000Z], title: "some updated title"}

      assert {:ok, %Event{} = event} = Social.update_event(event, update_attrs)
      assert event.duration == 43
      assert event.end_date_utc == ~U[2022-08-10 19:11:00.000000Z]
      assert event.is_all_day == false
      assert event.start_date_utc == ~U[2022-08-10 19:11:00.000000Z]
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_event(event, @invalid_attrs)
      assert event == Social.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Social.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Social.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Social.change_event(event)
    end
  end

  describe "event_exceptions" do
    alias RecurringEvents.Social.EventException

    import RecurringEvents.SocialFixtures

    @invalid_attrs %{exception_date_utc: nil}

    test "list_event_exceptions/0 returns all event_exceptions" do
      event_exception = event_exception_fixture()
      assert Social.list_event_exceptions() == [event_exception]
    end

    test "get_event_exception!/1 returns the event_exception with given id" do
      event_exception = event_exception_fixture()
      assert Social.get_event_exception!(event_exception.id) == event_exception
    end

    test "create_event_exception/1 with valid data creates a event_exception" do
      valid_attrs = %{exception_date_utc: ~U[2022-08-09 19:48:00.000000Z]}

      assert {:ok, %EventException{} = event_exception} = Social.create_event_exception(valid_attrs)
      assert event_exception.exception_date_utc == ~U[2022-08-09 19:48:00.000000Z]
    end

    test "create_event_exception/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_event_exception(@invalid_attrs)
    end

    test "update_event_exception/2 with valid data updates the event_exception" do
      event_exception = event_exception_fixture()
      update_attrs = %{exception_date_utc: ~U[2022-08-10 19:48:00.000000Z]}

      assert {:ok, %EventException{} = event_exception} = Social.update_event_exception(event_exception, update_attrs)
      assert event_exception.exception_date_utc == ~U[2022-08-10 19:48:00.000000Z]
    end

    test "update_event_exception/2 with invalid data returns error changeset" do
      event_exception = event_exception_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_event_exception(event_exception, @invalid_attrs)
      assert event_exception == Social.get_event_exception!(event_exception.id)
    end

    test "delete_event_exception/1 deletes the event_exception" do
      event_exception = event_exception_fixture()
      assert {:ok, %EventException{}} = Social.delete_event_exception(event_exception)
      assert_raise Ecto.NoResultsError, fn -> Social.get_event_exception!(event_exception.id) end
    end

    test "change_event_exception/1 returns a event_exception changeset" do
      event_exception = event_exception_fixture()
      assert %Ecto.Changeset{} = Social.change_event_exception(event_exception)
    end
  end
end
