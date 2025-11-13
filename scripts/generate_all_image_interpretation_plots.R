#!/usr/bin/env Rscript
# Generate all image-interpretation plots with consistent ggplot styling
# Uses default ggplot theme for consistency

library(ggplot2)

# Use default ggplot theme (theme_gray)
# No theme_set() call - just use ggplot defaults

# Consistent plot dimensions
plot_width <- 6
plot_height <- 5
plot_dpi <- 150

# Create output directories
dir.create("sample-images", showWarnings = FALSE)
dir.create("sample-images/unusual", showWarnings = FALSE)

cat("Generating all image-interpretation plots with default ggplot theme...\n\n")

# ============================================================================
# STANDARD PATTERNS (5 plots)
# ============================================================================

cat("=== STANDARD PATTERNS ===\n")

# 1. Positive Correlation
cat("Generating: Positive correlation...\n")
set.seed(1001)
df <- data.frame(
  x = 1:30,
  y = 2 * (1:30) + rnorm(30, 0, 5)
)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5)
ggsave("sample-images/positive_correlation.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 2. Negative Correlation
cat("Generating: Negative correlation...\n")
set.seed(1002)
df <- data.frame(
  x = 1:30,
  y = -2 * (1:30) + 60 + rnorm(30, 0, 5)
)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5)
ggsave("sample-images/negative_correlation.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 3. No Correlation
cat("Generating: No correlation...\n")
set.seed(1003)
df <- data.frame(
  x = 1:30,
  y = rnorm(30, 50, 10)
)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5)
ggsave("sample-images/no_correlation.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 4. Quadratic (U-shaped)
cat("Generating: Quadratic relationship...\n")
set.seed(1004)
x <- seq(-3, 3, length.out = 30)
df <- data.frame(
  x = x,
  y = x^2 + rnorm(30, 0, 1)
)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5)
ggsave("sample-images/quadratic.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 5. Group Differences (boxplot)
cat("Generating: Group differences...\n")
set.seed(1005)
df <- data.frame(
  group = rep(c("A", "B", "C"), each = 30),
  value = c(rnorm(30, 20, 3), rnorm(30, 30, 3), rnorm(30, 40, 3))
)
p <- ggplot(df, aes(x = group, y = value)) +
  geom_boxplot()
ggsave("sample-images/group_differences.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# ============================================================================
# UNUSUAL PATTERNS (10 plots)
# ============================================================================

cat("\n=== UNUSUAL PATTERNS ===\n")

# 1. Rising Then Plateau (saturation)
cat("Generating: Rising plateau...\n")
set.seed(2001)
x <- seq(0, 10, length.out = 80)
y <- 20 * (1 - exp(-0.5 * x)) + rnorm(80, 0, 1.5)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_rising_plateau.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 2. Smile-Then-Frown (cubic)
cat("Generating: Smile-frown (cubic)...\n")
set.seed(2002)
x <- seq(-3, 3, length.out = 80)
y <- x^3 - 3*x + rnorm(80, 0, 2)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_smile_frown.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 3. Step Change (discontinuity)
cat("Generating: Step change...\n")
set.seed(2003)
x <- seq(0, 10, length.out = 80)
y <- 2*x + ifelse(x > 5, 10, 0) + rnorm(80, 0, 1.5)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_step_change.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 4. Triangle Clusters
cat("Generating: Triangle clusters...\n")
set.seed(2004)
cluster1 <- data.frame(x = rnorm(30, 0, 1), y = rnorm(30, 0, 1))
cluster2 <- data.frame(x = rnorm(30, 5, 1), y = rnorm(30, 0, 1))
cluster3 <- data.frame(x = rnorm(30, 2.5, 1), y = rnorm(30, 4.3, 1))
df <- rbind(cluster1, cluster2, cluster3)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_triangle_clusters.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 5. Donut Ring
cat("Generating: Donut ring...\n")
set.seed(2005)
theta <- runif(80, 0, 2*pi)
r <- rnorm(80, 5, 0.4)
x <- r * cos(theta)
y <- r * sin(theta)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7) +
  coord_fixed()
ggsave("sample-images/unusual/unusual_donut_ring.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 6. Curved Clusters (arcs)
cat("Generating: Curved clusters...\n")
set.seed(2006)
t <- seq(0, pi, length.out = 40)
cluster1 <- data.frame(x = 3 * cos(t) + rnorm(40, 0, 0.25),
                       y = 3 * sin(t) + rnorm(40, 0, 0.25))
t <- seq(pi, 2*pi, length.out = 40)
cluster2 <- data.frame(x = 3 * cos(t) + rnorm(40, 0, 0.25),
                       y = 3 * sin(t) + rnorm(40, 0, 0.25))
df <- rbind(cluster1, cluster2)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7) +
  coord_fixed()
ggsave("sample-images/unusual/unusual_curved_clusters.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 7. Heteroskedastic (funnel)
cat("Generating: Heteroskedastic funnel...\n")
set.seed(2007)
x <- seq(0, 10, length.out = 80)
y <- 2*x + rnorm(80, 0, sd = 0.3 + 0.5*x)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_heteroskedastic.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 8. Reverses (inverted U)
cat("Generating: Reversing relationship...\n")
set.seed(2008)
x <- seq(0, 10, length.out = 80)
y <- 15 - (x - 5)^2 + rnorm(80, 0, 2)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_reverses.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 9. Outlier Structure
cat("Generating: Outlier structure...\n")
set.seed(2009)
x <- c(rnorm(70, 5, 0.8), seq(0, 10, length.out = 10))
y <- c(rnorm(70, 5, 0.8), seq(0, 10, length.out = 10))
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_outlier_structure.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

# 10. Interaction (opposite slopes by group)
cat("Generating: Interaction effect...\n")
set.seed(2010)
df <- data.frame(
  x = rep(seq(0, 10, length.out = 40), 2),
  group = rep(c("A", "B"), each = 40)
)
df$y <- ifelse(df$group == "A",
               2*df$x + rnorm(40, 0, 2),
               -1*df$x + 20 + rnorm(40, 0, 2))
p <- ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point(size = 2.5, alpha = 0.7)
ggsave("sample-images/unusual/unusual_interaction.png", p,
       width = plot_width, height = plot_height, dpi = plot_dpi)

cat("\n✓ All 15 plots generated successfully!\n")
cat("  Standard patterns: sample-images/\n")
cat("  Unusual patterns: sample-images/unusual/\n")
cat("\nAll plots use default ggplot theme (theme_gray) for consistency.\n")
