class Payment
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Integer
  property :expiry_date, DateTime
  property :periodicity, DateTime

end
