# HealthKit Heart Rate Exporter #

Brad Larson

http://www.sunsetlakesoftware.com

[@bradlarson](http://twitter.com/bradlarson)

contact@sunsetlakesoftware.com

## Overview ##

This is a simple application I slapped together for the heart rate data that I captured [here](https://twitter.com/bradlarson/status/596142831363858433) from the Apple Watch. 

It accesses HealthKit (where the Apple Watch stores its measurements) and queries for the last 600 heart rate measurements. When it has those values, it logs them out to the console and to a CSV file called "heartratedata.csv". The application has iTunes file sharing enabled, so you can then grab this file from within iTunes. It's how I generated the graph in the above-linked tweet.

It's crude, and doesn't do much of anything beyond this, but enough people requested it that I'm dumping this on here. Have fun.

## License ##

Public domain. Don't really care what you do with this.