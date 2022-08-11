defmodule RecurringEvents.Social.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :duration, :integer
    field :end_date_utc, :utc_datetime_usec
    field :is_all_day, :boolean, default: false
    field :start_date_utc, :utc_datetime_usec
    field :title, :string

    field :is_recurring, :boolean, default: false
    field :recurrence_pattern, :string
    belongs_to :parent, __MODULE__

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :start_date_utc, :end_date_utc, :duration, :is_all_day, :parent_id, :is_recurring, :recurrence_pattern])
    |> validate_required([:title, :start_date_utc, :end_date_utc, :duration, :is_all_day])
  end

  @doc false
  def update_changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :start_date_utc, :end_date_utc, :duration, :is_all_day, :parent_id, :is_recurring, :recurrence_pattern])
  end
end
