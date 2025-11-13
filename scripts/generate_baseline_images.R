#!/usr/bin/env Rscript
# Generate images from baseline sample data
# Setup code creates the data, you code the plots

library(ggplot2)
library(tibble)

# Create output directory
dir.create("sample-images/baseline", showWarnings = FALSE, recursive = TRUE)

# ============================================================================
# baseline_positive_correlation
# ============================================================================
# Prompt: Can you plot the df dataset with the `x` column on the x axis and the y column on
# the y-axis and then briefly tell me what relationship you observe? df already exists in
# your environment.

set.seed(15)
df <- tibble::tibble(
  x = 1:30,
  y = 2 * (1:30) + rnorm(30, 0, 5)
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point()

ggsave("sample-images/baseline/positive_correlation.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_negative_correlation
# ============================================================================
# Prompt: plot the `df` dataset as a scatterplot with the `time` column on the x-axis and the `measure` column on the y-axis.
# the `df` dataset already exists in your environment. briefly tell me what relationship you see in the plot.

set.seed(42)
df <- tibble::tibble(
  time = 1:35,
  measure = 85 - 1.8 * (1:35) + rnorm(35, 0, 6)
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = time, y = measure)) +
  geom_point()

ggsave("sample-images/baseline/negative_correlation.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_no_correlation
# ============================================================================
# Prompt: scatterplot the df dataset with x on the x axis and y on the y axis and succinctly tell
# me what relationship you see. df already exists in your environment.

set.seed(15)
df <- tibble::tibble(
  x = 1:30,
  y = rnorm(30, 50, 10)
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point()

ggsave("sample-images/baseline/no_correlation.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_quadratic
# ============================================================================
# Prompt: Plot as a scatterplot the df dataset with the `x` column on the x-axis and the `y` column
# on the `y-axis` then succinctly tell me what relationship you see. df already
# exists for you. you do not need to create it.

set.seed(15)
df <- tibble::tibble(
  x = seq(-5, 5, length.out = 30),
  y = (seq(-5, 5, length.out = 30))^2 + rnorm(30, 0, 3)
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point()

ggsave("sample-images/baseline/quadratic.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_categorical_difference
# ============================================================================
# Prompt: make a boxplot or something like that using df
# put `group` column on the x-axis and the `measure` column on the y-axis, and
# concisely tell me what patterns you observe.

set.seed(15)
df <- tibble::tibble(
  group = rep(c("A", "B", "C"), each = 10),
  measure = c(rnorm(10, 20, 3), rnorm(10, 40, 3), rnorm(10, 60, 3))
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = group, y = measure)) +
  geom_boxplot()

ggsave("sample-images/baseline/categorical_difference.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_categorical_no_difference
# ============================================================================
# Prompt: Create a boxplot using the df dataset. it already exists for you in your environment.
# put `state` on the x axis and the `value` column on the y -- then briefly tell me what patterns you see.

set.seed(400)
df <- tibble::tibble(
  state = rep(c("Alpha", "Beta", "Gamma"), each = 10),
  value =
    c(
      c(1:9, 15),
      c(1:9, 20),
      c(1:9, 16)
    )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = state, y = value)) +
  geom_boxplot()

ggsave("sample-images/baseline/categorical_no_difference.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_bimodal_clusters
# ============================================================================
# Prompt: create a scatterplot with the df dataset, which already exists in your environment.
# put `x_coord` on the x-axis and `y_coord` on the y-axis. briefly describe what you observe.

set.seed(567)
df <- tibble::tibble(
  x_coord = c(
    rnorm(40, 20, 3),   # Cluster 1: centered at 20
    rnorm(40, 45, 3)    # Cluster 2: centered at 45
  ),
  y_coord = c(
    rnorm(40, 30, 4),   # Cluster 1: centered at 30
    rnorm(40, 60, 4)    # Cluster 2: centered at 60
  )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = x_coord, y = y_coord)) +
  geom_point()

ggsave("sample-images/baseline/bimodal_clusters.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_threshold_effect
# ============================================================================
# Prompt: create a scatterplot with the df dataset, which already exists in your environment.
# put `level` on the x-axis and `outcome` on the y-axis. briefly describe what you see.

set.seed(234)
df <- tibble::tibble(
  level = runif(80, 0, 30),
  outcome = ifelse(
    level < 15,
    12 + 0.3 * level + rnorm(80, 0, 2),
    35 + 0.5 * level + rnorm(80, 0, 2)
  )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = level, y = outcome)) +
  geom_point()

ggsave("sample-images/baseline/threshold_effect.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_positive_subgroups
# ============================================================================
# Prompt: plot the `df` dataset with the `duration` column on the x-axis and the `score` column
# on the y-axis. represent `group` with color or another way. the `df` dataset already exists in your environment.
# briefly tell me what you see.

set.seed(456)
df <- tibble::tibble(
  duration = rep(10:60, times = 3),
  group = rep(c("A", "B", "C"), each = 51),
  score = c(
    8 + 0.4 * (10:60) + rnorm(51, 0, 2.5),    # A: higher baseline, steeper
    5 + 0.25 * (10:60) + rnorm(51, 0, 2),     # B: middle baseline, moderate
    3 + 0.15 * (10:60) + rnorm(51, 0, 1.5)    # C: lower baseline, gentler
  )
)
df$score <- pmax(df$score, 0)

# TODO: Code your plot here
p <- ggplot(df, aes(x = duration, y = score, color = group)) +
  geom_point()

ggsave("sample-images/baseline/positive_subgroups.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_department_values
# ============================================================================
# Prompt: create a boxplot showing the df dataset, which already exists in your environment.
# put `department` on the x-axis and `value` on the y-axis.
# briefly tell me what you observe in the plot.

set.seed(789)
df <-
  tibble::tibble(
    department = rep(c("Sales", "Engineering", "Support"), each = 25),
    value = c(
      rnorm(25, 72, 7),   # Sales: middle
      rnorm(25, 85, 6),   # Engineering: highest
      rnorm(25, 58, 8)    # Support: lowest
    )
  )

# TODO: Code your plot here
p <- ggplot(df, aes(x = department, y = value)) +
  geom_boxplot()

ggsave("sample-images/baseline/department_values.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_temperature_energy
# ============================================================================
# Prompt: can you create a scatter or line plt using the df dataset? Put `temperature` column
# on the x and `metric` column on the y and color the points/lines by the `category` column.
# Then, concisely tell me what patterns you see. df already exists.

set.seed(789)
temp_seq <- seq(30, 100, length.out = 50)
df <- tibble::tibble(
  temperature = rep(temp_seq, times = 2),
  category = rep(c("A", "B"), each = 50),
  metric = c(
    1500 + 0.8 * (temp_seq - 65)^2 + rnorm(50, 0, 100),  # A: U-shaped centered at 65
    1200 + 0.6 * (temp_seq - 65)^2 + rnorm(50, 0, 80)    # B: U-shaped, lower
  )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = temperature, y = metric, color = category)) +
  geom_point()

ggsave("sample-images/baseline/temperature_energy.png", p, width = 7, height = 5, dpi = 150)
rm(df)

# ============================================================================
# baseline_product_sales
# ============================================================================
# Prompt: Create a lineplot with the df dataset with the `month` column
# on the x-axis and the `sales` column on the y-axis and different lines colored
# by the `product` column. then briefly tell me what patterns you see. df already
# exists. you do not need to create it.

set.seed(456)
df <- tibble::tibble(
  month = rep(1:12, times = 3),
  product = rep(c("Product A", "Product B", "Product C"), each = 12),
  sales = c(
    5000 + 500 * sin((1:12) * pi / 6) + rnorm(12, 0, 300),
    3000 + 200 * (1:12) + rnorm(12, 0, 200),
    8000 - 400 * (1:12) + rnorm(12, 0, 400)
  )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = month, y = sales, color = product)) +
  geom_line()

ggsave("sample-images/baseline/product_sales.png", p, width = 7, height = 5, dpi = 150)
rm(sales)

# ============================================================================
# baseline_category_time_growth
# ============================================================================
# Prompt: can you make a scatter plot or line plot with the df dataset, which already exists in your environment? put `time` on the x-axis and
# `value` on the y-axis and color the points/lines with the `category` column. then succinctly tell me
# what patterns you see.

set.seed(123)
df <- tibble::tibble(
  category = rep(c("A", "B", "C", "D"), each = 30),
  time = rep(0:29, times = 4),
  value = c(
    35000 + 1200 * (0:29) + rnorm(30, 0, 3000),  # A
    50000 + 1800 * (0:29) + rnorm(30, 0, 4000),  # B
    80000 + 9000 * (0:29) + rnorm(30, 0, 5000),  # C
    90000 + 10000 * (0:29) + rnorm(30, 0, 6000)   # D
  )
)

# TODO: Code your plot here
p <- ggplot(df, aes(x = time, y = value, color = category)) +
  geom_line() +
  geom_point()

ggsave("sample-images/baseline/category_time_growth.png", p, width = 7, height = 5, dpi = 150)
rm(df)

cat("✓ Dataset generation complete. Now code your plots and run this script to generate images.\n")
