Feature: Venue detail view
  As a conference attendee,
  I want to know where to go,
  And how to get there.

Background: 
  Given the app is running

Scenario: Bring up venue detail
  When I tap "Map"
  And I wait 5 seconds
  And I tap "more info"
  Then I should see "The Westin Chicago River North"
  And I should see "320 N Dearborn St"
  And I should see "Get Directions"

