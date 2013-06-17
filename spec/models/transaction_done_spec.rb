require 'spec_helper'

describe TransactionDone do
  before(:each) do
    @transaction = TransactionDone.new
    @transaction.name ='my payment'
  end

  describe 'for_account(account)' do
    it 'should return a TransactionDone with account' do
      account = Account.new
      transaction = TransactionDone.for_account(account)
      transaction.account.should eq account
    end
  end

  describe 'for_transaction(transaction)' do
    it 'should return a TransactionDone with transaction' do
      transaction = Transaction.new
      transaction.id = 1

      transaction_done = TransactionDone.for_transaction(transaction)
      transaction_done.transaction_id.should eq transaction.id
    end
  end

  describe 'payments_from_to(from_date, to_date)' do
    it 'should return a empty list of TransactionDone when there are not payments between specified dates' do
      date1 = Date.today
      date2 = Date.today + 1

      TransactionDone.should_receive(:from_to).with(Date.today, Date.today + 1, true).and_return([])

      result = TransactionDone.from_to(Date.today, Date.today + 1,true)
      result.should eq []
    end
  end

  describe 'incomes_from_to(from_date, to_date)' do
    it 'should return a empty list of TransactionDone when there are not payments between specified dates' do
      date1 = Date.today
      date2 = Date.today + 1

      TransactionDone.should_receive(:from_to).with(Date.today, Date.today + 1, false).and_return([])

      result = TransactionDone.from_to(Date.today, Date.today + 1,false)
      result.should eq []
    end
  end

  describe 'from_to(from_date, to_date)' do
    it 'should return a empty list of TransactionDone when there are not payments between specified dates' do
      date1 = Date.today
      date2 = Date.today + 1

      TransactionDone.should_receive(:all).with(:pay_date.gt => date1, :pay_date.lt => date2, :is_payment => true).and_return([])

      result = TransactionDone.from_to(date1, date2, true)
      result.should eq []
    end
    
    it 'should return a empty list of TransactionDone when there are not incomes between specified dates' do
      date1 = Date.today
      date2 = Date.today + 1

      TransactionDone.should_receive(:all).with(:pay_date.gt => date1, :pay_date.lt => date2, :is_payment => false).and_return([])

      result = TransactionDone.from_to(date1, date2, false)
      result.should eq []
    end
  end

  describe 'check_date' do

    it 'should return true if pay_date is before today and Single Periodicity' do
      @transaction.pay_date = Date.today-1
      @transaction.check_date.should be true
    end

    it 'should return true if pay_date is today' do
      @transaction.pay_date = Date.today
      @transaction.check_date.should be true
    end

    it 'should return true if pay_date is after today' do
      @transaction.pay_date = Date.today + 1
      @transaction.check_date.should be true
    end

    it 'should return false if pay_date is not valid' do
      @transaction.pay_date = 'text'
      @transaction.check_date.should be false
    end

  end

  describe 'check_name' do

    it 'should return false if name is nil' do
      @transaction.name = nil
      @transaction.check_name.should be false
    end

    it 'should return false if name is blank' do
      @transaction.name = '    '
      @transaction.check_name.should be false
    end

    it 'should return true if not empty name is used' do
      @transaction.name = ' my payment         '
      @transaction.check_name.should be true
    end

  end

  describe 'check_amount' do

    it 'should return false if amount is nil' do
      @transaction.check_amount.should be false
    end

    it 'should return true if amount is a float' do
      @transaction.amount = 100.5
      @transaction.check_amount.should be true
    end

    it 'should return false if not a valid amount' do
      @transaction.amount = "aaa"
      @transaction.check_amount.should be false
    end

    it 'should return false if negative' do
      @transaction.amount = -10
      @transaction.check_amount.should be false
    end
  end

  describe 'get_error_message' do

    it 'should return "Error, name is required" if name is blank' do
      @transaction.name = nil
      @transaction.get_error_message.should eq "Error, name is required"
    end

    it 'should return "Error, invalid date" if payment date is invalid' do
      @transaction.pay_date = "pepe"
      @transaction.get_error_message.should eq "Error, invalid date"
    end

    it 'should return "Error, invalid amount" if amount is invalid' do
      @transaction.pay_date = Date.today
      @transaction.amount = -1
      @transaction.get_error_message.should eq "Error, invalid amount"
    end
  end
end
