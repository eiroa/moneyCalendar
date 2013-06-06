
Feature: Create new Payment
  In order to register a new Payment
  As a user
  I want to be able to register a payment


  Background:
    Given I am logged in  

  Scenario: Happy Path
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"  
    When I press "saveButton"
    Then I should see "Coming expirations"

  Scenario: Name is blank
    Given I am on "register payment page"
    And I fill in "name" with " "
    When I press "saveButton"
    Then I should see "Coming expirations"

  Scenario: Payment already exists
    Given I am on "register payment page"
    And I fill in "name" with "Gasto-test"
    And I press "saveButton"
    And I go to "register payment page"
    And I fill in "name" with "Gasto-test"
    Then I should see "New Payment"

  Scenario: Amount is blank
    Given I am on "register payment page"
    And I fill in "amount" with "1000"
    When I press "saveButton"
    Then I should see "Coming expirations"



  Scenario: Payment Date is set earlier than actual date
    Given I am on "register payment page"
    And I fill in "date" with "2000/1/1"
    When I press "saveButton"
    Then I should see "Coming expirations"  




