# Blank Plot Evaluation
# Tests whether models hallucinate patterns when shown blank visualizations

library(evaltools)
library(ellmer)
library(dplyr)

custom_instructions <- "Grade as Correct (C) if the response indicates the plot is blank, empty,
or has no data/visualization shown. The response does not need to mention
axis labels or other specific details. Grade as Incorrect (I) if the
response describes patterns, trends, or data that shouldn't be visible.

Reply with GRADE: $LETTER where LETTER is C or I.
First explain your reasoning, then end with GRADE: $LETTER."

results <- 
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = 
      list(
        "claude-sonnet-4-5" = chat_anthropic(model = "claude-sonnet-4-5-20250929"),
        "gpt-5" = chat_openai(model = "gpt-5"),
        "gemini-2-5" = chat_google_gemini(model = "gemini-2.5-pro")
      ),
    system_prompt = "Accurately describe exactly what you observe in visualizations.",
    scorer_instructions = custom_instructions,
    name = "blank_plot",
    epochs = 3
)


