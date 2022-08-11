defmodule RecurringEvents.Repo.Migrations.AddRecurrenceToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :is_recurring, :boolean, default: false, null: false
      add :recurrence_pattern, :string
      add :parent_id, references(:events, on_delete: :delete_all)
    end

    create index(:events, [:parent_id])
  end
end
