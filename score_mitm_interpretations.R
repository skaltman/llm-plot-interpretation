library(bluffbench)
library(jsonlite)
library(ellmer)
library(purrr)
library(tibble)

file_out <- here::here("data/mitm-scores.rds")

# Load MITM log
log_path <- "/Users/saraa/GitHub/rstudio/bluffbench/inst/run/logs/mitm/2026-01-15T18-49-52-08-00_bluffbench-claude-opus-4-5-20251101-217c644b6020290b34bb0e_bluffbench_claude-opus-4-5-20251101_217c644b6020290b34bb0e.json"

log_data <- jsonlite::fromJSON(log_path, simplifyVector = FALSE)

# Extract MITM plot interpretation
extract_mitm_interpretation <- function(sample) {
  for (msg in sample$messages) {
    if (!is.null(msg[["function"]]) && msg[["function"]] == "create_ggplot") {
      return(msg$content)
    }
  }
  NA_character_
}

mitm_results <- tibble(
  id = map_chr(log_data$samples, "id"),
  target = map_chr(log_data$samples, "target"),
  input = map_chr(log_data$samples, "input"),
  mitm_interpretation = map_chr(log_data$samples, extract_mitm_interpretation)
)

samples_to_score <- which(!is.na(mitm_results$mitm_interpretation))

prompts <- map_chr(samples_to_score, function(i) {
  bluffbench:::bluff_format_prompt(
    input = mitm_results$input[i],
    output = mitm_results$mitm_interpretation[i],
    target = mitm_results$target[i]
  )
})

# Score mitm
scorer_chat <- chat_anthropic(model = "claude-sonnet-4-5-20250929")
responses <- parallel_chat(scorer_chat, as.list(prompts))

grades <- map_chr(responses, function(r) {
  bluffbench:::bluff_extract_grade(r$last_turn()@text)
})

mitm_results$mitm_grade <- NA_character_
mitm_results$mitm_grade[samples_to_score] <- grades

# Join with bluff_dataset to get type
mitm_results <- mitm_results |>
  dplyr::left_join(
    bluff_dataset[, c("id", "type")],
    by = "id"
  )

mitm_results |> write_rds(file_out)
