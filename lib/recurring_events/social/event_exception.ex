defmodule RecurringEvents.Social.EventException do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_exceptions" do
    field :exception_date_utc, :utc_datetime_usec
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(event_exception, attrs) do
    event_exception
    |> cast(attrs, [:exception_date_utc])
    |> validate_required([:exception_date_utc])
  end
end
