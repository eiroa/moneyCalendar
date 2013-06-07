class Payment
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :amount, Integer
  property :expiry_date, DateTime
  property :periodicity, Integer
  property :description, String
  belongs_to :account
  
  def self.for_account(account)
    payment = Payment.new
    payment.account = account
    payment
  end

  
end
