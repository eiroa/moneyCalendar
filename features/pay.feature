@wip
Feature: Pay an upcoming Payment
  As a user
  I want to be able to pay my upcoming payments

  Background:
  	Given I am logged in

  Scenario: There is one upcoming payment and i want to set it as payed
  	Given there is payment with name "Gasto-test0" and date "2015/11/30"
  	And I am on "coming expirations page"
  	And I press "pay_Gasto-test0_button"
  	And I fill in "payment_date" with "today"
  	And I press "confirmPayment"
  	Then I should see "The Gasto-test0 payment has been set as payed"