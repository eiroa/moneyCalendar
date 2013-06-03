migration 2, :create_payments do
  up do
    create_table :payments do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :amount, Integer
      column :expiry_date, DateTime
      column :periodicity, DateTime
    end
  end

  down do
    drop_table :payments
  end
end
