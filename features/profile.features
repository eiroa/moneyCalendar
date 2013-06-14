@wip
Feature: User profile
  As a user
  I want to be able to edit my profile

  Background:
  	Given I am logged in

  Scenario: I want to set my email
  	Given I am on "profile page"
  	And I fill in "email" with "myemail@me.com"
    And I press "saveProfileButton"
    Then I should see "You have changed your email to myemail@me.com"
  
  Scenario: I try to set an invalid email
  	Given I am on "profile page"
  	And I fill in "email" with "pepito"
    And I press "saveProfileButton"
    Then I should see "Error, the email address must be set with this format: example@domain.topDomain"
 
