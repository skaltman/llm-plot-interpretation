library(jsonlite)
library(dplyr)
library(bluffbench)

# Load old Gemini 2.5 Pro JSON
json_path <- here::here("data/gemini_2_5_pro.json")
log_data <- fromJSON(json_path, simplifyVector = FALSE)

# Extract samples
samples <- log_data$samples

# Process each sample
gemini_25_results <- tibble(
  id = sapply(samples, function(s) s$id),
  epoch = sapply(samples, function(s) s$epoch),
  target = sapply(samples, function(s) s$target),
  score = sapply(samples, function(s) {
    scores <- s$scores
    if (length(scores) > 0) {
      scores[[1]]$value
    } else {
      NA_character_
    }
  })
) |>
  # Join with bluff_dataset to get type
  left_join(
    bluff_dataset[, c("id", "type")],
    by = "id"
  ) |>
  mutate(model = "Gemini 2.5 Pro")

cat("Summary:\n")
print(table(gemini_25_results$type, gemini_25_results$score))

cat("\nAccuracy by type:\n")
gemini_25_results |>
  group_by(type) |>
  summarise(
    n = n(),
    accuracy = mean(score == "C") * 100
  ) |>
  print()

# Save results
saveRDS(gemini_25_results, here::here("data/gemini_2_5_pro.rds"))
