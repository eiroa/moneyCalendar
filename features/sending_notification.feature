@wip

Feature: Sending Notifications
  As a user
  I want to be able to receive notifications


  Scenario: A notification has been sent
   Given there is payment with name "Gasto-test1" and a notification has been sent to myMail remembering its payment
   And I login to myMail
   Then I should see in myInbox an email with subject "Gasto-test1_Notification"
