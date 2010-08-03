Feature: The Sponsor List tab
  As a conference sponsor
  I want my visibility for my business,

Background: 
  Given the app is running

Scenario: The sponsor list has several names
  When I tap "Sponsors"
  Then I should see "MarkLogic"
  And I should see "Obtiva"

Scenario: Can browse to detail view
  Given that I am on the "Sponsors" tab
  When I tap "MarkLogic"
  Then I should see "leading provider"

