run_ggplot_code <- function(code, env, solver_chat = NULL, enable_mitm = FALSE) {
  result <- tryCatch(
    run_r_code(code, env),
    error = function(e) e
  )

  if (inherits(result, "error")) {
    return(ellmer::ContentToolResult(error = conditionMessage(result)))
  }

  if (inherits(result, "ggplot")) {
    temp_file <- tempfile(fileext = ".png")
    ggplot2::ggsave(temp_file, plot = result, width = 7, height = 5, dpi = 150)

    # Use model-in-the-middle if enabled and solver_chat is provided
    if (enable_mitm && !is.null(solver_chat)) {
      return(evaltools::interpret_plot(temp_file, solver_chat))
    }

    return(ellmer::content_image_file(temp_file))
  }

  result_type <- if (is.null(result)) {
    "NULL"
  } else {
    paste0(class(result), collapse = ", ")
  }

  ellmer::ContentToolResult(
    error = paste0("Code did not return a ggplot object. Got: ", result_type)
  )
}

run_r_code <- function(code, env) {
  suppressWarnings(eval(parse(text = code), envir = env))
}

#' ggplot visualization tool factory
#'
#' Creates an ellmer tool that evaluates R code to create ggplot visualizations
#' in a specified environment. The tool accepts R code that returns a ggplot
#' object. This intentionally presents a narrow interface to discourage models
#' from exploring data with arbitrary code.
#'
#' Optionally supports "model-in-the-middle" interpretation where a fresh chat
#' context interprets the plot and returns a text description instead of the
#' image itself. This helps isolate visual interpretation from contextual priors.
#'
#' @param env The environment in which to evaluate the code.
#' @param name The name for the tool (default: "create_ggplot")
#' @param solver_chat Optional ellmer Chat object for model-in-the-middle
#'   interpretation. If NULL (default), images are returned directly.
#' @param enable_mitm Logical indicating whether to use model-in-the-middle
#'   interpretation. Only takes effect if solver_chat is provided. Can be
#'   controlled via ENABLE_MODEL_IN_MIDDLE environment variable (default: FALSE)
#'
#' @export
tool_create_plot <- function(env, name = "create_ggplot", solver_chat = NULL,
                              enable_mitm = NULL) {
  # Check environment variable if enable_mitm not explicitly set
  if (is.null(enable_mitm)) {
    enable_mitm <- identical(Sys.getenv("ENABLE_MODEL_IN_MIDDLE"), "true")
  }

  ellmer::tool(
    function(code) run_ggplot_code(code, env, solver_chat, enable_mitm),
    name = name,
    description = "Create a ggplot visualization from the provided R code.",
    arguments = list(
      code = ellmer::type_string(
        "R code that begins with library(ggplot2) and then a call to the `ggplot()` function. This code runs in the global environment--do _not_ run any code via this tool that could cause side effects in the global environment such as calling `data()` on an object."
      )
    )
  )
}
