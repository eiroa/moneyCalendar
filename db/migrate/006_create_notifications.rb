migration 6, :create_notifications do
  up do
    create_table :notifications do
      column :id, Integer, :serial => true
      column :notify_date, DateTime
      column :advance_notify, Integer
      column :transaction_id, Integer
    end
  end

  down do
    drop_table :notifications
  end
end
