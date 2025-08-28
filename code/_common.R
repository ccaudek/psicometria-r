# =======================================================================
# _common.R - Setup globale per i file .qmd del manuale Bayes per psicologi
# Carica pacchetti comuni, imposta backend, opzioni grafiche e tabelle uniformi
# Suggerimento: in _quarto.yml puoi aggiungere `fig-format: svg` sotto format:html:
# =======================================================================

# =======================================================================
# _common.R - Setup globale per i file .qmd del manuale Bayes per psicologi
# =======================================================================

## ─────────────────────────────────────────────────────────────────────
## 1. Pacchetti per manipolazione e struttura dei dati
## ─────────────────────────────────────────────────────────────────────
library(here)
library(rio)
library(tidyr)
library(dplyr)
library(tibble)
library(modelr)
library(matrixStats)
library(janitor)
library(conflicted)
library(sessioninfo)

conflict_prefer("var", "stats")
conflict_prefer("sd", "stats")
conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")

## ─────────────────────────────────────────────────────────────────────
## 2. Pacchetti per analisi bayesiana
## ─────────────────────────────────────────────────────────────────────
library(brms)
library(rstan)
library(loo)
library(posterior)
library(priorsense)
library(reliabilitydiag)

conflict_prefer("mad", "posterior")
conflict_prefer("rhat", "posterior")
conflict_prefer("ess_bulk", "posterior")
conflict_prefer("ess_tail", "posterior")

options(
  brms.backend = "cmdstanr",
  mc.cores = parallel::detectCores(logical = FALSE),
  posterior.num_args = list(digits = 2)
)

## ─────────────────────────────────────────────────────────────────────
## 3. Pacchetti per visualizzazione
## ─────────────────────────────────────────────────────────────────────
library(ggplot2)
library(bayesplot)
library(tidybayes)
library(ggdist)
library(patchwork)

## ─────────────────────────────────────────────────────────────────────
## 4. Stile tabelle
## ─────────────────────────────────────────────────────────────────────
library(tinytable)
options(
  tinytable_format_num_fmt = "significant_cell",
  tinytable_format_digits = 2,
  tinytable_tt_digits = 2
)

## ─────────────────────────────────────────────────────────────────────
## 5. Opzioni di stampa console
## ─────────────────────────────────────────────────────────────────────
library(pillar)
options(
  pillar.negative = FALSE,
  pillar.subtle = FALSE,
  pillar.bold = TRUE,
  pillar.width = Inf,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  tibble.width = Inf,
  width = 77,
  scipen = 1,
  digits = 4,
  show.signif.stars = FALSE
)

## ─────────────────────────────────────────────────────────────────────
## 6. Font detection BEFORE theme definition
## ─────────────────────────────────────────────────────────────────────
fallback_serif <- {
  available_fonts <- systemfonts::system_fonts()$family

  palatino_variants <- c(
    "Palatino Linotype",
    "Palatino",
    "Palatino Nova",
    "TeX Gyre Pagella"
  )

  classical_alternatives <- c(
    "Book Antiqua",
    "URW Palladio L",
    "EB Garamond",
    "Georgia"
  )

  found_palatino <- palatino_variants[palatino_variants %in% available_fonts]
  if (length(found_palatino)) {
    found_palatino[1]
  } else {
    found_classical <- classical_alternatives[
      classical_alternatives %in% available_fonts
    ]
    if (length(found_classical)) found_classical[1] else "serif"
  }
}


## ─────────────────────────────────────────────────────────────────────
## 7. Tema ggplot2 classico (AFTER font definition)
## ─────────────────────────────────────────────────────────────────────
theme_psico_classic <- function(base_family = fallback_serif, base_size = 15) {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # Classical title hierarchy
      plot.title = element_text(
        face = "plain",
        size = rel(1.2),
        margin = margin(b = 8),
        color = "#2d2926"
      ),

      plot.subtitle = element_text(
        face = "italic",
        size = rel(0.95),
        margin = margin(b = 10),
        color = "#5d5349"
      ),

      plot.caption = element_text(
        size = rel(0.85),
        face = "italic",
        color = "#5d5349",
        hjust = 0,
        margin = margin(t = 10)
      ),

      axis.title = element_text(
        size = rel(0.9),
        color = "#2d2926",
        margin = margin(t = 8)
      ),

      axis.text = element_text(
        size = rel(0.85),
        color = "#5d5349"
      ),

      strip.text = element_text(
        size = rel(0.9),
        face = "plain",
        color = "#2d2926",
        margin = margin(6, 6, 6, 6)
      ),

      # Subtle grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(
        linewidth = 0.15,
        color = "#00000026"
      ),

      # Hairline axes
      axis.line = element_line(
        linewidth = 0.25,
        color = "#00000040"
      ),

      axis.ticks = element_line(
        linewidth = 0.2,
        color = "#00000060"
      ),

      axis.ticks.length = unit(3, "pt"),

      # Legend positioning
      legend.position = "bottom",
      legend.justification = "center",
      legend.title = element_text(
        face = "plain",
        size = rel(0.9)
      ),
      legend.text = element_text(size = rel(0.85)),

      # Panel styling with warm palette
      panel.border = element_rect(
        fill = NA,
        color = "#e6e2d9",
        linewidth = 0.3
      ),

      plot.background = element_rect(
        fill = "#fdfcf8",
        color = NA
      ),

      panel.background = element_rect(
        fill = "#fdfcf8",
        color = NA
      ),

      panel.spacing = unit(10, "pt"),

      # Title positioning
      plot.title.position = "plot",
      plot.caption.position = "plot"
    )
}

# Apply theme globally
theme_set(theme_psico_classic())

## ─────────────────────────────────────────────────────────────────────
## 8. Opzioni globali knitr
## ─────────────────────────────────────────────────────────────────────
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  echo = TRUE,
  eval = TRUE,
  error = FALSE,
  dev = "ragg_png",
  dev.args = list(bg = "transparent"), # transparent PNG
  dpi = 192, # Single DPI declaration
  out.width = "90%",
  fig.align = "center",
  fig.asp = 0.75,
  fig.width = 6.5,
  dev.args = list(bg = "#fdfcf8"),
  R.options = list(digits = 4, width = 76)
)

## ─────────────────────────────────────────────────────────────────────
## 9. Color palettes
## ─────────────────────────────────────────────────────────────────────

# Renaissance palette
renaissance_palette <- c(
  primary = "#2d2926",
  secondary = "#5d5349",
  accent = "#8B4513",
  warm_red = "#A0522D",
  warm_blue = "#4682B4",
  warm_green = "#6B8E23",
  warm_purple = "#8B4789",
  warm_orange = "#CD853F"
)

scale_fill_renaissance <- function(...) {
  ggplot2::scale_fill_manual(values = renaissance_palette, ...)
}

scale_color_renaissance <- function(...) {
  ggplot2::scale_color_manual(values = renaissance_palette, ...)
}

# Keep Okabe-Ito as backup for accessibility
okabe_ito <- c(
  black = "#000000",
  orange = "#E69F00",
  sky = "#56B4E9",
  bluishgreen = "#009E73",
  yellow = "#F0E442",
  blue = "#0072B2",
  vermillion = "#D55E00",
  reddishpurple = "#CC79A7"
)

.okabe_ito_no_black <- okabe_ito[c(
  "sky",
  "vermillion",
  "bluishgreen",
  "orange",
  "blue",
  "reddishpurple",
  "yellow"
)]

scale_fill_okabe_ito <- function(..., drop_black = TRUE) {
  vals <- if (isTRUE(drop_black)) .okabe_ito_no_black else okabe_ito
  ggplot2::scale_fill_manual(values = vals, ...)
}

scale_color_okabe_ito <- function(..., drop_black = TRUE) {
  vals <- if (isTRUE(drop_black)) .okabe_ito_no_black else okabe_ito
  ggplot2::scale_color_manual(values = vals, ...)
}

## ─────────────────────────────────────────────────────────────────────
## 10. Geometric defaults and helper functions
## ─────────────────────────────────────────────────────────────────────
update_geom_defaults("point", list(size = 1.8, alpha = 0.9))
update_geom_defaults("line", list(linewidth = 0.4))
update_geom_defaults("segment", list(linewidth = 0.3))
update_geom_defaults("rect", list(color = "#00000040"))

# Helper functions for classical annotations
add_classical_caption <- function(plot, caption, source = NULL) {
  plot +
    labs(
      caption = if (!is.null(source)) {
        paste0(caption, "\n", "Fonte: ", source)
      } else {
        caption
      }
    )
}

add_margin_note <- function(plot, note, side = "right") {
  plot + labs(subtitle = paste("Nota:", note))
}

# Italian number labels
label_it <- function(accuracy = NULL) {
  scales::label_number(accuracy = accuracy, decimal.mark = ",", big.mark = ".")
}

## ─────────────────────────────────────────────────────────────────────
## 11. Package-specific theming
## ─────────────────────────────────────────────────────────────────────

# Align bayesplot with theme
bayesplot::bayesplot_theme_set(theme_psico_classic(
  base_family = fallback_serif,
  base_size = 14
))
bayesplot::color_scheme_set(scheme = "blue")

# ggdist/tidybayes consistency
options(
  ggdist.distributions_contour_color = "#00000033",
  ggdist.slab_fill = "#0072B210",
  ggdist.interval_color = "#00000080"
)

# Patchwork settings
options(plot.tag = "Figura ")
options(plot.tag.position = "topleft")

# Convenience shortcuts
guides_top <- guides(
  color = guide_legend(nrow = 1, byrow = TRUE),
  fill = guide_legend(nrow = 1, byrow = TRUE)
)

thin_ygrid <- theme(panel.grid.major.x = element_blank())
thin_xgrid <- theme(panel.grid.major.y = element_blank())

# Global legend tweaks
theme_update(
  legend.spacing.y = unit(2, "pt"),
  legend.text = element_text(margin = margin(b = 2))
)

## ─────────────────────────────────────────────────────────────────────
## 12. Riproducibilità
## ─────────────────────────────────────────────────────────────────────
set.seed(42)

# =======================================================================
# Fine setup globale
# =======================================================================
