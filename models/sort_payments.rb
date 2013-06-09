class SortPayments
  def self.getLast(cant, account_id)
    
    payments = Transaction.all(:account_id => account_id)
      .all(:is_payment => true , :expiry_date.gte =>Date.today)
      #.all(:order => [ :expiry_date.asc ])

    #return payments[0..cant-1]
    return (payments.sort! { |a,b| a.expiry_date <=> b.expiry_date })[0..cant-1]
  end
end