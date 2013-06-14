class TransactionDone
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Integer
  property :date, DateTime
  property :description, String
  property :is_payment, Boolean
  belongs_to :transaction
  belongs_to :account
  
  def get_name
    return name if name != nil
    return Transaction.find_by_id(transaction).name
  end
  
  def self.for_transaction(transaction)
    done = TransactionDone.new
    done.transaction = transaction
    done
  end
  
  def self.for_account(account)
    done = TransactionDone.new
    done.account = account
    done
  end
  
  def check_date
    return self.date.is_a?(Date)
  end

  def check_amount
    return (self.amount.is_a?(Float)) && (amount > 0) 
  end

  def check_name
    return (self.name != nil) && not(self.name.strip.empty?)
  end

  def validate_fields
    return check_amount && check_date && check_name
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

  # To view stats  
  def self.payments_from_to(from_date, to_date)
    return TransactionDone.from_to(from_date, to_date).all(:is_payment => true)
  end
  
   def self.incomes_from_to(from_date, to_date)
    return TransactionDone.from_to(from_date, to_date).all(:is_payment => false)
  end
  
  def self.from_to(from_date, to_date)
    return TransactionDone.all(:date.gt => from_date, :date.lt => to_date)
  end
end
