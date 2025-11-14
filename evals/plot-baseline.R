# Baseline plot reading eval

library(evaltools)
library(ellmer)
library(dplyr)
library(readr)

vitals::vitals_log_dir_set("logs/plot-baseline")

models <- list(
  sonnet = chat("anthropic/claude-sonnet-4-5-20250929"),
  gpt_5 = chat("openai/gpt-5"),
  gemini = chat("google_gemini/gemini-2.5-pro")
)

run_baseline <- function(file_name, 
                          model_chat, 
                          system_prompt, 
                          output_dir = "results/plot-baseline", 
                          eval_name = glue::glue("plot_baseline_{file_name}")) {
  result <- run_eval(
    samples_dir = "samples/baseline",
    solver_chat = model_chat,
    system_prompt = system_prompt,
    scorer_instructions = readr::read_file("scorer-instructions/plot.md"),
    name = eval_name,
    epochs = 3
  )

  write_rds(result, file.path(output_dir, paste0(file_name, ".rds")))
}

# ----------------------------------------------------------------------------------------------------------

# Baseline, standard prompt

# sonnet <- 
#   run_baseline(
#     "sonnet", 
#     models[1], 
#     system_prompt = "Accurately describe exactly what you observe in visualizations.",
#     output_dir = "results/plot-baseline"
#   )

# gpt_5 <-
#   run_baseline(
#     "gpt-5",
#     models[2],
#     system_prompt = "Accurately describe exactly what you observe in visualizations.",
#     output_dir = "results/plot-baseline"
#   )

# gemini <-
#   run_baseline(
#     "gemini",
#     models[3],
#     system_prompt = "Accurately describe exactly what you observe in visualizations.",
#     output_dir = "results/plot-baseline"
#   )

# With memo prompt
# ==============================================================================

# prompt <- readr::read_file("prompts/prompt-memo.md")
# sonnet <- 
#   run_baseline(
#     file_name = "sonnet_prompt_memo", 
#     models[1], 
#     system_prompt = prompt,
#     output_dir = "results/plot-baseline"
#   )


# With thinking and memo prompt
# ================================================================================

prompt <- readr::read_file("prompts/prompt-thinking.md")

sonnet <-
  run_baseline(
    file_name = "sonnet_thinking",
    model_chat =
      chat(
        "anthropic/claude-sonnet-4-5-20250929",
        api_args = list(
          thinking = list(type = "enabled", budget_tokens = 5000),
          max_tokens = 8192
        )
      ),
    system_prompt = prompt,
    output_dir = "results/plot-baseline/thinking"
  )