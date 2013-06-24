require 'active_support/all'
class Notification
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :notify_date, DateTime
  property :advance_notify, Integer
  
  has 1, :email, :constraint => :destroy
  belongs_to :transaction

  #params => (Transaction, Integer, String, Account)
  def self.add_new(transaction, advance_days, hour, account)
     new_notification = self.new

     new_notification.check_advance_notify(advance_days.to_i)
     email_account = new_notification.check_email_account(account)

     new_notification.notify_date = new_notification.calculate_date(transaction.pay_date, advance_days.to_i, hour)
     new_notification.email = new_notification.new_email(transaction.name, transaction.pay_date, email_account)
     new_notification.advance_notify = advance_days
     return new_notification
  end

  #params => (DateTime, String)
  def update(pay_date, transaction_name)
     new_date = pay_date - self.advance_notify.day
     self.notify_date = DateTime.new(new_date.year, new_date.month, new_date.day, self.notify_date.hour,       
                                     self.notify_date.minute, 0, 0)
     self.email = self.new_email(transaction_name, pay_date, self.email.to)
  end
  
  #params => (DateTime, Integer, String)
  def calculate_date(date, advance_days, hour)
   new_date = date - advance_days.day
   DateTime.new(new_date.year, new_date.month, new_date.day, hour[0..1].to_i, hour[3..4].to_i, 0, 0)
  end

  def check_email_account(account)
      raise TransactionError.new("Error, you must specify an email address in the profile section in order to receive notifications") if account.email.nil?
      return account.email
  end

  #params => (String, DateTime, String)
  def new_email(transaction_name, transaction_pay_date, email_account)
      email = Email.new
      email.to = email_account
      email.subject = "Upcoming payment notification"
      email.body = "The payment corresponding to " + transaction_name + " expires the day: "
                   transaction_pay_date.to_s[0..9] + ". if you have already done the payment
                   please visit..."
      return email
  end
  
  def check_advance_notify(advance_days)
      raise TransactionError.new("Error, invalid time in advance") if advance_days < 0
   end

  def send_mail
    #email(:to => self.email.to, :subject => self.email.subject, :body=> self.email.body)
    open('logs/mail.log', 'a') do |f|
    f.puts "email to:"+self.email.to + " sent at:" + DateTime.now.to_s
    end
  end
end
