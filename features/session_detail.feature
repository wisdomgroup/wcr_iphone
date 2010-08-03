Feature: The session detail view
  As a conference attendee,
  I want to review session details,
  So that I can learn about the talk,
  Learn about the speaker,
  And decide which talks to attend.

Background: 
  Given the app is running
  And that I am on the "Sessions" tab

Scenario: Session detail view contains all the important information
  When I tap "Why NoSQL?"
  Then I should see "Why NoSQL?"
  And I should see "John Nunemaker"
  And I should see "Ordered List"
  And I should see "Developers often"
  When I scroll down
  Then I should see "John Nunemaker is passionate"

Scenario: Session detail is different for each talk
  When I tap "MongoDB Inside and Outside"
  Then I should see "MongoDB"
  And I should see "Kyle Banker"
  And I should see "10gen"
  And I should see "Where did MongoDB"

