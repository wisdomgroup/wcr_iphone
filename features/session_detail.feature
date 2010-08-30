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
  When I tap "Metrics Based Refactoring: What To Do With Your Code Metrics"
  Then I should see "Metrics Based Refactoring"
  And I should see "9:00am - 9:45am"
  And I should see "Jake Scruggs"
  And I should see "Backstop Solutions"
  And I should see "Metric_fu makes it"
  When I scroll down
  Then I should see "Jake Scruggs is a former high school physics teacher"

Scenario: Session detail is different for each talk
  When I tap "Analyzing and Improving the Performance of your Rails Application"
  Then I should see "Analyzing"
  And I should see "John McCaffrey"
  And I should see "Independent Consultant"
  And I should see "Ruby is a great language"

