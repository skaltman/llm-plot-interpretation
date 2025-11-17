# Blank Plot Evaluation
# Tests whether models hallucinate patterns when shown blank visualizations

library(evaltools)
library(ellmer)
library(dplyr)
library(readr)

vitals::vitals_log_dir_set("logs/plot-blank")

models <- list(
  sonnet = chat("anthropic/claude-sonnet-4-5-20250929"),
  gpt_5 = chat("openai/gpt-5"),
  gemini = chat("google_gemini/gemini-2.5-pro")
)

run_plot_blank <- function(
  file_name,
  model_chat,
  system_prompt,
  output_dir = "results/plot-blank",
  eval_name = glue::glue("plot_blank_{file_name}")
) {
  result <- run_eval(
    samples_dir = "samples/plot-blank",
    solver_chat = model_chat,
    system_prompt = system_prompt,
    scorer_instructions = readr::read_file("scorer-instructions/plot-blank.md"),
    name = eval_name,
    epochs = 3
  )

  write_rds(result, file.path(output_dir, paste0(file_name, ".rds")))
}

# Blank plot, standard prompt --------------------------------------------

sonnet <-
  run_plot_blank(
    "sonnet",
    models[1],
    system_prompt = readr::read_file("prompts/prompt-plot-blank.md")
  )


# Thinking

sonnet_thinking <-
  run_plot_blank(
    "sonnet_thinking",
    model_chat = list(
      sonnet = chat(
        "anthropic/claude-sonnet-4-5-20250929",
        api_args = list(
          thinking = list(type = "enabled", budget_tokens = 5000),
          max_tokens = 8192
        )
      )
    ),
    system_prompt = readr::read_file("prompts/prompt-plot-blank.md")
  )
