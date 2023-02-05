
# check if x is of type c(lat,long)
.is_coords <- function(x){
  if(length(x) == 2 && is.numeric(x)) {
    abs(x[1]) <= 90 && abs(x[2]) <= 180
  }
  else FALSE
}

# generic helper to return co-ords from co-ords or string, or error out
.coords_generic <- function(x){
  if(.is_coords(x)){
    return(x)
  }
  else if(is.character(x)) {
    dt <- geocode(x)
    return(c(dt$latitude,dt$longitude))
  }
  else {
    stop("location not provided as co-ordinate pair or string")
  }
}

# validate date reads as ISO 8601 (e.g. "2020-12-30")
.is.date <- function(d) {
  tryCatch(!is.na(as.Date(d, format = "%Y-%m-%d")),
           error = function(e){FALSE})
}
