Feature: About screen
  As an app contributor,
  I want an about screen,
  So that I can tell users about my contribution.

Background: 
  Given the app is running

Scenario: Bring up about screen
  When I tap "About Us"
  Then I should see "Close" within "//UINavigationBar"
  And I should see "Kevin Zolkiewicz"
  And I should see "Raymond T. Hightower"
  And I should see "ChicagoRuby.org"
  And I should see "WisdomGroup.com"

Scenario: Dismiss the about screen
  When I tap "About Us"
  And I tap "Close"
  Then I should see "Sessions" within "//UINavigationBar"

