migration 3, :create_payment_dones do
  up do
    create_table :payment_dones do
      column :id, Integer, :serial => true
      column :date, DateTime
      column :amount, Integer
    end
  end

  down do
    drop_table :payment_dones
  end
end
