class Transaction
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Float
  property :expiry_date, DateTime
  property :periodicity, Integer
  property :description, String
  property :is_payment, Boolean
  belongs_to :account
  
  def self.for_account(account)
    t = Transaction.new
    t.account = account
    t
  end
  
  def self.payment_for_account(account)
    payment = Transaction.new
    payment.account = account
    payment.is_payment = true
    payment
  end

  def self.income_for_account(account)
    income = Transaction.new
    income.account = account
    income.is_payment = false
    income
  end

  # Params are strings
  def self.create(current_account, is_payment_p, periodicity, name, amount, date, description)
    is_payment = is_payment_p.eql?('0') ? false : true

    if @period.eql?('0')
      transaction = TransactionDone.for_account(current_account)
      transaction.name = name
      transaction.amount = amount
      transaction.date = date
      transaction.is_payment = is_payment
      transaction.description = description
    else
      repeated = Transaction.all(:account_id => current_account.id)
        .first(:name => name, :is_payment => is_payment)
      
      raise TransactionRepeated if repeated != nil
      
      transaction = Transaction.for_account(current_account)
      transaction.name = name
      transaction.amount = amount
      transaction.expiry_date = date
      transaction.periodicity = periodicity
      transaction.is_payment = is_payment
      transaction.description = description
    end
    
    raise TransactionError.new(transaction.get_error_message) if !transaction.validate_fields
    return transaction
  end

  def check_date
    return self.expiry_date.is_a?(Date) && self.expiry_date >= Date.today
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