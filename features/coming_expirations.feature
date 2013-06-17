@wip
Feature: Coming expirations
  As a user
  I want to be able to view coming expirations

  Background:
  	Given I am logged in
    Given there are not transactions

  Scenario: There are not payments
  	Given there are not payments
  	And I am on "coming expirations page"
  	Then I should see "You don't have upcoming payments"
  
  Scenario: There are less than 10 payments
  	Given there is payment with name "Gasto-test0" and date "2015/11/30"
    And there is payment with name "Gasto-test1" and date "2014/01/30"
    And there is payment with name "Gasto-test2" and date "2014/03/30"
    
    And I am on "coming expirations page"
  		
    Then I should see "Gasto-test1"
    Then I should see "Gasto-test2"
    Then I should see "Gasto-test0"
    
  Scenario: There are 10 payments
    Given there is payment with name "Gasto-test1" and date "2014/01/30"
    And there is payment with name "Gasto-test2" and date "2014/03/30"
    And there is payment with name "Gasto-test3" and date "2014/10/30"
    And there is payment with name "Gasto-test4" and date "2014/09/30"
    And there is payment with name "Gasto-test5" and date "2014/08/30"
    And there is payment with name "Gasto-test6" and date "2014/07/30"
    And there is payment with name "Gasto-test7" and date "2014/04/30"
    And there is payment with name "Gasto-test8" and date "2014/05/30"
    And there is payment with name "Gasto-test9" and date "2014/01/30"
    And there is payment with name "Gasto-test10" and date "2014/06/30"
    
    And I am on "coming expirations page"

    Then I should see "Gasto-test9"
    Then I should see "Gasto-test1"
    Then I should see "Gasto-test2"
    Then I should see "Gasto-test7"
    Then I should see "Gasto-test8"
    Then I should see "Gasto-test10"
    Then I should see "Gasto-test6"
    Then I should see "Gasto-test5"
    Then I should see "Gasto-test4"
    Then I should see "Gasto-test3"
  
  Scenario: There are more than 10 payments
    Given there is payment with name "Gasto-test0" and date "2015/11/30"
    And there is payment with name "Gasto-test1" and date "2014/01/30"
    And there is payment with name "Gasto-test2" and date "2014/03/30"
    And there is payment with name "Gasto-test3" and date "2014/10/30"
    And there is payment with name "Gasto-test4" and date "2014/09/30"
    And there is payment with name "Gasto-test5" and date "2014/08/30"
    And there is payment with name "Gasto-test6" and date "2014/07/30"
    And there is payment with name "Gasto-test7" and date "2014/04/30"
    And there is payment with name "Gasto-test8" and date "2014/05/30"
    And there is payment with name "Gasto-test9" and date "2014/01/30"
    And there is payment with name "Gasto-test10" and date "2014/06/30"
    
    And I am on "coming expirations page"
    
    Then I should see "Gasto-test9"
    Then I should see "Gasto-test1"
    Then I should see "Gasto-test2"
    Then I should see "Gasto-test7"
    Then I should see "Gasto-test8"
    Then I should see "Gasto-test10"
    Then I should see "Gasto-test6"
    Then I should see "Gasto-test5"
    Then I should see "Gasto-test4"
    Then I should see "Gasto-test3"

  @wip
  Scenario: Buttons are presents
  	Given I am on "coming expirations page"
    When I press "addNewPaymentButton"
    Then I should see "Create a new Payment"
  