
Feature: Create new Payment
  In order to register a new Income
  As a user
  I want to be able to register an income


  Background:
    Given I am logged in
    And there are not transactions

  Scenario: Happy Path
    Given I visit the register income page
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Ingreso-test income has been registered"

  Scenario: Name is blank
    Given I visit the register income page
    And I fill in "name" with ""
    When I press "saveButton"
    Then I should see "Error, name is required"

  Scenario: Income already exists
    Given I visit the register income page
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2014/10/21"
    And I select "1 Month" from "periodicity"
    And I press "saveButton"
    
    And I visit the register income page
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "5000"
    And I fill in "date" with "2013/11/21"
    And I select "1 Month" from "periodicity"
    And I press "saveButton"
    Then I should see "Error, another transaction with the same name already exists"

  Scenario: Amount is blank
    Given I visit the register income page
    And I fill in "name" with "Ingreso-test"
    And I fill in "date" with "2013/11/21"
    When I press "saveButton"
    Then I should see "Error, invalid amount"

  Scenario: Payment Date is set earlier than actual date
    Given I visit the register income page
    And I fill in "name" with "Gasto-test"
    And I select "1 Month" from "periodicity"
    And I fill in with a previous date than today "date"
    When I press "saveButton"
    Then I should see "Error, invalid date"
    
  @wip
  Scenario: Time in Advance is negative
    Given I visit the register income page
    And I fill in "name" with "Gasto-test"
    And I select "1 Month" from "periodicity"
    And I fill in "date" with "2013/11/21"
    And I check "notify"
    And I fill in "advance_notify" with "-1"
    And I fill in "time_notify with "9:00"
    When I press "saveButton"
    Then I should see "Error, invalid time in advance"