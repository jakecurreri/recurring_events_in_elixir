defmodule RecurringEventsWeb.EventExceptionView do
  use RecurringEventsWeb, :view
  alias RecurringEventsWeb.EventExceptionView

  def render("index.json", %{event_exceptions: event_exceptions}) do
    %{data: render_many(event_exceptions, EventExceptionView, "event_exception.json")}
  end

  def render("show.json", %{event_exception: event_exception}) do
    %{data: render_one(event_exception, EventExceptionView, "event_exception.json")}
  end

  def render("event_exception.json", %{event_exception: event_exception}) do
    %{
      id: event_exception.id,
      exception_date_utc: event_exception.exception_date_utc
    }
  end
end
