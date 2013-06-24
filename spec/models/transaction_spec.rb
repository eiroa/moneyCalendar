require 'spec_helper'

describe Transaction do

  describe 'create(current_account, is_payment_p, periodicity, name, amount, date, description)' do

    describe 'and periodicity = "0"' do
      before(:each) do
        @transaction = TransactionDone.new
        @account = Account.new
        TransactionDone.should_receive(:for_account).with(@account).and_return(@transaction)
      end

      it 'should return a Payment-TransactionDone when is_payment = true' do
        result = Transaction.create(@account, '1', '0', 'name', 100, Date.today, 'description')
        result.should be_an_instance_of(TransactionDone)
      end

      it 'should return a Income-TransactionDone when is_payment = false' do
        result = Transaction.create(@account, '0', '0', 'name', 100, Date.today, 'description')
        result.should be_an_instance_of(TransactionDone)
      end
    end

    describe 'and periodicity != 0' do
      before(:each) do
        @transaction = Transaction.new
        @account = Account.new
        Transaction.should_receive(:for_account).with(@account).and_return(@transaction)
      end

      it 'should return a Payment-Transaction when is_payment_p = true' do
        result = Transaction.create(@account, '1', '1', 'name', '100', Date.today, 'description')
        result.should be_an_instance_of(Transaction)
      end

      it 'should return a Payment-Transaction with is_payment = true when is_payment_p = true' do
        result = Transaction.create(@account, '1', '1', 'name', '100', Date.today, 'description')
        result.is_payment.should eq true
      end

      it 'should return a Income-Transaction when is_payment_p = false' do
        result = Transaction.create(@account, '0', '1', 'name', '100', Date.today, 'description')
        result.should be_an_instance_of(Transaction)
      end

      it 'should return a Income-Transaction with is_payment = false when is_payment_p = false' do
        result = Transaction.create(@account, '0', '1', 'name', '100', Date.today, 'description')
        result.is_payment.should eq false
      end
    end
  end

  describe 'for_account(account)' do
    before(:each) do
      @account = Account.new
      @transaction = Transaction.for_account(@account)
    end

    it 'should return a Transaction for account' do
      @transaction.account.should eq @account
    end
  end

  describe'payment_for_account(account)' do
    before(:each) do
      @account = Account.new
      @transaction = Transaction.payment_for_account(@account)
    end

    it 'should return a Transaction for account' do
      @transaction.account.should eq @account
    end

    it 'should return a Transaction with is_payment = true' do
      @transaction.is_payment.should eq true
    end
  end

  describe'income_for_account(account)' do
    before(:each) do
      @account = Account.new
      @transaction = Transaction.income_for_account(@account)
    end

    it 'should return a Transaction for account' do
      @transaction.account.should eq @account
    end

    it 'should return a Transaction with is_payment = true' do
      @transaction.is_payment.should eq false
    end
  end

  describe 'new_increased_date' do
    before(:each) do
       
        @transaction = Transaction.new
        @account = Account.new
        Transaction.should_receive(:for_account).with(@account).and_return(@transaction)
        Transaction.should_receive(:find_by_account_id_and_is_payment_and_name).with( 1, 
      '1',  'name').and_return(@transaction)
    end
    
#    it 'should increase a transaction pay_date by its periodicity' do
#      target = Transaction.create(@account, '1', '1', 'name', 50, Date.today, 'myDescription')    
#      paymentUpdated = Transaction.new_increased_date(1,'1','name')
#      paymentUpdated.pay_date.should eq Date.today + 30
#    end
  end
  describe 'get_last_sorted' do
    it 'should return [] if there are no transactions' do
      Transaction.should_receive(:all).with(:account_id => 1, :is_payment => true, :pay_date.gte => Date.today).and_return([])

      result = Transaction.get_last_sorted(10, 1)
      result.should eq []
    end

    it 'should return all transactions if there are less transactions than the ones requested' do
      t = Transaction.new
      t.pay_date = Date.today + 2

      t2 = Transaction.new
      t2.pay_date = Date.today + 1

      Transaction.should_receive(:all).with(:account_id => 1, :is_payment => true, :pay_date.gte => Date.today).and_return([
        t, t2
      ])

      result = Transaction.get_last_sorted(10, 1)
      result.should eq [t2, t]
    end

    it 'should return all transactions if i request the same quantity than the ones registered' do
      t = Transaction.new
      t.pay_date = Date.today + 2

      t2 = Transaction.new
      t2.pay_date = Date.today + 1

      t3 = Transaction.new
      t3.pay_date = Date.today + 3

      Transaction.should_receive(:all).with(:account_id => 1, :is_payment => true, :pay_date.gte => Date.today).and_return([
        t, t2, t3
      ])

      result = Transaction.get_last_sorted(3, 1)
      result.should eq [t2, t, t3]
    end

    it 'should return the requested quantity of transactions if there are already more transactions registered' do
      t = Transaction.new
      t.pay_date = Date.today + 2

      t2 = Transaction.new
      t2.pay_date = Date.today + 1

      t3 = Transaction.new
      t3.pay_date = Date.today + 3

      Transaction.should_receive(:all).with(:account_id => 1, :is_payment => true, :pay_date.gte => Date.today).and_return([
        t, t2, t3
      ])

      result = Transaction.get_last_sorted(2, 1)
      result.should eq [t2, t]
    end
  end

  describe 'check_date' do

    it 'should return false if pay_date is before today and not Single Periodicity' do
      payment1 = Transaction.new
      payment1.name ='my payment'
      payment1.pay_date = Date.today-1
      payment1.periodicity =1;
      payment1.check_date.should be false
    end

    it 'should return true if pay_date is today and not single' do
      payment1 = Transaction.new
      payment1.name ='my payment'
      payment1.pay_date = Date.today
      payment1.periodicity =1;
      payment1.check_date.should be true
    end

    it 'should return true if pay_date is today and single periodicity' do
      payment1 = Transaction.new
      payment1.name ='my payment'
      payment1.pay_date = Date.today
      payment1.periodicity =0;
      payment1.check_date.should be true
    end

    it 'should return true if pay_date is after today and not single' do
      payment1 = Transaction.new
      payment1.name ='my payment'
      payment1.pay_date = Date.today+1
      payment1.periodicity =1;
      payment1.check_date.should be true
    end

    it 'should return false if pay_date is not valid' do
      payment1 = Transaction.new
      payment1.name ='my payment'
      payment1.pay_date = 'text'
      payment1.check_date.should be false
    end

  end
  describe 'check_name' do

    it 'should return false if name is nil' do
      payment1 = Transaction.new
      payment1.check_name.should be false
    end

    it 'should return false if name is blank' do
      payment1 = Transaction.new
      payment1.name ='    '
      payment1.check_name.should be false
    end

    it 'should return true if not empty name is used' do
      payment1 = Transaction.new
      payment1.name =' my payment         '
      payment1.check_name.should be true
    end

  end

  describe 'check_amount' do

    it 'should return false if amount is nil' do
      payment1 = Transaction.new
      payment1.check_amount.should be false
    end

    it 'should return true if amount is a float' do
      payment1 = Transaction.new
      payment1.amount=100.5
      payment1.check_amount.should be true
    end

    it 'should return false if not a valid amount' do
      payment1 = Transaction.new
      payment1.amount = "aaa"
      payment1.check_amount.should be false
    end

    it 'should return false if negative' do
      payment1 = Transaction.new
      payment1.amount = -10
      payment1.check_amount.should be false
    end
  end

  describe 'check_periodicity' do

    it 'should return false if nil' do
      payment1 = Transaction.new
      payment1.check_periodicity.should be false
    end

    it 'should return false if invalid' do
      payment1 = Transaction.new
      payment1.periodicity=-1
      payment1.check_periodicity.should be false
    end
  end

  describe 'get_error_message' do

    it 'should return "Error, name is required" if name is blank' do
      payment1 = Transaction.new
      payment1.get_error_message.should eq "Error, name is required"
    end

    it 'should return "Error, invalid date" if payment date is invalid' do
      payment1 = Transaction.new
      payment1.name = "payment"
      payment1.pay_date= "pepe"
      payment1.get_error_message.should eq "Error, invalid date"
    end

    it 'should return "Error, invalid amount" if amount is invalid' do
      payment1 = Transaction.new
      payment1.name = "payment"
      payment1.pay_date= Date.today
      payment1.periodicity = 1;
      payment1.amount = -1
      payment1.get_error_message.should eq "Error, invalid amount"
    end

    it 'should return "Error, invalid periodicity" if periodicity is invalid' do
      payment1 = Transaction.new
      payment1.name = "payment"
      payment1.pay_date= Date.today
      payment1.amount = 100
      payment1.periodicity = -1.4
      payment1.get_error_message.should eq "Error, invalid periodicity"
    end
  end
end
