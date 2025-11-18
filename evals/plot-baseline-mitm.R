# Baseline plot reading eval with model-in-the-middle
#
# This runs the baseline eval where the model writes code, generates a plot,
# and interprets it - BUT with model-in-the-middle enabled so the model
# receives a text description of the plot instead of the image itself.

library(evaltools)
library(ellmer)
library(dplyr)
library(readr)

# Enable model-in-the-middle
Sys.setenv(ENABLE_MODEL_IN_MIDDLE = "true")

# Run baseline eval with model-in-the-middle for Sonnet
sonnet <- run_eval(
  samples_dir = "samples/pilot/testing",
  solver_chat = chat("anthropic/claude-sonnet-4-5-20250929"),
  system_prompt = NULL,
  scorer_instructions = readr::read_file("scorer-instructions/plot.md"),
  name = "plot_baseline_mitm_sonnet",
  epochs = 3,
  dir = "logs/plot-baseline-mitm"
)

write_rds(sonnet, "results/plot-baseline-mitm/sonnet.rds")
