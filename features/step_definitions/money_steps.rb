require 'date'

#Given(/^there is payment with name "(.*?)" and date "(.*?)"$/) do |name, date|
Given(/^there is payment with name "([^\"]*)" and date "([^\"]*)"$/) do |name, date|
  p = Payment.for_account(Account.find_by_uid("cucumber_user@someplace.com"))
  p.name = name
  p.expiry_date = Date.parse(date)
  p.save
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

