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
  def self.payment_for_account(account)
    payment = Transaction.new
    payment.account = account
    payment.is_payment =true
    payment
  end
  
  def self.income_for_account(account)
    income = Transaction.new
    income.account = account
    income.is_payment =false
    income
  end

  def check_date
    if self.expiry_date.is_a?(Date)
      return self.expiry_date >= Date.today

    else
    return false

    end
  end

  def check_amount
    if self.amount.is_a?(Float)
      return amount>0
    end
    return false
  end
  
  def removeSpacesName
    if self.name!=nil
      self.name = self.name.strip
    end
  end
  
  def check_name
    removeSpacesName  
    return  self.name!=nil && not(self.name.empty?)
  end

  def check_periodicity
    if self.periodicity.is_a?(Integer)
     return  self.periodicity>=0
    else
      return false
    end
  end

  def validate_fields
    return check_amount && check_date && check_name && check_periodicity
  end

  def getErrorMessage

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