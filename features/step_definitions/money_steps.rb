require 'date'

Given(/^there is payment with name "([^\"]*)" and date "([^\"]*)"$/) do |name, date|
  p = Transaction.payment_for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.periodicity = 1
  p.pay_date = Date.parse(date)
  p.save
end

Given(/^there is income with name "([^\"]*)" and date "([^\"]*)"$/) do |name, date|
  p = Transaction.income_for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.pay_date = Date.parse(date)
  p.save
end

Given(/^there are not payments$/) do
  Transaction.destroy
end

Given(/^there are not transactions$/) do
  Transaction.destroy
end

Given(/^I am logged in$/) do
  visit "/login"
  fill_in("name", :with => "cucumber_user")
  fill_in("email", :with => "cucumber_user@someplace.com")
  click_button "submit"
end

When(/^I wait a while$/) do
  sleep(2)
end

Given(/^there are not payments_done$/) do
  TransactionDone.destroy
end

Given(/^there are not notifications$/) do
  Notification.destroy
end

Given(/^there are not incomes_received$/) do
  TransactionDone.destroy
end

Given(/^there is payment_done with name "([^\"]*)" and date "([^\"]*)" and amount "([^\"]*)"$/) do |name, date, amount|
  step %{there is payment with name "#{name}" and date "#{(Date.today + 1)}"}
  
  p = TransactionDone.for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.pay_date = Date.parse(date)
  p.amount = amount
  p.is_payment = true
  p.save
end

Given(/^there is income_received with name "([^\"]*)" and date "([^\"]*)" and amount "([^\"]*)"$/) do |name, date, amount|
  step %{there is income with name "#{name}" and date "#{(Date.today + 1)}"}
  
  p = TransactionDone.for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.pay_date = Date.parse(date)
  p.amount = amount
  p.is_payment = false
  p.save
end

Given(/^(?:|I )visit the register payment page$/) do
  step %{I am on "coming expirations page"}
  step %{I follow "addNewPaymentButton"}
end

Given(/^(?:|I )visit the register income page$/) do
  step %{I am on "coming expirations page"}
  step %{I follow "addNewIncomeButton"}
end

Given(/^I have an email associated with my account$/) do
  account =  Account.find_by_uid("cucumber_user@someplace.com")
  account.update(:email => "cucumber_user@someplace.com")
end

Given(/^I don't have an email associated with my account$/) do
   account =  Account.find_by_uid("cucumber_user@someplace.com")
   account.update(:email => nil)
end

Given(/^there is payment with name "(.*?)" and a notification has been sent remembering its payment$/) do |name|
  account = Account.find_by_uid("cucumber_user@someplace.com")  
  t = Transaction.new
  t.name = name
  t.pay_date = DateTime.now + 1
  t.amount = 200
  t.is_payment = true
  n = Notification.add_new(t, 1, "12:00", account)
  n.send_mail
end

Then(/^I read the "(.*?)" and I should see "(.*?)" now$/) do |file, text|
   date = DateTime.now.to_s 
   log_text = text + date[0..9] + ", " + date[11..15]
  (File.readlines(file).any?{ |l| l[log_text] }).should eq true
end

