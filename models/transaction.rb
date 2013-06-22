class Transaction
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Float
  property :pay_date, DateTime
  property :periodicity, Integer
  property :description, String
  property :is_payment, Boolean
  belongs_to :account
  def self.for_account(account)
    t = Transaction.new
    t.account = account
    t
  end

  # Return "cant" transactions sorted by pay_date
  def self.get_last_sorted(cant, account_id)
    payments = Transaction.all(:account_id => account_id, :is_payment => true, :pay_date.gte => Date.today)
    return (payments.sort! { |a,b| a.pay_date <=> b.pay_date })[0..cant-1]
  end

  # Returns a payment with "account"
  def self.payment_for_account(account)
    payment = Transaction.new
    payment.account = account
    payment.is_payment = true
    payment
  end

  # Returns an income with "account"
  def self.income_for_account(account)
    income = Transaction.new
    income.account = account
    income.is_payment = false
    income
  end
  
  #Increases Transaction Pay Date according to its predefined perodicity
  def self.new_increased_date(account_id, is_payment, name)
    payed = Transaction.find_by_account_id_and_is_payment_and_name(account_id, is_payment, name)  
    if payed.periodicity == 0
        payed.destroy
    else         
        payed.pay_date =  payed.pay_date + (payed.periodicity * 30)
        return payed
               
        #payed.update(:pay_date => newDate)
    end
  end
  # Params are strings
  def self.create(current_account, is_payment_p, periodicity, name, amount, date, description)
    is_payment = is_payment_p.eql?('0') ? false : true

    if periodicity.eql?('0')
      transaction = TransactionDone.for_account(current_account)
      transaction.pay_date = date
    else
      repeated = Transaction.all(:account_id => current_account.id)
        .first(:name => name, :is_payment => is_payment)

      raise TransactionRepeated if repeated != nil

      transaction = Transaction.for_account(current_account)
      transaction.pay_date = date
      transaction.periodicity = periodicity
    end

    transaction.name = name
    transaction.amount = amount
    transaction.is_payment = is_payment
    transaction.description = description

    raise TransactionError.new(transaction.get_error_message) if !transaction.validate_fields
    return transaction
  end

  def check_date
    return self.pay_date.is_a?(Date) && self.pay_date >= Date.today
  end

  def check_amount
    return (self.amount.is_a?(Float)) && (amount > 0)
  end

  def check_name
    return (self.name != nil) && not(self.name.strip.empty?)
  end

  def check_periodicity
    return (self.periodicity.is_a?(Integer)) && (self.periodicity >= 0)
  end

  def validate_fields
    return check_amount && check_date && check_name && check_periodicity
  end

  def get_error_message

    if !check_name
      return "Error, name is required"
    elsif !check_date
      return "Error, invalid date"
    elsif !check_amount
      return "Error, invalid amount"
    elsif !check_periodicity
      return "Error, invalid periodicity"
    end
  end

end
