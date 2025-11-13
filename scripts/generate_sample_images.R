# Generate sample plot images for image interpretation evaluation
# Run this script once to create the images

library(ggplot2)
library(tibble)

# Create sample-images directory if it doesn't exist
if (!dir.exists("sample-images")) {
  dir.create("sample-images")
}

# 1. Positive correlation
set.seed(123)
df_pos <- tibble(
  x = 1:30,
  y = 2 * (1:30) + rnorm(30, 0, 5)
)

p1 <- ggplot(df_pos, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)  

ggsave("sample-images/positive_correlation.png", p1, width = 7, height = 5, dpi = 150)

# 2. Negative correlation
set.seed(456)
df_neg <- tibble(
  temperature = seq(0, 50, length.out = 30),
  efficiency = 100 - 1.8 * seq(0, 50, length.out = 30) + rnorm(30, 0, 5)
)

p2 <- ggplot(df_neg, aes(x = temperature, y = efficiency)) +
  geom_point(size = 3, alpha = 0.7)

ggsave("sample-images/negative_correlation.png", p2, width = 7, height = 5, dpi = 150)

# 3. Group differences
set.seed(789)
df_groups <- tibble(
  group = rep(c("A", "B", "C"), each = 30),
  value = c(
    rnorm(30, 50, 8),
    rnorm(30, 70, 8),
    rnorm(30, 85, 8)
  )
)

p3 <- ggplot(df_groups, aes(x = group, y = value, fill = group)) +
  geom_boxplot(alpha = 0.7) 

ggsave("sample-images/group_differences.png", p3, width = 7, height = 5, dpi = 150)

# 4. No correlation
set.seed(234)
df_none <- tibble(
  x = 1:30,
  y = rnorm(30, 50, 10)
)

p4 <- ggplot(df_none, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)

ggsave("sample-images/no_correlation.png", p4, width = 7, height = 5, dpi = 150)

# 5. U-shaped relationship
set.seed(567)
df_quad <- tibble(
  x = seq(-5, 5, length.out = 30),
  y = (seq(-5, 5, length.out = 30))^2 + rnorm(30, 0, 2)
)

p5 <- ggplot(df_quad, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7) 

ggsave("sample-images/quadratic.png", p5, width = 7, height = 5, dpi = 150)

# Create unusual subdirectory
if (!dir.exists("sample-images/unusual")) {
  dir.create("sample-images/unusual")
}

# ============================================================================
# UNUSUAL PATTERNS (10 plots)
# ============================================================================

# 1. Rising Then Plateau (saturation)
set.seed(2001)
x <- seq(0, 10, length.out = 80)
y <- 20 * (1 - exp(-0.5 * x)) + rnorm(80, 0, 1.5)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/logarithmic.png", p, width = 7, height = 5, dpi = 150)

# 2. Smile-Then-Frown (cubic)
set.seed(2002)
x <- seq(-3, 3, length.out = 80)
y <- x^3 - 3*x + rnorm(80, 0, 2)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/cubic.png", p, width = 7, height = 5, dpi = 150)

# 3. Step Change (discontinuity)
set.seed(2003)
x <- seq(0, 10, length.out = 80)
y <- 2*x + ifelse(x > 5, 10, 0) + rnorm(80, 0, 1.5)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/discontinuity.png", p, width = 7, height = 5, dpi = 150)

# 4. Triangle Clusters
set.seed(2004)
cluster1 <- data.frame(x = rnorm(30, 0, 1), y = rnorm(30, 0, 1))
cluster2 <- data.frame(x = rnorm(30, 5, 1), y = rnorm(30, 0, 1))
cluster3 <- data.frame(x = rnorm(30, 2.5, 1), y = rnorm(30, 4.3, 1))
df <- rbind(cluster1, cluster2, cluster3)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/triangle_clusters.png", p, width = 7, height = 5, dpi = 150)

# 5. Donut Ring
set.seed(2005)
theta <- runif(80, 0, 2*pi)
r <- rnorm(80, 5, 0.4)
x <- r * cos(theta)
y <- r * sin(theta)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7) +
  coord_fixed()
ggsave("sample-images/circle.png", p, width = 7, height = 5, dpi = 150)

# 7. Heteroskedastic (funnel)
set.seed(2007)
x <- seq(0, 10, length.out = 80)
y <- 2*x + rnorm(80, 0, sd = 0.3 + 0.5*x)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/heteroskedastic.png", p, width = 7, height = 5, dpi = 150)

# 8. Reverses (inverted U)
set.seed(2008)
x <- seq(0, 10, length.out = 80)
y <- 15 - (x - 5)^2 + rnorm(80, 0, 2)
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/negative_quadratic.png", p, width = 7, height = 5, dpi = 150)

# 9. Outlier Structure
set.seed(2009)
x <- c(rnorm(70, 5, 0.8), seq(0, 10, length.out = 10))
y <- c(rnorm(70, 5, 0.8), seq(0, 10, length.out = 10))
df <- data.frame(x = x, y = y)
p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/linear_outliers.png", p, width = 7, height = 5, dpi = 150)

# 10. Interaction (opposite slopes by group)
set.seed(2010)
df <- data.frame(
  x = rep(seq(0, 10, length.out = 40), 2),
  group = rep(c("A", "B"), each = 40)
)
df$y <- ifelse(df$group == "A",
               2*df$x + rnorm(40, 0, 2),
               -1*df$x + 20 + rnorm(40, 0, 2))
p <- ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point(size = 3, alpha = 0.7)
ggsave("sample-images/interaction.png", p, width = 7, height = 5, dpi = 150)

