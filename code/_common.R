# =============================================================================
#  Common Packages and Global Settings
#  Corrado Caudek
# =============================================================================

## -- 1. Package management ----------------------------------------------------
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  here,
  rio,
  tidyverse,
  knitr,
  markdown,
  scales,
  psych,
  bayesplot,
  patchwork,
  gridExtra,
  see,
  tidyr,
  ggokabeito,
  MetBrewer,
  thematic
)

# Riduci il rumore di caricamento da tidyverse
options(tidyverse.quiet = TRUE)

## -- 2. Palette e tema grafico  ----------------------------------------------

# Palette Okabe-Ito (dal pacchetto ggokabeito)
okabe_ito_palette <- ggokabeito::palette_okabe_ito()

# Imposta il tema globale: bayesplot::theme_default()
# • base_size 14 → leggibilità su pdf/A4 e presentazioni
# • base_family "sans" → coerenza con linee guida APA
theme_set(
  bayesplot::theme_default(
    base_size = 14,
    base_family = "sans"
  )
)

# Aggiorna i parametri estetici di default per geoms comuni
ggplot2::update_geom_defaults("point", list(colour = okabe_ito_palette[1]))
ggplot2::update_geom_defaults("line", list(colour = okabe_ito_palette[1]))

# Scale manuali di convenienza (discrete/continue)
default_discrete_scale <- function(...)
  scale_fill_manual(..., values = okabe_ito_palette)
default_continuous_scale <- function(...) scale_fill_viridis_c(...)

# Schema colore di default per bayesplot
bayesplot::color_scheme_set("brightblue")

## -- 3. Opzioni knitr ---------------------------------------------------------

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  width = 72,
  out.width = "70%",
  fig.align = "center",
  fig.width = 6,
  fig.asp = 0.618, # Rapporto aureo
  fig.show = "hold",
  R.options = list(digits = 4, width = 76),
  echo = TRUE,
  eval = TRUE,
  error = FALSE
)

## -- 4. Global R options ------------------------------------------------------

options(
  scipen = 1, # evitare notazione scientifica
  digits = 4,
  ggplot2.discrete.colour = okabe_ito_palette,
  ggplot2.discrete.fill = okabe_ito_palette,
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  show.signif.stars = FALSE,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  pillar.bold = TRUE,
  width = 77
)

options(pillar.subtle = FALSE, pillar.width = Inf, tibble.width = Inf)

## -- 5. Riproducibilità -------------------------------------------------------

set.seed(42)
