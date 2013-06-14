@wip
Feature: Statistics of payments
  As a user
  I want to be able to view how many payments I did in a given period of time

  Background:
  	Given there are not payments_done
  	And I am logged in

  Scenario: There are not payments done
  	Given I am on "coming expirations page"
  	And I fill in "from_date" with "2010/01/01"
    And I fill in "to_date" with "2010/05/01"
    And I press "viewPaymentsStatsButton"

    Then I should see "You don't have payments done in this period"
  
  Scenario: There is a payment done in given period
	Given I am on "coming expirations page"
	And there is payment_done with name "Gasto-test1" and date "2010/04/30" and amount "100"
	
  	And I fill in "from_date" with "2010/01/01"
    And I fill in "to_date" with "2010/05/01"
    And I press "viewPaymentsStatsButton"
 
 	Then I should see "Gasto-test1"
 	Then I should see "2010-04-30"
 	Then I should see "100"
    Then I should see "Total: $100"
  
  Scenario: There are payments done in given period
	Given I am on "coming expirations page"
	And there is payment_done with name "Gasto-test1" and date "2010/03/30" and amount "100"
	And there is payment_done with name "Gasto-test1" and date "2010/04/30" and amount "100"
	And there is payment_done with name "Gasto-test2" and date "2010/02/20" and amount "50"
	
  	And I fill in "from_date" with "2010/01/01"
    And I fill in "to_date" with "2010/05/01"
    And I press "viewPaymentsStatsButton"
 
 	Then I should see "Gasto-test1"
 	Then I should see "2010-03-30"
 	Then I should see "100"
 
 	Then I should see "Gasto-test1"
 	Then I should see "2010-04-30"
 	Then I should see "100"
 	
 	Then I should see "Gasto-test2"
 	Then I should see "2010-02-20"
 	Then I should see "50"
 	
    Then I should see "Total: $250"
  
  Scenario: There are not payments done in given period
	Given I am on "coming expirations page"
	And there is payment_done with name "Gasto-test1" and date "2011/03/30" and amount "100"
	And there is payment_done with name "Gasto-test1" and date "2011/04/30" and amount "100"
	And there is payment_done with name "Gasto-test2" and date "2011/02/20" and amount "50"
	
  	And I fill in "from_date" with "2010/01/01"
    And I fill in "to_date" with "2010/05/01"
    And I press "viewPaymentsStatsButton"
 
 	Then I should see "You don't have payments done in this period"
