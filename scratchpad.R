


# how much to abstract between the forecast or historical



## this is the old code we used to pull the historical weather data
get_temps = function(city) {
  coords <- geo(city = city, country = "Australia")

  base_url <- "https://archive-api.open-meteo.com/v1/archive"

  queries <- list(
    latitude = coords$lat,
    longitude = coords$long,
    start_date = min(datats$Week),
    end_date = max(datats$Week),
    daily = "temperature_2m_max",
    timezone = "Australia/Sydney")

  weather_data <- GET(modify_url(base_url, query = queries))

  output <- tibble(
    date = content(weather_data)$daily$time,
    temp = content(weather_data)$daily$temperature_2m_max
  )

  output %>% mutate(
    city = city,
    date = date %>% unlist() %>% as_date(),
    temp = temp %>% unlist()
  )
}


# default units (may be same for predicted and historical)

default_units <- c(
  temperature_unit = "celsius",
  windspeed_unit = "kmh",
  precipitation_unit = "mm"
)



timezone <- NULL

# don't add this to the url and will have local time

# could also default to local timezone

Sys.timezone()


# when start and end are necessary
if(!(.is.date(start) & .is.date(end))) stop("start and end dates must be in ISO-1806 format")







# decode necessary as the API treats ',' differently to '%2C'
outputURL <- URLdecode(httr::modify_url(base_url, query = queries))
response <- GET(outputURL)



#reporting on API call
paste0("pinged url: ",outputURL," with response:",response$status)

#duration
pl$times["total"]











# tibblify spec for parsed hourly i.e.
# content(pl, as = "parsed")$hourly

test_spec <- tspec_df(
  tib_chr_date("time"),
  tib_int("windspeed_10m"),
  tib_int("windspeed_80m")
)




# duplicate the function to just be a simple, `current_weather = true` call




## TODO
# current weather
# historical weather

# in utils, error handling for api errors



## BEFORE FINAL
# check performance of || and && calls
# error cases to handle when forecasting non-existant variables
# api error handling
# do we include the weather_variables() call?
# test coverage checks

