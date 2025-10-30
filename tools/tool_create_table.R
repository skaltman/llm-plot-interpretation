# Tool factory for creating tables/data frames
# This function creates an ellmer tool that executes R code to analyze data with dplyr

run_r_code <- function(code, env) {
  suppressWarnings(eval(parse(text = code), envir = env))
}

run_table_code <- function(code, env) {
  result <- tryCatch(
    run_r_code(code, env),
    error = function(e) e
  )

  if (inherits(result, "error")) {
    return(ellmer::ContentToolResult(error = conditionMessage(result)))
  }

  # Check if result is a data frame or tibble
  if (is.data.frame(result)) {
    # Return as JSON
    return(jsonlite::toJSON(result, pretty = TRUE, auto_unbox = FALSE))
  }

  # Handle non-dataframe results
  result_type <- if (is.null(result)) {
    "NULL"
  } else {
    paste0(class(result), collapse = ", ")
  }

  ellmer::ContentToolResult(
    error = paste0("Code did not return a data frame or tibble. Got: ", result_type)
  )
}

tool_create_table <- function(env, name = "create_table") {
  ellmer::tool(
    function(code) run_table_code(code, env),
    name = name,
    description = "Analyze data using dplyr and other R functions. Returns the result of your analysis as a table.",
    arguments = list(
      code = ellmer::type_string(
        "R code that begins with library(dplyr) and uses dplyr functions to analyze data. The code must return a data frame or tibble. This code runs in the global environment--do _not_ run any code via this tool that could cause side effects in the global environment such as calling `data()` on an object."
      )
    )
  )
}
