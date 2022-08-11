# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RecurringEvents.Repo.insert!(%RecurringEvents.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Enum.map(1..50, fn(x) ->
  start_date_utc = Timex.now() |> Timex.shift(days: x)
  end_date_utc = start_date_utc |> Timex.shift(hours: 1)

  event = %{
    title: "Event #{x}",
    duration: 60,
    start_date_utc: start_date_utc,
    end_date_utc: end_date_utc,
    is_all_day: false,
  }

  event |> RecurringEvents.Social.create_event
end)