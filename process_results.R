library(dplyr)
library(purrr)
library(stringr)
library(readr)

logs_dir <- "../../rstudio/bluffbench/inst/run/logs"

# Define conditions
conditions <- c(
  "baseline-clarify-true" = "baseline",
  "baseline-image-only" = "image_only",
  "memo" = "memo",
  "extended-thinking" = "thinking",
  "mitm" = "mitm"
)

# Function to load and process an RDA file
process_rda <- function(file_path, condition) {
  env <- new.env()
  load(file_path, envir = env)
  obj_name <- ls(env)[1]
  task <- env[[obj_name]]

  # Extract model name from file
  model_name <- str_extract(basename(file_path), "tsk_(.+)\\.rda$", group = 1)

  # Get samples
  samples <- task$get_samples()

  samples |>
    select(id, target, type, epoch, result, score) |>
    mutate(
      condition = condition,
      model = model_name
    )
}

# Process all RDA files from logs
rda_data <- map_dfr(names(conditions), function(cond_dir) {
  cond_label <- conditions[cond_dir]
  dir_path <- file.path(logs_dir, cond_dir)
  rda_files <- list.files(dir_path, pattern = "\\.rda$", full.names = TRUE)

  cat("Processing", cond_dir, "- found", length(rda_files), "files\n")

  map_dfr(rda_files, function(f) {
    cat("  Loading:", basename(f), "\n")
    process_rda(f, cond_label)
  })
})

# Load mitm-scores.rds (3 rows per id, so group and assign epochs)
mitm_scores <- readRDS("data/mitm-scores.rds") |>
  group_by(id) |>
  mutate(epoch = row_number()) |>
  ungroup() |>
  transmute(
    id = id,
    target = target,
    type = type,
    epoch = epoch,
    result = mitm_interpretation,
    score = mitm_grade,
    condition = "mitm_human_scored",
    model = "claude_4_5_sonnet"
  )

# Combine all data
all_results <- bind_rows(rda_data, mitm_scores)

# Save the combined dataset
all_results |>
  write_rds("data/all_results.rds")
