Feature: The Sponsor List tab
  As a conference sponsor
  I want my visibility for my business,

Background: 
  Given the app is running

Scenario: The sponsor list has several names
  When I tap "Sponsors"
  Then I should see "Obtiva"
  And I should see "PayPal X"

Scenario: Can browse to detail view
  Given that I am on the "Sponsors" tab
  When I tap "Obtiva"
  Then I should see "Obtiva provides agile"

