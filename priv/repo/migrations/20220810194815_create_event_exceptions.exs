defmodule RecurringEvents.Repo.Migrations.CreateEventExceptions do
  use Ecto.Migration

  def change do
    create table(:event_exceptions) do
      add :exception_date_utc, :utc_datetime_usec
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps()
    end

    create index(:event_exceptions, [:event_id])
  end
end
