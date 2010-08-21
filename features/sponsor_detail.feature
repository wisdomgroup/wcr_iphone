Feature: The sponsor detail view
  As a conference sponsor
  I want conference attendees to be able to learn about my company,
  And visit my web site.

Background: 
  Given the app is running
  And that I am on the "Sponsors" tab

Scenario: Sponsor detail view contains description and link
  When I tap "Obtiva"
  Then I should see "Obtiva provides agile"
  When I scroll down
  Then I should see "Visit Web Site"

Scenario: Sponsor detail is different for each
  When I tap "PayPal X"
  Then I should see "open payments platform,"

