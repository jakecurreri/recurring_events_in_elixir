defmodule RecurringEvents.Manager do
  alias RecurringEvents.Social.{Event}

  def list_instances(events, params \\ nil) do
      events
      |> filter_events_by_recurring
      |> Enum.flat_map(& create_instances_of_recurrence(&1))
      |> Enum.map(& filter_by_params(&1, params))
      |> Enum.filter(& !is_nil(&1))
  end

  def filter_events_by_recurring([]), do: []
  def filter_events_by_recurring(events), do: events |> Enum.filter(& &1.is_recurring)

  def create_instances_of_recurrence(nil), do: nil
  def create_instances_of_recurrence(%Event{} = event) do
    RRulex.parse(event.recurrence_pattern)
      |> convert_rrules_into_events(event)
  end

  def convert_rrules_into_events(%RRulex{} = rrules, %Event{} = event) do
    Enum.map(1..rrules.count, fn(x) -> 
      case rrules.frequency do
        :daily ->
          %Event{
            id: Ecto.UUID.generate,
            parent_id: event.id,
            title: "#{event.title} Recurrence ##{x}",
            is_recurring: false,
            duration: event.duration,
            start_date_utc: event.start_date_utc |> Timex.shift(days: x),
            end_date_utc: event.end_date_utc |> Timex.shift(days: x),
          }

        :weekly ->
          %Event{
            id: Ecto.UUID.generate,
            parent_id: event.id,
            title: "#{event.title} Recurrence ##{x}",
            is_recurring: false,
            duration: event.duration,
            start_date_utc: event.start_date_utc |> Timex.shift(weeks: x),
            end_date_utc: event.end_date_utc |> Timex.shift(weeks: x),
          }

        :monthly ->
          %Event{
            id: Ecto.UUID.generate,
            parent_id: event.id,
            title: "#{event.title} Recurrence ##{x}",
            is_recurring: false,
            duration: event.duration,
            start_date_utc: event.start_date_utc |> Timex.shift(months: x),
            end_date_utc: event.end_date_utc |> Timex.shift(months: x),
          }
        
        _ ->
          "Frequency not yet supported."
      end
    end)
  end

  defp filter_by_params(%Event{} = event, _params), do: event
  defp filter_by_params(%Event{} = event, params) do
    # if the query includes parameters
    if params["from"] do
      if Timex.compare(event.start_date_utc, params["from"] |> Timex.parse!("{ISO:Extended}")) > 0  do
        if Timex.compare(event.end_date_utc, params["to"] |> Timex.parse!("{ISO:Extended}")) < 0  do
          event
        end
      end
    else
      event
    end
  end
end