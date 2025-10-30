# Tool factory for creating plots
# This function creates an ellmer tool that can execute R code to create plots

tool_create_plot <- function(env, name = "create_plot") {
  ellmer::tool(
    function(code) {
      # Execute code in the provided environment
      result <- tryCatch(
        eval(parse(text = code), envir = env),
        error = function(e) {
          return(ellmer::ContentToolResult(error = conditionMessage(e)))
        }
      )

      if (inherits(result, "ContentToolResult")) {
        return(result)
      }

      # Check if result is a ggplot
      if (inherits(result, "ggplot")) {
        temp_file <- tempfile(fileext = ".png")
        ggplot2::ggsave(temp_file, plot = result, width = 7, height = 5)
        return(ellmer::content_image_file(temp_file))
      }

      # Handle non-ggplot results
      result_type <- if (is.null(result)) "NULL" else paste(class(result), collapse = ", ")
      ellmer::ContentToolResult(
        error = paste0("Code did not return a ggplot. Got: ", result_type)
      )
    },
    name = name,
    description = "Create a ggplot visualization from R code",
    arguments = list(
      code = ellmer::type_string(
        "R code that begins with library(ggplot2) and creates a ggplot object"
      )
    )
  )
}
