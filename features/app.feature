Feature: test iCuke
Background: 
  Given "WindyCityDB" from "WindyCityDB.xcodeproj" is loaded in the simulator

Scenario: When the app first opens
  Then I should see "Sessions"
