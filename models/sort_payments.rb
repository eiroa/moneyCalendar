class SortPayments
  def self.getLast(cant, account_id)
    payments = Transaction.all(:account_id => account_id)
      .all(:is_payment => true)
      .all(:order => [ :expiry_date.asc ])
      
    return payments[0..cant-1]
  end
end