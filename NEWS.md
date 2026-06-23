# openmeteo 0.2.5.9000

* Added support for querying commercial customer endpoints with a paid Open-Meteo subscription by setting the `OPENMETEO_API_KEY` environment variable.
* Updated package requirements to depend on R \>= 4.1.0.
* Updated `README.md` to include information about how to access the commercial endpoints.

# openmeteo 0.2.5

* New `ensemble_models()` function for the Open-Meteo Ensemble Models API (#10, thanks @jacobmmears)
* `air_quality()` now supports the `current` argument for latest-value readings, and validates that `hourly`/`current` are character vectors (#11)
* Added `URL` and `BugReports` fields to DESCRIPTION (#12)
* Fixed `weather_variables()` after Open-Meteo moved their OpenAPI specs to a new path
* Dropped the `tibblify` dependency (this was the reason for the previous CRAN archival); `geocode()` now assembles its result tibble using `tibble`/`dplyr` directly

# openmeteo 0.2.4

* Ability to raw climate model data without calibration with ERA5 (from @lochbika)

# openmeteo 0.2.3

* Fix for handling different weather models

# openmeteo 0.2.2

* Minor documentation changes

# openmeteo 0.2.1

* Added support for additional APIs:
  * Marine Weather
  * Climate Forecasts
  * Floods
  * Air Quality

# openmeteo 0.1.1

* First public release.
