migration 3, :create_transaction_dones do
  up do
    create_table :transaction_dones do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :amount, Integer
      column :date, DateTime
      column :description, String, :length => 255
      column :is_payment, "BOOLEAN"
      column :transaction_id, Integer
    end
  end

  down do
    drop_table :transaction_dones
  end
end
