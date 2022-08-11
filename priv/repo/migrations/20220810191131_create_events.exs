defmodule RecurringEvents.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :start_date_utc, :utc_datetime_usec
      add :end_date_utc, :utc_datetime_usec
      add :duration, :integer
      add :is_all_day, :boolean, default: false, null: false

      timestamps()
    end
  end
end
