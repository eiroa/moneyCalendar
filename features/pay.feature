@wip
Feature: Pay an upcoming Payment
  As a user
  I want to be able to paymy upcoming payments

  Background:
  	Given I am logged in

  Scenario: There is one upcoming payment and i want to set it as payed
  	Given there is payment with name "Gasto-test0" and date "2015/11/30"
  	And I am on "coming expirations page"
  	And I press "pay_Gasto-test0_button"
  	And i fill in "paymentDate" with today
  	And i press "confirmPayment"
  	Then i should see "The Gasto-test0" payment has been set as payed"