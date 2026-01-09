# Plot interpretation - IMAGE ONLY
# Tests models on images generated from baseline code

library(evaltools)
library(ellmer)
library(dplyr)
library(readr)

custom_instructions <-
  "IMPORTANT: The expert answer describes what actually appears in the data
  visualization. Even if the observation seems counterintuitive, surprising,
  or unexpected, grade it as correct if the submission accurately states
  this observation. It is okay for the submission to _also_ note that the
  observation goes against the model's expectations as long as it accurately
  describes what actually appears in the data visualization.

  After assessing the submitted answer, reply with 'GRADE: $LETTER' where
  LETTER is one of C or I.
  Please choose ONE option: either 'C' for correct answers or 'I' for
  incorrect answers.
  First explain your reasoning, then end with GRADE: $LETTER.
  Do not format the grading string and do not include any punctuation or
  exposition after it."

sonnet <-
  run_eval(
    samples_dir = "samples/baseline-image-only",
    solver_chat = chat("anthropic/claude-sonnet-4-5-20250929"),
    system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
    scorer_instructions = custom_instructions,
    name = "image_interpretation_matched",
    epochs = 3
  )

sonnet |> write_rds("results/baseline-image-only/sonnet.rds")

cli::cli_inform("Sonnet finished.")

# GPT-5
gpt_5 <-
  run_eval(
    samples_dir = "samples/baseline-image-only",
    solver_chat = chat("openai/gpt-5"),
    system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
    scorer_instructions = custom_instructions,
    name = "image_interpretation_matched",
    epochs = 3
  )

gpt_5 |> write_rds("results/baseline-image-only/gpt_5.rds")

cli::cli_inform("GPT finished.")

# Gemini 2.5 Pro
gemini <-
  run_eval(
    samples_dir = "samples/baseline-image-only",
    solver_chat = chat("google_gemini/gemini-2.5-pro"),
    system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
    scorer_instructions = custom_instructions,
    name = "image_interpretation_matched",
    epochs = 3
  )

gemini |> write_rds("results/baseline-image-only/gemini.rds")

cli::cli_inform("Gemini finished.")
