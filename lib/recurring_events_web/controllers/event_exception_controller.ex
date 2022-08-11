defmodule RecurringEventsWeb.EventExceptionController do
  use RecurringEventsWeb, :controller

  alias RecurringEvents.Social
  alias RecurringEvents.Social.EventException

  action_fallback RecurringEventsWeb.FallbackController

  def index(conn, _params) do
    event_exceptions = Social.list_event_exceptions()
    render(conn, "index.json", event_exceptions: event_exceptions)
  end

  def create(conn, %{"event_exception" => event_exception_params}) do
    with {:ok, %EventException{} = event_exception} <- Social.create_event_exception(event_exception_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_exception_path(conn, :show, event_exception))
      |> render("show.json", event_exception: event_exception)
    end
  end

  def show(conn, %{"id" => id}) do
    event_exception = Social.get_event_exception!(id)
    render(conn, "show.json", event_exception: event_exception)
  end

  def update(conn, %{"id" => id, "event_exception" => event_exception_params}) do
    event_exception = Social.get_event_exception!(id)

    with {:ok, %EventException{} = event_exception} <- Social.update_event_exception(event_exception, event_exception_params) do
      render(conn, "show.json", event_exception: event_exception)
    end
  end

  def delete(conn, %{"id" => id}) do
    event_exception = Social.get_event_exception!(id)

    with {:ok, %EventException{}} <- Social.delete_event_exception(event_exception) do
      send_resp(conn, :no_content, "")
    end
  end
end
