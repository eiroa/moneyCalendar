migration 4, :create_transactions do
  up do
    create_table :transactions do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :amount, Float
      column :pay_date, DateTime
      column :periodicity, Integer
      column :description, String, :length => 255
      column :is_payment, "BOOLEAN"
      column :account_id, Integer
    end
  end

  down do
    drop_table :transactions
  end
end
