Feature: Sending Notifications
  As a user
  I want to be able to receive notifications

  Scenario: A notification has been sent
   Given I have an email associated with my account
   And there is payment with name "Gasto-test1" and a notification has been sent remembering its payment
   Then I read the "logs/mail.log" and I should see "Email to: cucumber_user@someplace.com sent at: " now
