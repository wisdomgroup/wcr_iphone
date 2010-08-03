Feature: The sponsor detail view
  As a conference sponsor
  I want conference attendees to be able to learn about my company,
  And visit my web site.

Background: 
  Given the app is running
  And that I am on the "Sponsors" tab

Scenario: Sponsor detail view contains all a description
  When I tap "MarkLogic"
  Then I should see "MarkLogic Corporation is a"

Scenario: Sponsor detail view contains a link to the web site
  When I tap "MarkLogic"
  And I scroll down
  Then I should see "Visit Web Site"

Scenario: Sponsor detail is different for each
  When I tap "Obtiva"
  Then I should see "Obtiva provides"

