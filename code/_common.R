# -----------------------------------------------------------------------------
# Common Packages and Settings
# -----------------------------------------------------------------------------

# Use pacman to manage and load required packages automatically
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  here,         # Manage relative file paths
  rio,          # Data import and export
  tidyverse,    # Data manipulation and visualization (collection of packages)
  knitr,        # Generate documents with LaTeX integration
  markdown,     # Convert Markdown to HTML
  scales,       # Format axes and scales in plots
  psych,        # Psychometric analysis tools
  bayesplot,    # Bayesian diagnostic and visualization plots
  patchwork,    # Combine multiple ggplots
  gridExtra,    # Grid layout functions for plots
  see,          # Okabe-Ito palettes and other utilities
  tidyr,        # Tools for creating tidy data
  ggokabeito,   # Okabe-Ito qualitative palettes for ggplot2
  MetBrewer,    # Artistic color palettes
  thematic      # gives R plots the ability to style themselves R Markdown
)

# Suppress unnecessary messages from tidyverse packages
options(tidyverse.quiet = TRUE)

# -----------------------------------------------------------------------------
# knitr Options for Code Chunks
# -----------------------------------------------------------------------------

knitr::opts_chunk$set(
  comment = "#>",                    # Comment prefix for output
  collapse = TRUE,                   # Collapse code and output into a single block
  message = FALSE,                   # Suppress messages
  warning = FALSE,                   # Suppress warnings
  width = 72,                        # Code width
  tidy.opts = list(width.cutoff = 72, tidy = "styler"),
  out.width = "70%",                 # Default output width for figures
  fig.align = "center",              # Center-align figures
  fig.width = 6,                     # Default figure width
  fig.asp = 0.618,                   # Golden ratio for figure height
  fig.show = "hold",                 # Show figures together
  R.options = list(
    digits = 4,                      # Number of digits for output
    width = 76                       # Console width
  ),
  formatR.indent = 2,                # Indentation for tidied code
  dplyr.summarise.inform = FALSE,    # Suppress dplyr summarize messages
  dplyr.print_min = 5,               # Minimum rows to print for tibbles
  dplyr.print_max = 5,               # Maximum rows to print for tibbles
  ggrepel.max.overlaps = 100,        # Prevent excessive label overlap
  echo = TRUE,                       # Show code by default
  eval = TRUE,                       # Execute code by default
  error = FALSE                      # Suppress error messages in chunks
)

# -----------------------------------------------------------------------------
# Global Options
# -----------------------------------------------------------------------------

options(
  scipen = 1,                        # Favor standard notation over scientific
  digits = 4,                        # Default number of digits
  ggplot2.discrete.colour = ggokabeito::palette_okabe_ito(),
  ggplot2.discrete.fill = ggokabeito::palette_okabe_ito(),
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  show.signif.stars = FALSE,         # Suppress significance stars in output
  pillar.max_footer_lines = 2,       # Control console output of data frames
  pillar.min_chars = 15,
  pillar.bold = TRUE,
  width = 77                         # Console width (80 chars - 3 for comments)
)

# -----------------------------------------------------------------------------
# ggplot2 Theme and bayesplot Settings
# -----------------------------------------------------------------------------

# Set default ggplot2 theme to bayesplot's theme with custom font and size
theme_set(
  bayesplot::theme_default(
    base_size = 13,  # Font size for plots
    base_family = "sans"  # Font family
  )
)

# Set color scheme for bayesplot diagnostics
color_scheme_set("brightblue")

# -----------------------------------------------------------------------------
# Custom Color Palettes
# -----------------------------------------------------------------------------

# Enhanced Okabe-Ito palette with an additional custom color
palette_okabe_enhanced <- c(
  ggokabeito::palette_okabe_ito(order = c(5, 1, 3, 4, 2, 6, 7, 8, 9)), 
  "#882E72"                          # Additional color
)

# Discrete color scale using the "Hiroshige" palette from MetBrewer
scale_colour_discrete <- scale_color_manual(
  values = MetBrewer::met.brewer("Hiroshige", 10) # 10-color palette
)

# Discrete fill scale using the "Hiroshige" palette from MetBrewer
scale_fill_discrete <- scale_fill_manual(
  values = MetBrewer::met.brewer("Hiroshige", 10) # 10-color palette
)

# -----------------------------------------------------------------------------
# Seed for Reproducibility
# -----------------------------------------------------------------------------

set.seed(42) # Ensure reproducibility
