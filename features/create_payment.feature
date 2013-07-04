
Feature: Create new Payment
  In order to register a new Payment
  As a user
  I want to be able to register a payment


  Background:
    Given I am logged in
    And there are not transactions 

  Scenario: Happy Path to Payment
    Given I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"

  Scenario: Happy Path to Payment with notification
    Given I have an email associated with my account
    And there are not notifications
    And I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"
    And I check "notify"
    And I fill in "advance_notify" with "1"
    And I fill in "time_notify" with "9:00"  
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"
    Then I should see "You will receive a notification 1 day/s before the 2020-01-01 remembering you to pay it"
    
  Scenario: Happy Path to Single Payment
    Given I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "Single" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Gasto-test payment has been registered"

  Scenario: Name is blank
    Given I visit the register payment page
    And I fill in "name" with ""
    When I press "saveButton"
    Then I should see "Error, name is required"
    
  

  Scenario: Payment already exists
    Given I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2014/10/21"
    And I select "1 Month" from "periodicity" 
    And I press "saveButton"
    
    And I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "5000"
    And I fill in "date" with "2013/11/21"
    And I select "1 Month" from "periodicity"
    And I press "saveButton"
    Then I should see "Error, another transaction with the same name already exists"

  Scenario: Amount is blank
    Given I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "date" with "2013/11/21"
    When I press "saveButton"
    Then I should see "Error, invalid amount"

  Scenario: Payment Date is set earlier than actual date
    Given I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I select "1 Month" from "periodicity"
    And I fill in with a previous date than today "date"
    When I press "saveButton"
    Then I should see "Error, invalid date"

  Scenario: Notifications cannot be activated unless there's an email associated
    Given I don't have an email associated with my account
    And I visit the register payment page
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"
    And I check "notify"
    And I fill in "advance_notify" with "1"
    And I fill in "time_notify" with "9:00"  
    When I press "saveButton"
    Then I should see "Error, you must specify an email address in the profile section in order to receive notifications"

  Scenario: Time in Advance is negative
    Given I visit the register payment page
    And I have an email associated with my account
    And I fill in "name" with "Gasto-test"
    And I fill in "amount" with "1000"
    And I select "1 Month" from "periodicity"
    And I fill in "date" with "2013/11/21"
    And I check "notify"
    And I fill in "advance_notify" with "-1"
    And I fill in "time_notify" with "9:00"
    When I press "saveButton"
    Then I should see "Error, invalid time in advance"

