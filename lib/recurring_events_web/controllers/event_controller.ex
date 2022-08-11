defmodule RecurringEventsWeb.EventController do
  use RecurringEventsWeb, :controller

  alias RecurringEvents.Social
  alias RecurringEvents.Social.Event

  action_fallback RecurringEventsWeb.FallbackController

  def search(conn, params) do
    events = Social.search_events(params) |> RecurringEvents.Repo.all
    recurring_events = RecurringEvents.Manager.list_instances(events, params)

    render(conn, "index.json", events: Enum.concat(events, recurring_events))
  end

  def index(conn, _params) do
    events = Social.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Social.create_event(event_params) do
      updated_event = Social.check_and_update_for_recurrence(event)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_path(conn, :show, updated_event))
      |> render("show.json", event: updated_event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Social.get_event!(id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Social.get_event!(id)

    with {:ok, %Event{} = event} <- Social.update_event(event, event_params) do
      updated_event = Social.check_and_update_for_recurrence(event)

      render(conn, "show.json", event: updated_event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Social.get_event!(id)

    with {:ok, %Event{}} <- Social.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
