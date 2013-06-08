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
end
