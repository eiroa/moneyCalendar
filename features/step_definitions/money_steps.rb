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

