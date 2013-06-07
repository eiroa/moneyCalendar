class PaymentDone
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :date, DateTime
  property :amount, Integer
  belongs_to :payment
  
  def self.for_payment(payment)
    p = PaymentDone.new
    p.payment = payment
    p
  end
end
