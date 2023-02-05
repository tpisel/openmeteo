#' @title blsR: Retrieve Data From the U.S. Bureau Of Labor Statistics API // look at that file for reference, no code in it!
#'
#' @description
#' `blsR` provides functions for retrieving and processing data from the BLS API.
#' The functions are divided into 5 categories: query generators, query requests,
#' the spanning functions, result processors, and the user-friendly simplified
#' interface.
#'
#' @section API Key and Definition:
#'
#' The API key is an optional argument, but it is recommended you register for
#' an API key and use it. Requests without a key are limited to 10 years of data
#' per request, 25 series per query, and 25 queries per day. You can register at:
#'  <https://data.bls.gov/registrationEngine/>
#'
#' This implementation was based on the signatures available at:
#' <https://www.bls.gov/developers/api_signature_v2.htm>
#'
#' The B.L.S. Frequently asked questions is available at:
#'  <https://www.bls.gov/developers/api_faqs.htm>
#'
#' @section General Workflow:
#'
#' This package was designed with a three-step workflow in mind:
#'  * Identify which data you would like to retrieve and create a query.
#'  * Make an http request to execute a query ([`bls_request()`])
#'  * Modify the response data to fit the user workflow
#'
#' You can customize this workflow by creating your own query objects which
#' consist of a target URL and an optional payload as documented in the API Spec.
#' You may also want to create a custom results processor to shape the data to
#' suit individual needs and wrap those into a single call like
#' [`get_series_table()`] does.
#'
#' @section Query Generators:
#'
#' The query generators return a list suitable for passing to [`bls_request()`].
#' Most users should never need to access these functions directly but they are
#' made available for advanced users and user-extensions.
#'
#' * [`query_series()`] - Create a query for a single time series
#' * [`query_n_series()`] - Create a query to retrieve one or more time series
#'  and their catalog data
#' * [`query_popular_series()`] - Create a query to retrieve popular series
#' * [`query_all_surveys()`] - Create a query to retrieve all surveys
#' * [`query_survey_info()`] - Create a query to retrieve information about a
#'  survey
#' * [`query_latest_observation()`] - Create a Query to retrieve the latest
#' observation for a time series
#'
#' @section Query Requests:
#'
#' The query-requester functions will execute the query by making the API request
#' and returning a minimally-processed response. These are likely to be the
#' most suitable functions to use for users who want to access the raw results.
#'
#' * [`bls_request()`] - Execute a query and return the unprocessed results
#' * [`get_series()`] - Create and execute query for a single time series
#' * [`get_n_series()`] - Create and execute a query to retrieve one or more
#' time series and their catalog data
#' * [`get_popular_series()`] - Create and execute a query to retrieve popular
#' series
#' * [`get_all_surveys()`] - Create and execute a query to retrieve all surveys
#' * [`get_survey_info()`] - Create and execute a query to retrieve information
#' about a survey
#' * [`get_latest_observation()`] - Create and execute a query to retrieve the
#' latest observation for a time series
#'
#' @section Spanning functions:
#'
#' The spanning functions implement the behavior around breaking up a request
#' that exceeds the API limits into multiple requests within the API limits and
#' then reducing the results. Currently, spanning is only supported across time
#' but there is plans to also support spanning across the number of series
#' requested. These functions are low-level internal implementations and most
#' users should never need to interact with them directly.
#'
#' * [`span_series_request()`] - Breaks up a request into multiple queries,
#' executes the queries, and returns the reduced results
#' * [`span_request_queries()`] - Breaks up a request into a list of queries
#' * [`reduce_spanned_responses()`] - Reduces a list of responses into one
#' series list
#'
#' @section Result Processors:
#'
#' The result-processor functions will transform the raw API response data
#' structures into data structures more likely to be suitable for modern user
#' workflows. The functions generally take as input the values returned by the
#' query-requester functions and make transform the data to different formats
#' or modify the output of another result-processor function.
#'
#' * [`data_as_table()`] - Flatten the data list into a table
#' * [`merge_tables()`] - Merge multiple tables by period
#' * [`tidy_periods()`] - Transform periods to a more useful format
#' * [`data_as_tidy_table()`] - Flatten the data list and transform period data
#' * [`merge_tidy_tables()`] - Merge multiple tables with tidy period data
#' * [`tidy_table_as_zoo()`] - Turn a table produced by `data_as_tidy_table`,
#' `merge_tidy_tables`, or `tidy_periods` as a `zoo` object, which can be
#' further turned into an `xts` object
#'
#' @section Simplified Interface:
#'
#' These functions simplify the query generation, execution, and response
#' processing into a single function call, including extended request periods
#' that have to be broken down into multiple API requests. For most common use
#' cases these are likely to be the only functions needed.
#'
#' * [`get_series_table()`] - Request one series and return a data table
#' * [`get_series_tables()`] - Request series and return list of data tables
#' * [`get_n_series_table()`] - Request series and return one table of values
#'
#' @docType package
#' @name blsR
NULL
#>  NULL
