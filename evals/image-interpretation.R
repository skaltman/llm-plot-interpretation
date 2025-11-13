# Image Interpretation Evaluation
# Tests whether models accurately interpret pre-made data visualizations
# No code generation involved - pure visual interpretation

library(evaltools)
library(ellmer)
library(dplyr)

# Custom judge instructions for image interpretation
custom_instructions <- "Grade as Correct (C) if the response accurately describes the key
pattern or relationship shown in the visualization (e.g., positive correlation,
negative correlation, group differences, no relationship, curved pattern). The
response does not need to match the exact wording or include all details.
Grade as Incorrect (I) if the response misses the key pattern, describes
the opposite relationship, or makes incorrect claims about what's shown.

Reply with GRADE: $LETTER where LETTER is C or I.
First explain your reasoning, then end with GRADE: $LETTER."

# Run evaluation
image_sonnet <- run_eval(
  samples_dir = "samples/image-interpretation/",
  solver_chat = chat("anthropic/claude-sonnet-4-5-20250929"),
  system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
  scorer_instructions = custom_instructions,
  name = "image_interpretation",
  epochs = 3
)

image_sonnet |> 
  mutate(model = "sonnet") |> 
  write_rds("results/image-interpretation/sonnet.rds")

image_gpt <- run_eval(
  samples_dir = "samples/image-interpretation/",
  solver_chat = chat("openai/gpt-5"),
  system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
  scorer_instructions = custom_instructions,
  name = "image_interpretation",
  epochs = 3
)

image_gpt |> 
  mutate(model = "gpt-5") |> 
  write_rds("results/image-interpretation/gpt.rds")

image_gemini <- run_eval(
  samples_dir = "samples/image-interpretation/",
  solver_chat = chat("google_gemini/gemini-2.5-pro"),
  system_prompt = "You are a data analyst. Look at visualizations carefully and describe accurately what you observe.",
  scorer_instructions = custom_instructions,
  name = "image_interpretation",
  epochs = 3
)

image_gemini |> 
  mutate(model = "gemini-2.5-pro") |> 
  write_rds("results/image-interpretation/gemini.rds")

