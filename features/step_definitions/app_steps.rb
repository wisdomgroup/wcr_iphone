Given /^that I am on the "([^"]*)" tab$/ do |tab|
  When %Q{I tap "#{tab}"}
end

Given /^the app is running/ do
  Given %Q{"WindyCityRails" from "WindyCityRails.xcodeproj" is loaded in the simulator}
end

When /^I wait (\d+) seconds$/ do |seconds|
  sleep(seconds.to_i)
end

