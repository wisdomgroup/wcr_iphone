Feature: Venue detail view
  As a conference attendee,
  I want to know where to go,
  And how to get there.

Background: 
  Given the app is running

@wip
Scenario: Bring up venue detail
  When I tap "Map"
  And I wait 5 seconds
  And I tap "more info"
  Then I should see "Illinois Institute of Technology"
  And I should see "3201 S. State St."
  And I should see "Get Directions"

