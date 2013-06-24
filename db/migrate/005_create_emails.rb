migration 5, :create_emails do
  up do
    create_table :emails do
      column :id, Integer, :serial => true
      column :to, String, :length => 255
      column :subject, String, :length => 255
      column :body, String, :length => 255
      column :notification_id, Integer
    end
  end

  down do
    drop_table :emails
  end
end
