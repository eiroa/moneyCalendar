class SortPayments
  def self.getLast(cant)
    payments = Payment.all
    return (payments.sort! { |a,b| a.expiry_date <=> b.expiry_date })[0..cant-1]
  end
end