@wip
Feature: Create new Payment
  In order to register a new Payment
  As a user
  I want to be able to register a payment

  Background:
    Given i am logged in

  Scenario: Happy Path
    Given I am on "register payment page"
    And I fill in "payment[name]" with "Gasto-test"
    And I fill in "payment[amount]" with "1000"
    And I fill in "payment[paymentDate]" with "1/1/2020"
    And I fill in "payment[periodicity]" with "1"
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"

  Scenario: Name is blank
    Given I am on "register payment page"
    And I fill in "payment[name]" with " "
    When I press "saveButton"
    Then I should see "Error, name is required"

  Scenario: Payment already exists
    Given I am on "register payment page"
    And I fill in "payment[name]" with "Gasto-test"
    And I press "saveButton"
    And I go to "register payment page"
    And I fill in "payment[name]" with "Gasto-test"
    Then I should see "Warning, another payment with the same name already exists"

  Scenario: Amount is blank
    Given I am on "register payment page"
    And I fill in "payment[amount]" with " "
    When I press "saveButton"
    Then I should see "Error, amount is required"

  Scenario: Amount is not a number
    Given I am on "register payment page"
    And I fill in "payment[amount]" with not anumber
    When I press "saveButton"
    Then I should see "Error, amount is not a number"

  Scenario: Payment Date is blank
    Given I am on "register payment page"
    And I fill in "payment[paymentDate]" with " "
    When I press "saveButton"
    Then I should see "Error, Payment Date is required"  

  Scenario: Payment Date is set earlier than actual date
    Given I am on "register payment page"
    And I fill in "payment[paymentDate]" with "1/1/2000"
    When I press "saveButton"
    Then I should see "Warning, Payment Date is earlier than today"  

  Scenario: Payment Date is not properly formatted
    Given I am on "register payment page"
    And I fill in "payment[paymentDate]" with not a valid date
    When I press "saveButton"
    Then I should see "Error, Payment Date is invalid"  

  Scenario: Periodicity is blank
    Given I am on "register payment page"
    And I fill in "payment[periodicity]" with " "
    When I press "saveButton"
    Then I should see "Error, periodicity is required"

  Scenario: Periodicity is not valid
    Given I am on "register payment page"
    And I fill in "payment[periodicity]" with not a valid periodicity
    When I press "saveButton"
    Then I should see "Error, periodicity is invalid"

