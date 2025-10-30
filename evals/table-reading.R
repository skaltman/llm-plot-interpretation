# Table Reading Evaluation
# Tests whether models accurately interpret data patterns when analyzing with dplyr

library(evaltools)
library(ellmer)
library(dplyr)

# Custom judge instructions for table reading evaluation
custom_instructions <- "Grade as Correct (C) if the response accurately describes the key
pattern or relationship in the data (e.g., positive correlation, group differences,
increasing trend). The response does not need to match the exact wording or include
all details. Grade as Incorrect (I) if the response misses the key pattern, describes
the opposite relationship, or makes incorrect claims about the data.

Reply with GRADE: $LETTER where LETTER is C or I.
First explain your reasoning, then end with GRADE: $LETTER."

# Full evaluation with 15 samples
results <- run_eval(
  samples_dir = "samples/table-reading/",
  solver_chat =
    list(
      "claude-sonnet-4-5" = chat_anthropic(model = "claude-sonnet-4-5-20250929"),
      "gpt-5" = chat_openai(model = "gpt-5"),
      "gemini-2-5" = chat_google_gemini(model = "gemini-2.5-pro")
    ),
  system_prompt = "You are a data analyst. Use the tools provided to analyze data and describe what you observe.",
  scorer_instructions = custom_instructions,
  name = "table_reading_full",
  view = FALSE
)
