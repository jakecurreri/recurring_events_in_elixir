defmodule RecurringEvents.SocialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RecurringEvents.Social` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        duration: 42,
        end_date_utc: ~U[2022-08-09 19:11:00.000000Z],
        is_all_day: true,
        start_date_utc: ~U[2022-08-09 19:11:00.000000Z],
        title: "some title"
      })
      |> RecurringEvents.Social.create_event()

    event
  end

  @doc """
  Generate a event_exception.
  """
  def event_exception_fixture(attrs \\ %{}) do
    {:ok, event_exception} =
      attrs
      |> Enum.into(%{
        exception_date_utc: ~U[2022-08-09 19:48:00.000000Z]
      })
      |> RecurringEvents.Social.create_event_exception()

    event_exception
  end
end
