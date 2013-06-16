class TransactionRepeated < Exception
  def initialize()
    super("Error, another transaction with the same name already exists")
  end
end

class TransactionError < Exception
end

class MailFormatError < Exception
  def initialize()
    super("Error, the email address must be set with this format: example@domain.com")
  end
end

class NameChanged < Exception
end

class MailChanged < Exception
end

