# canadaHCD 0.0.3

## User visible changes

* Data sets now return the Climate ID as variable `Climate ID`, not the Station
  ID. This is a change in the data files that can be downloaded from the
  Canadian Historical Climate Data server. Reported by @BastienFR #28

## Bug Fixes

* `hcd_hourly()` and related functions updated to read the new data structure
  for hourly data. Reported by @dankelly #29
