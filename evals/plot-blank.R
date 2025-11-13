# Blank Plot Evaluation
# Tests whether models hallucinate patterns when shown blank visualizations

library(evaltools)
library(ellmer)
library(dplyr)
library(readr)

dir_out <- here::here("results/plot-blank/")

custom_instructions <- "Grade as Correct (C) if the response indicates the plot is blank, empty,
or has no data/visualization shown. The response does not need to mention
axis labels or other specific details. Grade as Incorrect (I) if the
response describes patterns, trends, or data that shouldn't be visible.

Reply with GRADE: $LETTER where LETTER is C or I.
First explain your reasoning, then end with GRADE: $LETTER."

system_prompt <- 
  "Accurately describe exactly what you observe in visualizations. Only call the `create_ggplot` tool once. 
  If you don't think your code or the tool executed correctly, just report that as well as what you see in the plot. 
  Do not provide any other information."

# make plots, etc. and async check

# Sonnet

# sonnet <- 
#   run_eval(
#     samples_dir = "samples/blank-plot",
#     solver_chat = list(`sonnet-4.5` = chat("anthropic/claude-sonnet-4-5-20250929")),
#     system_prompt = 
#       "",
#     scorer_instructions = custom_instructions,
#     name = "blank_plot",
#     epochs = 3
# )


# sonnet |> write_rds(fs::path(dir_out, "sonnet.rds"))

# cli::cli_inform("Sonnet finished.")

# GPT-5
gpt_5 <- 
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = list(`gpt-5` = chat("openai/gpt-5")),
    system_prompt = "Accurately describe exactly what you observe in visualizations.",
    scorer_instructions = custom_instructions,
    name = "plot_baseline",
    epochs = 3
)

gpt_5 |> write_rds(fs::path(dir_out, "gpt_5.rds"))

cli::cli_inform("GPT finished.")

# Gemini 2.5 Pro
gemini <- 
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = list(`gemini-2.5-pro` = chat("google_gemini/gemini-2.5-pro")),
    system_prompt = "Accurately describe exactly what you observe in visualizations.",
    scorer_instructions = custom_instructions,
    name = "plot_baseline",
    epochs = 3
)

gemini |> write_rds(fs::path(dir_out, "gemini.rds"))

cli::cli_inform("Gemini finished.")

# WITH SKEPTICISM PROMPT
# ==============================================================================

dir_out_skepticism <- here::here("results/plot-blank-skepticism/")

skepticism_prompt <- "Your primary job is to accurately interpret visualizations.

When evaluating a visualization, first analyze the plot as if you had no prior knowledge about the data and subject matter. Ignore the axis labels during this process, only describing the visual elements of the plot. Emit in <MEMO></MEMO> tags what you see during this process.

Afterwards, you may incorporate knowledge about the data or contextual knowledge, but make sure to accurately report and incorporate what you noted in the prior <MEMO></MEMO> tags."

# Sonnet

sonnet_skepticism <-
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = list(`sonnet-4.5` = chat("anthropic/claude-sonnet-4-5-20250929")),
    system_prompt = skepticism_prompt,
    scorer_instructions = custom_instructions,
    name = "blank_plot_skepticism",
    epochs = 3
)

sonnet_skepticism |> write_rds(fs::path(dir_out_skepticism, "sonnet.rds"))

cli::cli_inform("Sonnet (skepticism) finished.")

# GPT-5
gpt_5_skepticism <-
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = list(`gpt-5` = chat("openai/gpt-5")),
    system_prompt = skepticism_prompt,
    scorer_instructions = custom_instructions,
    name = "blank_plot_skepticism",
    epochs = 3
)

gpt_5_skepticism |> write_rds(fs::path(dir_out_skepticism, "gpt_5.rds"))

cli::cli_inform("GPT (skepticism) finished.")

# Gemini 2.5 Pro
gemini_skepticism <-
  run_eval(
    samples_dir = "samples/blank-plot",
    solver_chat = list(`gemini-2.5-pro` = chat("google_gemini/gemini-2.5-pro")),
    system_prompt = skepticism_prompt,
    scorer_instructions = custom_instructions,
    name = "blank_plot_skepticism",
    epochs = 3
)

gemini_skepticism |> write_rds(fs::path(dir_out_skepticism, "gemini.rds"))

cli::cli_inform("Gemini (skepticism) finished.")
