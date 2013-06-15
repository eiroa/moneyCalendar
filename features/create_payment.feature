
Feature: Create new Payment
  In order to register a new Payment
  As a user
  I want to be able to register a payment


  Background:
    Given I am logged in
    And there are not transactions 

  Scenario: Happy Path to Payment
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"
    
  Scenario: Happy Path to Single Payment
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "Single Payment" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"

  Scenario: Name is blank
    Given I am on "register payment page"
    And I fill in "name" with ""
    When I press "saveButton"
    Then I should see "Error, name is required"
    
  Scenario: PaymentDone already exists
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2014/10/21"
    And I select "Single Payment" from "periodicity"
    And I press "saveButton"
    
    And I go to "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "5000"
    And I fill in "date" with "2013/11/21"
    And I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"

  Scenario: Payment already exists
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2014/10/21"
    And I select "1 Month" from "periodicity" 
    And I press "saveButton"
    
    And I go to "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "5000"
    And I fill in "date" with "2013/11/21"
    And I select "1 Month" from "periodicity"
    And I press "saveButton"
    Then I should see "Error, another transaction with the same name already exists"

  Scenario: Amount is blank
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "date" with "2013/11/21"
    When I press "saveButton"
    Then I should see "Error, invalid amount"

  Scenario: Payment Date is set earlier than actual date
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I select "1 Month" from "periodicity"
    And I fill in with a previous date than today "date"
    When I press "saveButton"
    Then I should see "Error, invalid date"




