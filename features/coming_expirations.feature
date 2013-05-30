@wip
Feature: Coming expirations
  As a user
  I want to be able to view coming expirations

  Background:
    Given i am logged in
    And I fill in "payments[0]" with "Gasto-test1"
    And I fill in "payments[1]" with "Gasto-test2"
    And I fill in "payments[8]" with "Gasto-test9"
    And I fill in "payments[9]" with "Gasto-test10"
    And I fill in "payments[10]" with "Gasto-test11"

  Scenario: Happy Path
    Given I am on "coming expirations page"
    Then I should see "Gasto-test1"
    Then I should see "Gasto-test2"
    Then I should see "Gasto-test10"

    When I press "Add new spending button"
    Then I should see "register payment page"