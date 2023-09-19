# canadaHCD 0.0.3

## User visible changes

* Data sets now return the Climate ID as variable `Climate ID`, not the Station
  ID. This is a change in the data files that can be downloaded from the
  Canadian Historical Climate Data server. Reported by @BastienFR #28

## New features

* `climate_id()` and `station_id()` functions that return the Climate ID
  (Station ID) for a supplied Station ID (Climate ID). These are helper
  functions to facilitate switching between the two identifier systems used by
  the HCD system.

* `update_station_data()` can update the station data stored within _canadaHCD_.
  Currently only downloads and formats the station data, but eventually will
  replace the stored data.

## Bug Fixes

* `hcd_hourly()` and related functions updated to read the new data structure
  for hourly data. Reported by @dankelly #29

* `collapse_hcd()` now explicitly sorts data by `Date` / `DateTime`. Reported
  by @ConorIA #26
