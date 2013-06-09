require 'date'

#Given(/^there is payment with name "(.*?)" and date "(.*?)"$/) do |name, date|
Given(/^there is payment with name "([^\"]*)" and date "([^\"]*)"$/) do |name, date|
  p = Transaction.payment_for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.expiry_date = Date.parse(date)
  p.save
  p = Transaction.payment_for_account(Account.find_by_uid("cucumber_user@someplace.com"))
end

Given(/^there are not payments$/) do
  Payment.destroy
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
  PaymentDone.destroy
end

Given(/^there is payment_done with name "([^\"]*)" and date "([^\"]*)" and amount "([^\"]*)"$/) do |name, date, amount|
  Given %{there is payment with name "#{name}" and date "#{(Date.today + 1)}"}
  
  p = TransactionDone.for_payment(Transaction.find_payment_by_name(name))
  p.date = Date.parse(date)
  p.amount = amount
  p.is_payment = true
  p.save
end

