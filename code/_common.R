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
conflicts_prefer(stats::chisq.test)

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
  posterior.num_args = list(digits = 2) # Increased precision for academic work
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
## 4. Stile tabelle (enhanced for classical typography)
## ─────────────────────────────────────────────────────────────────────
library(tinytable)
options(
  tinytable_format_num_fmt = "significant_cell",
  tinytable_format_digits = 3, # Increased precision
  tinytable_tt_digits = 3,
  tinytable_theme = "void" # Minimal styling to match book aesthetic
)

## ─────────────────────────────────────────────────────────────────────
## 5. Opzioni di stampa console (enhanced for readability)
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
  width = 72, # Golden ratio derived from 72ch CSS setting
  scipen = 3, # Avoid scientific notation in most cases
  digits = 4,
  show.signif.stars = FALSE
)

## ─────────────────────────────────────────────────────────────────────
## 6. Font detection with Renaissance hierarchy
## ─────────────────────────────────────────────────────────────────────
detect_renaissance_fonts <- function() {
  available_fonts <- systemfonts::system_fonts()$family

  # Primary serif fonts matching CSS
  primary_serif <- c(
    "Palatino",
    "Palatino nova Pro",
    "ETBook",
    "EB Garamond",
    "TeX Gyre Pagella",
    "Palatino Linotype"
  )

  # Secondary classical alternatives
  secondary_serif <- c(
    "Book Antiqua",
    "URW Palladio L",
    "Adobe Jenson Pro",
    "Georgia"
  )

  # Find best available font
  found_primary <- primary_serif[primary_serif %in% available_fonts]
  if (length(found_primary)) {
    return(found_primary[1])
  }

  found_secondary <- secondary_serif[secondary_serif %in% available_fonts]
  if (length(found_secondary)) {
    return(found_secondary[1])
  }

  return("serif")
}

renaissance_serif <- detect_renaissance_fonts()

## ─────────────────────────────────────────────────────────────────────
## 7. Tema ggplot2 rinascimentale (enhanced to match CSS)
## ─────────────────────────────────────────────────────────────────────
theme_rinascimentale <- function(
  base_family = renaissance_serif,
  base_size = 15.5
) {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # Typography hierarchy matching CSS
      plot.title = element_text(
        face = "plain",
        size = rel(1.25), # Slightly larger for prominence
        margin = margin(b = 10),
        color = "#2d2926", # --text-primary from CSS
        family = base_family
      ),

      plot.subtitle = element_text(
        face = "italic",
        size = rel(0.95),
        margin = margin(b = 12),
        color = "#5d5349" # --text-secondary from CSS
      ),

      plot.caption = element_text(
        size = rel(0.88),
        face = "italic",
        color = "#5d5349",
        hjust = 0,
        margin = margin(t = 12),
        lineheight = 1.4
      ),

      # Axis styling with classical proportions
      axis.title = element_text(
        size = rel(0.92),
        color = "#2d2926",
        margin = margin(t = 10),
        face = "plain"
      ),

      axis.text = element_text(
        size = rel(0.85),
        color = "#5d5349",
        family = base_family
      ),

      # Facet labels in small caps style
      strip.text = element_text(
        size = rel(0.9),
        face = "plain",
        color = "#2d2926",
        margin = margin(8, 8, 8, 8)
      ),

      # Refined grid system matching hairline aesthetic
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(
        linewidth = 0.2, # Slightly thicker for better visibility
        color = "#00000020", # Softer than CSS version
        linetype = "solid"
      ),

      # Hairline borders matching CSS border colors
      axis.line = element_line(
        linewidth = 0.3,
        color = "#00000035"
      ),

      axis.ticks = element_line(
        linewidth = 0.25,
        color = "#00000050"
      ),

      axis.ticks.length = unit(4, "pt"),

      # Legend styling for academic presentation
      legend.position = "bottom",
      legend.justification = "center",
      legend.title = element_text(
        face = "plain",
        size = rel(0.9),
        color = "#2d2926"
      ),
      legend.text = element_text(
        size = rel(0.85),
        margin = margin(r = 8)
      ),
      legend.spacing.y = unit(3, "pt"),
      legend.margin = margin(t = 15),

      # Panel styling with warm paper background
      panel.border = element_rect(
        fill = NA,
        color = "#e6e2d9", # Matching CSS warm border
        linewidth = 0.4
      ),

      plot.background = element_rect(
        fill = "#fdfcf8", # --paper-warm from CSS
        color = NA
      ),

      panel.background = element_rect(
        fill = "#fdfcf8",
        color = NA
      ),

      strip.background = element_rect(
        fill = "#f8f6f0", # --paper-cream from CSS
        color = "#e6e2d9",
        linewidth = 0.3
      ),

      panel.spacing = unit(12, "pt"),

      # Title positioning for better hierarchy
      plot.title.position = "plot",
      plot.caption.position = "plot",

      # Enhanced spacing for readability
      plot.margin = margin(t = 20, r = 20, b = 15, l = 15)
    )
}

# Apply theme globally
theme_set(theme_rinascimentale())

## ─────────────────────────────────────────────────────────────────────
## 8. Opzioni knitr ottimizzate per il design rinascimentale
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
  dpi = 192,
  out.width = "85%", # Better proportion for 72ch text width
  fig.align = "center",
  fig.asp = 0.618, # Golden ratio aspect
  fig.width = 7,
  fig.height = 4.33, # 7 * 0.618
  dev.args = list(bg = "#fdfcf8"), # Warm paper background
  R.options = list(digits = 4, width = 72) # Match CSS max-width
)

## ─────────────────────────────────────────────────────────────────────
## 9. Palette rinascimentali (expanded and refined)
## ─────────────────────────────────────────────────────────────────────

# Primary Renaissance palette matching CSS color scheme
rinascimentale_primaria <- c(
  nero_antico = "#2d2926", # --text-primary
  seppia_scuro = "#5d5349", # --text-secondary
  terra_bruciata = "#8B4513", # --accent-warm
  siena_bruciata = "#A0522D", # Warm red
  blu_oltremare = "#4682B4", # Warm blue
  verde_oliva = "#6B8E23", # Warm green
  porpora_antico = "#8B4789", # Warm purple
  ocra_dorata = "#CD853F" # Warm orange
)

# Secondary palette for complex visualizations
rinascimentale_secondaria <- c(
  rosso_veneziano = "#C41E3A",
  blu_lapislazzuli = "#26619C",
  verde_malachite = "#0BDA51",
  giallo_oro = "#FFD700",
  violetto_ametista = "#9966CC",
  marrone_umber = "#635147"
)

# Monochromatic scale for academic precision
scala_seppia <- c(
  "#2d2926",
  "#443f3a",
  "#5d5349",
  "#756b5d",
  "#8d8272",
  "#a59a87",
  "#bdb29c",
  "#d5cab1"
)

# Function factories for consistent theming
crea_scala_colori <- function(palette) {
  function(...) ggplot2::scale_color_manual(values = palette, ...)
}

crea_scala_riempimenti <- function(palette) {
  function(...) ggplot2::scale_fill_manual(values = palette, ...)
}

# Export scale functions
scale_color_rinascimentale <- crea_scala_colori(rinascimentale_primaria)
scale_fill_rinascimentale <- crea_scala_riempimenti(rinascimentale_primaria)
scale_color_seppia <- crea_scala_colori(scala_seppia)
scale_fill_seppia <- crea_scala_riempimenti(scala_seppia)

# Accessibility-compliant backup (Okabe-Ito)
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

okabe_ito_senza_nero <- okabe_ito[c(
  "sky",
  "vermillion",
  "bluishgreen",
  "orange",
  "blue",
  "reddishpurple",
  "yellow"
)]

scale_fill_accessibile <- function(..., usa_nero = FALSE) {
  vals <- if (usa_nero) okabe_ito else okabe_ito_senza_nero
  ggplot2::scale_fill_manual(values = vals, ...)
}

scale_color_accessibile <- function(..., usa_nero = FALSE) {
  vals <- if (usa_nero) okabe_ito else okabe_ito_senza_nero
  ggplot2::scale_color_manual(values = vals, ...)
}

## ─────────────────────────────────────────────────────────────────────
## 10. Defaults geometrici e funzioni helper raffinate
## ─────────────────────────────────────────────────────────────────────

# Update geometric defaults with renaissance aesthetics
update_geom_defaults(
  "point",
  list(
    size = 2.2,
    alpha = 0.85,
    stroke = 0.3,
    color = "#2d2926"
  )
)
update_geom_defaults(
  "line",
  list(
    linewidth = 0.6,
    color = "#2d2926",
    alpha = 0.9
  )
)
update_geom_defaults(
  "segment",
  list(
    linewidth = 0.4,
    color = "#5d5349"
  )
)
update_geom_defaults(
  "rect",
  list(
    color = "#00000025",
    fill = "#fdfcf8"
  )
)
update_geom_defaults(
  "text",
  list(
    family = renaissance_serif,
    color = "#2d2926",
    size = 3.5
  )
)

# Classical annotation functions
aggiungi_colofone <- function(plot, testo, fonte = NULL) {
  caption_text <- if (!is.null(fonte)) {
    paste0(testo, "\n", "Fonte: ", fonte)
  } else {
    testo
  }

  plot +
    labs(caption = caption_text) +
    theme(
      plot.caption = element_text(
        hjust = 0,
        family = renaissance_serif,
        face = "italic",
        size = rel(0.85)
      )
    )
}

aggiungi_nota_marginale <- function(plot, nota) {
  plot +
    labs(subtitle = paste("Nota:", nota)) +
    theme(
      plot.subtitle = element_text(
        face = "italic",
        size = rel(0.9),
        color = "#5d5349",
        lineheight = 1.4
      )
    )
}

# Italian formatting functions
formato_italiano <- function(accuracy = 0.01, scala = 1) {
  scales::label_number(
    accuracy = accuracy,
    scale = scala,
    decimal.mark = ",",
    big.mark = "."
  )
}

formato_percentuale_it <- function(accuracy = 1) {
  scales::label_percent(
    accuracy = accuracy,
    decimal.mark = ",",
    suffix = "%"
  )
}

# Default per histogram:
update_geom_defaults(
  "bar",
  list(
    fill = unname(rinascimentale_primaria["seppia_scuro"]),
    colour = "white", # puoi usare "color" ma internamente è "colour"
    alpha = 0.85,
    linewidth = 0.3
  )
)

## ─────────────────────────────────────────────────────────────────────
## 11. Configurazione pacchetti specialistici
## ─────────────────────────────────────────────────────────────────────

# Bayesplot theme alignment
bayesplot::bayesplot_theme_set(theme_rinascimentale(
  base_family = renaissance_serif,
  base_size = 14
))

# Use sepia color scheme for Bayesian plots
bayesplot::color_scheme_set("gray")

# ggdist/tidybayes Renaissance styling
options(
  ggdist.distributions_contour_color = "#2d292620",
  ggdist.slab_fill = "#8B451320",
  ggdist.interval_color = "#2d2926",
  ggdist.point_color = "#8B4513"
)

# Patchwork settings for multi-panel figures
patchwork_theme <- theme_rinascimentale() +
  theme(
    plot.tag = element_text(
      size = rel(1.1),
      face = "plain",
      color = "#2d2926",
      hjust = 0
    ),
    plot.tag.position = c(0.02, 0.98)
  )

options(
  patchwork.plot.tag = "Pannello ",
  patchwork.annotation.theme = patchwork_theme
)

# tinytable classical styling
options(
  tinytable_css_output = list(
    "table" = "font-family: serif; border-collapse: separate; border-spacing: 0;",
    "th" = "font-variant: small-caps; letter-spacing: 0.5px; padding: 0.5em 0.75em;",
    "td" = "padding: 0.4em 0.75em; font-variant-numeric: oldstyle-nums;"
  )
)

## ─────────────────────────────────────────────────────────────────────
## 12. Funzioni helper per l'estetica rinascimentale
## ─────────────────────────────────────────────────────────────────────

# Quick theme modifications
griglia_sottile_y <- theme(panel.grid.major.x = element_blank())
griglia_sottile_x <- theme(panel.grid.major.y = element_blank())
nessuna_griglia <- theme(panel.grid = element_blank())

# Legend positioning shortcuts
legenda_in_alto <- theme(
  legend.position = "top",
  legend.justification = "center"
)

legenda_destra <- theme(
  legend.position = "right",
  legend.justification = "top"
)

# Guide configurations for multiple aesthetics
guide_rinascimentale <- guides(
  color = guide_legend(
    nrow = 1,
    byrow = TRUE,
    override.aes = list(size = 3, alpha = 1)
  ),
  fill = guide_legend(
    nrow = 1,
    byrow = TRUE,
    override.aes = list(alpha = 0.8)
  )
)

# Figure sizing based on golden ratio
dimensioni_aurea <- function(larghezza = 7) {
  list(
    fig.width = larghezza,
    fig.height = larghezza / 1.618,
    fig.asp = 0.618
  )
}

# Apply classical spacing to legends globally
theme_update(
  legend.spacing.y = unit(3, "pt"),
  legend.text = element_text(margin = margin(b = 3)),
  legend.key.spacing.y = unit(2, "pt")
)

## ─────────────────────────────────────────────────────────────────────
## 13. Funzioni di utilità per la stampa accademica
## ─────────────────────────────────────────────────────────────────────

# Format Bayesian summaries in Italian style
formatta_sommario_bayesiano <- function(fit, digits = 3) {
  summary(fit) %>%
    as_tibble(rownames = "parametro") %>%
    mutate(
      across(
        where(is.numeric),
        ~ format(.x, digits = digits, decimal.mark = ",")
      )
    )
}

# Classical table styling function
tabella_rinascimentale <- function(data, caption = NULL, note = NULL) {
  tt(data) %>%
    style_tt(
      theme = "void",
      family = renaissance_serif,
      fontsize = "0.9em"
    ) %>%
    format_tt(digits = 3, num_fmt = "decimal_it") %>%
    {
      if (!is.null(caption))
        # PRIMA: j = list("" = names(data))  # <-- causa l'errore
        group_tt(., j = setNames(list(names(data)), ""), caption = caption) else
        .
    } %>%
    {
      if (!is.null(note)) footnote(., note, i = nrow(data)) else .
    }
}

# Confidence interval formatter
formato_ic <- function(stima, inf, sup, digits = 3) {
  paste0(
    format(stima, digits = digits, decimal.mark = ","),
    " [",
    format(inf, digits = digits, decimal.mark = ","),
    "; ",
    format(sup, digits = digits, decimal.mark = ","),
    "]"
  )
}
