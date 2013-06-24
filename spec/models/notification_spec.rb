require 'spec_helper'

describe Notification do
  describe 'add_new' do
    before(:each) do
      acc= Account.new
      acc.email="roberto@rmail.com"
      transaction = Transaction.new
      transaction.pay_date=DateTime.now
      transaction.name="abl"
      @notification=Notification.add_new(transaction,5,"20:00",acc)
    end
    it 'should assign email' do
      @notification.email.to.should eq "roberto@rmail.com"
    end
    it 'should assign advance_notify' do
      @notification.advance_notify.should eq 5
    end
  end
  describe 'update' do
    it 'should update notification information' do
      old_date = DateTime.now
      acc= Account.new
      acc.email="roberto@rmail.com"
      transaction = Transaction.new
      transaction.pay_date=old_date
      transaction.name="abl"
      notification=Notification.add_new(transaction,5,"20:00",acc)
      notification.update(DateTime.now,transaction.name)
      notification.notify_date.should_not eq old_date
    end
  end
  describe 'calculate_date' do
    it 'should return the date of next notification' do
      date = DateTime.new(2013,9,6,0,0,0,0)
      notification = Notification.new
      notification.calculate_date(date,1,"15:00").should eq DateTime.new(2013,9,5,15,0,0,0)
    end
  end
  describe 'new_email' do
    it 'should return a email with all inst vars initialized' do
      notification = Notification.new
      email=notification.new_email("hola",DateTime.now,"roberto_perez@rpmail.com")
      email.to.should eq "roberto_perez@rpmail.com"
      email.subject.should eq "Upcoming payment notification"
    end
  end
  describe 'check_advance_notify' do
    it 'should raise an exception when notification advance time is negative' do
    notification = Notification.new
    lambda{notification.check_advance_notify(-1)}.should raise_error
    end
    
    it 'should not raise an exception when notification advance time is positive' do
    notification = Notification.new
    lambda{notification.check_advance_notify(1)}.should_not raise_error
    end
  end
  describe 'check_email_account' do
    it 'should raise an exception when email address is empty' do
    notification = Notification.new
    acc= Account.new
    lambda{notification.check_email_account(acc)}.should raise_error
    end
    
    it 'should not raise an exception when email address is not empty' do
    notification = Notification.new
    acc= Account.new
    acc.email= 'roberto_perez@rpmail.com'
    lambda{notification.check_email_account(acc)}.should_not raise_error
    end
  end
end
