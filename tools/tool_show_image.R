#' Image display tool factory
#'
#' Creates an ellmer tool that returns a pre-made image file for the model to
#' interpret. This tool does NOT execute any code - it simply displays an
#' existing image. Useful for testing pure visual interpretation without
#' confounding factors of code generation.
#'
#' The image_path should be defined in the environment (via input.setup in YAML).
#'
#' @param env Environment containing image_path variable
#' @param name The name for the tool (default: "show_plot")
#'
#' @export
tool_show_image <- function(env, name = "show_plot") {
  # Get image_path from environment
  if (!exists("image_path", envir = env)) {
    stop("image_path variable must be defined in the environment (set in input.setup)")
  }

  image_path <- get("image_path", envir = env)

  # Validate image exists
  if (!file.exists(image_path)) {
    stop("Image file not found: ", image_path)
  }

  ellmer::tool(
    function() {
      # Simply return the pre-made image
      ellmer::content_image_file(image_path, resize = "high")
    },
    name = name,
    description = "Display the data visualization for you to interpret. Call this tool to see the plot.",
    arguments = list()  # No arguments needed from the model - image is pre-determined
  )
}
