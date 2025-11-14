# Bluffbench eval using native bluffbench package

# With memo prompt and thinking --------------------

library(bluffbench)

vitals::vitals_log_dir_set("./logs/bluffbench")

# Read memo prompt
prompt <- readr::read_file("prompts/prompt-thinking.md")

mocked_samples <- which(bluff_dataset$type == "mocked")

tsk <- bluff_task(epochs = 3, samples = mocked_samples)

# claude 4.5 sonnet -------------------------------------------------
tsk_claude_4_5_sonnet_prompt_thinking <- tsk$clone()
tsk_claude_4_5_sonnet_prompt_thinking$eval(
  solver_chat = ellmer::chat_anthropic(
    model = "claude-sonnet-4-5-20250929",
    system_prompt = prompt,
    api_args = list(
          thinking = list(type = "enabled", budget_tokens = 5000),
          max_tokens = 8192
    )
  )
)

saveRDS(
  tsk_claude_4_5_sonnet_prompt_thinking, 
  file = "results/bluffbench-prompt-memo/tsk_claude_4_5_sonnet_thinking_mocked.rds"
)

cli::cli_inform("Sonnet finished.")

# gemini 2.5 pro ----------------------------------------------------
tsk_gemini_2_5_pro_prompt_memo <- tsk$clone()
tsk_gemini_2_5_pro_prompt_memo$eval(
  solver_chat = ellmer::chat_google_gemini(
    model = "gemini-2.5-pro",
    system_prompt = prompt
  )
)

saveRDS(tsk_gemini_2_5_pro_prompt_memo, file = "results/bluffbench-prompt-memo/tsk_gemini_2_5_pro_thinking.rds")

cli::cli_inform("Gemini finished.")

# gpt-5 -------------------------------------------------------------
tsk_gpt_5_prompt_memo <- tsk$clone()
tsk_gpt_5_prompt_memo$eval(
  solver_chat = ellmer::chat_openai(
    model = "gpt-5",
    system_prompt = prompt
  )
)

saveRDS(tsk_gpt_5_prompt_memo, file = "results/bluffbench-prompt-memo/tsk_gpt_5.rds")

cli::cli_inform("GPT-5 finished.")

# ==============================================================================
# Process results into usable format
# ==============================================================================

library(tidyverse)

# Load task objects from results directory
task_files <- list.files("results/bluffbench-prompt-memo", pattern = "\\.rds$", full.names = TRUE)

tasks <- list()
for (task_file in task_files) {
  task_name <- gsub("tsk_|\\.rds", "", basename(task_file))
  tasks[[task_name]] <- readRDS(task_file)
}

# Combine using vitals
bluffbench_results_raw <- vitals::vitals_bind(!!!tasks)

# Process to match your other results format
bluffbench_results <-
  bluffbench_results_raw |> 
  rename(model = task) |> 
  mutate(type = purrr::map_chr(metadata, ~ .x$type)) |> 
  write_rds("results/bluffbench-prompt-memo/sonnet.rds")
