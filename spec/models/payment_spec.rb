require 'spec_helper'
require 'date'

describe Payment do

  

  describe 'check_date' do

    it 'should return false if expiry_date is before today' do
      payment1 = Payment.new
      payment1.name ='my payment'
      payment1.expiry_date = Date.today-1
      payment1.check_date.should be false
    end

    it 'should return true if expiry_date is today' do
      payment1 = Payment.new
      payment1.name ='my payment'
      payment1.expiry_date = Date.today
      payment1.check_date.should be true
    end


    it 'should return true if expiry_date is after today' do
      payment1 = Payment.new
      payment1.name ='my payment'
      payment1.expiry_date = Date.today+1
      payment1.check_date.should be true
    end

    it 'should return false if expiry_date is not valid' do
      payment1 = Payment.new
      payment1.name ='my payment'
      payment1.expiry_date = 'text'
      payment1.check_date.should be false
    end

  end
  describe 'check_name' do

    it 'should return false if name is nil' do
      payment1 = Payment.new
      payment1.check_name.should be false
    end

    it 'should return false if name is blank' do
      payment1 = Payment.new
      payment1.name ='    '
      payment1.check_name.should be false
    end


    it 'should return true if not empty name is used' do
      payment1 = Payment.new
      payment1.name =' my payment         '
      payment1.check_name.should be true
    end


  end
  
  describe 'check_amount' do

    it 'should return false if amount is nil' do
      payment1 = Payment.new
      payment1.check_amount.should be false
    end

    it 'should return true if amount is a float' do
      payment1 = Payment.new
      payment1.amount=100.5
      payment1.check_amount.should be true
    end


    it 'should return false if not a valid amount' do
      payment1 = Payment.new
      payment1.amount = "aaa"
      payment1.check_amount.should be false
    end

    it 'should return false if negative' do
      payment1 = Payment.new
      payment1.amount = -10
      payment1.check_amount.should be false
    end
  end
  
  describe 'check_periodicity' do

    it 'should return false if nil' do
      payment1 = Payment.new
      payment1.check_periodicity.should be false
    end

    it 'should return false if invalid' do
      payment1 = Payment.new
      payment1.periodicity=-1
      payment1.check_periodicity.should be false
    end
  end
  
  describe 'getErrorMessage' do

    it 'should return "Error, name is required" if name is blank' do
      payment1 = Payment.new
      payment1.getErrorMessage.should eq "Error, name is required"
    end

    it 'should return "Error, invalid date" if payment date is invalid' do
      payment1 = Payment.new
      payment1.name = "payment"
      payment1.expiry_date= "pepe"
      payment1.getErrorMessage.should eq "Error, invalid date"
    end

   it 'should return "Error, invalid amount" if amount is invalid' do
      payment1 = Payment.new
      payment1.name = "payment"
      payment1.expiry_date= Date.today
      payment1.amount = -1
      payment1.getErrorMessage.should eq "Error, invalid amount"
    end
    
    it 'should return "Error, invalid periodicity" if periodicity is invalid' do
      payment1 = Payment.new
      payment1.name = "payment"
      payment1.expiry_date= Date.today
      payment1.amount = 100
      payment1.periodicity = -1.4
      payment1.getErrorMessage.should eq "Error, invalid periodicity"
    end
   
  end
end