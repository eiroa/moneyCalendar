class SortPayments
  def self.getLast(cant, account_id)
    payments = Payment.all(:account_id => account_id)
    return (payments.sort! { |a,b| a.expiry_date <=> b.expiry_date })[0..cant-1]
  end
end