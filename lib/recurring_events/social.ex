defmodule RecurringEvents.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias RecurringEvents.Repo

  alias RecurringEvents.Social.Event
  alias RecurringEvents.Manager

  @doc """
  Search Events given Params options
  """
  def search_events(params) do
    Event
    |> where(^filter_events_where(params))
    |> preload([:parent])
  end

  def filter_events_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"title", value}, dynamic ->
        dynamic([e], ^dynamic and ilike(e.title, ^("%#{value}%")))

      {"from", value}, dynamic ->
        dynamic([e], ^dynamic and e.start_date_utc >= ^(Timex.parse!(value, "{ISO:Extended}")))

      {"to", value}, dynamic ->
        dynamic([e], ^dynamic and e.end_date_utc <= ^(Timex.parse!(value, "{ISO:Extended}")))

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates an event's end_date_utc with the last instance from the recurrence pattern.

  ## Examples

      iex> check_and_update_for_recurrence(event)
      event

  """
  def check_and_update_for_recurrence(%Event{} = event) do
    if event.is_recurring do
      last_event_instance = event 
        |> Manager.create_instances_of_recurrence
        |> List.last

      with {:ok, %Event{} = updated_event} <- update_event(event, %{end_date_utc: last_event_instance.end_date_utc}) do
        updated_event
      end
    else
      event
    end
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias RecurringEvents.Social.EventException

  @doc """
  Returns the list of event_exceptions.

  ## Examples

      iex> list_event_exceptions()
      [%EventException{}, ...]

  """
  def list_event_exceptions do
    Repo.all(EventException)
  end

  @doc """
  Gets a single event_exception.

  Raises `Ecto.NoResultsError` if the Event exception does not exist.

  ## Examples

      iex> get_event_exception!(123)
      %EventException{}

      iex> get_event_exception!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_exception!(id), do: Repo.get!(EventException, id)

  @doc """
  Creates a event_exception.

  ## Examples

      iex> create_event_exception(%{field: value})
      {:ok, %EventException{}}

      iex> create_event_exception(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_exception(attrs \\ %{}) do
    %EventException{}
    |> EventException.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_exception.

  ## Examples

      iex> update_event_exception(event_exception, %{field: new_value})
      {:ok, %EventException{}}

      iex> update_event_exception(event_exception, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_exception(%EventException{} = event_exception, attrs) do
    event_exception
    |> EventException.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event_exception.

  ## Examples

      iex> delete_event_exception(event_exception)
      {:ok, %EventException{}}

      iex> delete_event_exception(event_exception)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_exception(%EventException{} = event_exception) do
    Repo.delete(event_exception)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_exception changes.

  ## Examples

      iex> change_event_exception(event_exception)
      %Ecto.Changeset{data: %EventException{}}

  """
  def change_event_exception(%EventException{} = event_exception, attrs \\ %{}) do
    EventException.changeset(event_exception, attrs)
  end
end
