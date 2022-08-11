defmodule RecurringEventsWeb.EventView do
  use RecurringEventsWeb, :view
  alias RecurringEventsWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      title: event.title,
      start_date_utc: event.start_date_utc,
      end_date_utc: event.end_date_utc,
      duration: event.duration,
      is_all_day: event.is_all_day,
      is_recurring: event.is_recurring,
      recurrence_pattern: event.recurrence_pattern,
      parent_id: event.parent_id,
      parent: render_one_relationship(event.parent, __MODULE__, "event.json", as: :event),
    }
  end

  defp render_one_relationship(%Ecto.Association.NotLoaded{}, _, _, _), do: nil

  defp render_one_relationship(relation, view, template, as) do
      render_one(relation, view, template, as)
  end

  defp render_many_relationship(%Ecto.Association.NotLoaded{}, _, _, _), do: nil

  defp render_many_relationship(relation, view, template, as) do
      render_many(relation, view, template, as)
  end
end
