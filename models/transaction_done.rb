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
  
  def get_name
    return name if name != nil
    return Transaction.find_by_id(transaction).name
  end
  
  def self.for_transaction(transaction)
    done = TransactionDone.new
    done.transaction = transaction
    done
  end
  
  def self.payments_from_to(from_date, to_date)
    return TransactionDone.from_to(from_date, to_date).all(:is_payment => true)
  end
  
  def self.from_to(from_date, to_date)
    return TransactionDone.all(:date.gt => from_date, :date.lt => to_date)
  end
end
