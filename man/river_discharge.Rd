% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/river_discharge.R
\name{river_discharge}
\alias{river_discharge}
\title{Retrieve river discharge data from the Open-Meteo API}
\usage{
river_discharge(location, start = NULL, end = NULL, daily = NULL, model = NULL)
}
\arguments{
\item{location}{Required. The location for which data will be retrieved.
Supplied as either a \code{c(latitude,longitude)} WGS84 coordinate pair or a
place name string (with co-ordinates obtained via \code{\link[=geocode]{geocode()}}).}

\item{start, end}{Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
dates are supplied, data for the next 3 months will be provided by default.}

\item{daily}{Required. A weather variable accepted by the API, or list
thereof. See details below.}

\item{model}{Supply to specify a model for forecasted values (defaults to
latest GloFAS model).}
}
\value{
Requested river discharge data (m³/s) for the given location and time
period, as a tidy tibble.
}
\description{
\code{river_discharge()} calls the Open-Meteo Global Flood API to obtain simulated
river discharge from the nearest river. Data obtained from the Global Flood
Awareness System (GloFAS). Forecasts and historical data is available.

Refer to the API documentation at: \url{https://open-meteo.com/en/docs/flood-api}
}
\details{
You will need to specify at least one river discharge variable to retrieve
data for. These variables are sampled or aggregated at daily intervals, and
can be supplied as a list to request multiple variables over the same time
period.

Example daily forecast variables include:\tabular{ll}{
   \strong{Variable} \tab \strong{Description} \cr
   \code{river_discharge} \tab Daily river discharge rate in m³/s \cr
   \code{river_discharge_median} \tab Median over ensemble members (forecasts only) \cr
   \code{river_discharge_max} \tab Maximum over ensemble members (forecasts only) \cr
}


Full documentation for the forecast API is available at:
\url{https://open-meteo.com/en/docs/flood-api}
}
\examples{
\donttest{
# obtain historical flood data for Brisbane
river_discharge("Brisbane",
  "2022-01-01", "2022-02-01",
  daily = "river_discharge"
)
}
}
