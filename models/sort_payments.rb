class SortPayments
  def self.getLast(cant, account_id)
    payments = Transaction.all(:account_id => account_id)# & Transaction.all(:is_payment =>true)
    
    return (payments.sort! { |a,b| a.expiry_date <=> b.expiry_date })[0..cant-1]
  end
end