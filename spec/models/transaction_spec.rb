require 'spec_helper'

describe Transaction do
  
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

  describe 'getErrorMessage' do

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