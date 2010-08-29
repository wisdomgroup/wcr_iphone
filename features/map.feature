Feature: Main map view
  As a conference attendee,
  I want to know where to go,
  And how to get there.

Background: 
  Given the app is running

Scenario: Can enter map view
  When I tap "Map"
  Then I should see "Map" within "//UINavigationBar"
  And I should see "Floor Plan" within "//UINavigationBar"

Scenario: Main venue annotation automatically appears
  When I tap "Map"
  And I wait 4 seconds
  Then I should see "WindyCityRails"
  And I should see "The Westin"

