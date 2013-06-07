Feature: Create new Payment
  In order to register a new Income
  As a user
  I want to be able to register an income


  Background:
    Given I am logged in  

  Scenario: Happy Path
    Given I am on "register income page"
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2020/1/1"
    And I select "1 Month" from "periodicity"  
    When I press "saveButton"
    Then I should see "The Ingreso-test income has been registered"

  Scenario: Name is blank
    Given I am on "register income page"
    And I fill in "name" with ""
    When I press "saveButton"
    Then I should see "Error, name is required"

  Scenario: Payment already exists
    Given I am on "register income page"
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "1000"
    And I fill in "date" with "2014/10/21"
    And I press "saveButton"
    And I go to "register payment page"
    And I fill in "name" with "Ingreso-test"
    And I fill in "amount" with "5000"
    And I fill in "date" with "2013/11/21"
    And I press "saveButton"
    Then I should see "Error, another income with the same name already exists"

  Scenario: Amount is blank
    Given I am on "register income page"
    And I fill in "amount" with "1000"
    When I press "saveButton"
    Then I should see "Error, amount is required"

  Scenario: Payment Date is set earlier than actual date
    Given I am on "register income page"
    And I fill in "date" with "2000/1/1"
    When I press "saveButton"
    Then I should see "Warning, Income Date is earlier than today"  
