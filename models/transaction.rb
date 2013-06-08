class Transaction
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Float
  property :expiry_date, DateTime
  property :periodicity, Integer
  property :description, String
end
