Given /^that I am on the "([^"]*)" tab$/ do |tab|
  When %Q{I tap "#{tab}"}
end

Given /^the app is running/ do
  Given %Q{"WindyCityDB" from "WindyCityDB.xcodeproj" is loaded in the simulator}
end

