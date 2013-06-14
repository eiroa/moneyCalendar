class TransactionRepeated < Exception
  def initialize()
    super("Error, another transaction with the same name already exists")
  end
end

class TransactionError < Exception
end
