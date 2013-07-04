class TransactionDone
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Float
  property :pay_date, DateTime
  property :description, String
  property :is_payment, Boolean
  property :transaction_id, Integer

  belongs_to :account
  
  def self.create(current_account, transaction)
    transaction_done = TransactionDone.for_account(current_account)
    transaction_done.pay_date = transaction.pay_date
    transaction_done.name = transaction.name
    transaction_done.amount = transaction.amount
    transaction_done.is_payment = transaction.is_payment
    transaction_done.description = transaction.description
    return transaction_done
  end
  
  
  def get_name
    return name if name != nil
    return Transaction.find_by_id(transaction).name
  end
  
  def self.for_transaction(transaction)
    done = TransactionDone.new
    done.transaction_id = transaction.id
    done
  end
  
  def self.for_account(account)
    done = TransactionDone.new
    done.account = account
    done
  end
  
  def check_date
    return self.pay_date.is_a?(Date)
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
    end
  end

  
  
  # To view stats 
  def self.from_to(account_id, from_date, to_date, is_payment)
    return TransactionDone.all(:account_id => account_id,:pay_date.gt => from_date, :pay_date.lt => to_date, :is_payment => is_payment)
  end
end
