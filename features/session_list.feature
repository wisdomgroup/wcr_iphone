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
  Then I should see "Why NoSQL?"
  And I should see "John Nunemaker"
  And I should see "Ordered List"
  And I should see "MongoDB Inside and Outside"

Scenario: Can browse to detail view
  Given that I am on the "Sessions" tab
  When I tap "Why NoSQL?"
  Then I should see "Developers often"

