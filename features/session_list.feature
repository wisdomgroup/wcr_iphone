Feature: The Session List tab
  As a conference attendee,
  I want to look at the schedule to see what is next,
  So that I can pick what I want to attend,
  And know where to go,
  And know when to be there.

Background: 
  Given the app is running

Scenario: The session list has key information
  When I tap "Sessions"
  Then I should see "Metrics Based Refactoring"
  And I should see "Jake Scruggs"
  And I should see "Backstop Solutions Group"
  And I should see "Analyzing and Improving"

Scenario: Can browse to detail view
  Given that I am on the "Sessions" tab
  When I tap "Metrics Based Refactoring: What To Do With Your Code Metrics"
  Then I should see "Metric_fu makes it"

