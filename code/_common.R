# =======================================================================
# _common.R - Setup globale per i file .qmd del manuale Bayes per psicologi
# Carica pacchetti comuni, imposta backend, opzioni grafiche e tabelle uniformi
# Suggerimento: in _quarto.yml puoi aggiungere `fig-format: svg` sotto format:html:
# =======================================================================

## ─────────────────────────────────────────────────────────────────────
## 1. Pacchetti per manipolazione e struttura dei dati
## ─────────────────────────────────────────────────────────────────────
library(here) # gestione robusta dei path
library(rio) # import/export dati in vari formati
library(tidyr) # tidying
library(dplyr) # pipe-friendly data manipulation
library(tibble) # tibble come formato tabellare
library(modelr) # modelli + dataframe
library(matrixStats) # funzioni vettorializzate su righe/colonne
library(janitor)
library(conflicted)
library(sessioninfo)

# Preferenze per conflitti (usare sempre il singolare: conflict_prefer)
conflict_prefer("var", "stats")
conflict_prefer("sd", "stats")
conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")

## ─────────────────────────────────────────────────────────────────────
## 2. Pacchetti per analisi bayesiana
## ─────────────────────────────────────────────────────────────────────
library(brms) # modellazione Bayesiana ad alto livello
library(rstan) # backend Stan; usato da brms e diagnostica
library(loo) # model comparison (ELPD, LOO-CV)
library(posterior) # oggetti draws e funzioni diagnostiche
library(priorsense) # diagnostica dei prior
library(reliabilitydiag) # diagnostica di calibratura predittiva

# Preferenze per conflitti con posterior
conflict_prefer("mad", "posterior")
conflict_prefer("rhat", "posterior")
conflict_prefer("ess_bulk", "posterior")
conflict_prefer("ess_tail", "posterior")

# Opzioni brms e posterior
options(
  brms.backend = "cmdstanr", # preferibile a rstan
  mc.cores = parallel::detectCores(logical = FALSE), # usa tutti i core fisici
  posterior.num_args = list(digits = 2)
)

## ─────────────────────────────────────────────────────────────────────
## 3. Pacchetti per visualizzazione
## ─────────────────────────────────────────────────────────────────────
library(ggplot2) # base grafico
library(bayesplot) # diagnostiche bayesiane con ggplot2
library(tidybayes) # manipolazione tidy di output bayesiani
library(ggdist) # visualizzazioni di distribuzioni
library(patchwork) # composizione di più grafici ggplot2

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
  width = 77, # larghezza console
  scipen = 1, # evita notazione scientifica
  digits = 4, # cifre decimali nei print()
  show.signif.stars = FALSE
)

## ─────────────────────────────────────────────────────────────────────
## 6. Opzioni globali knitr (unificate)
## ─────────────────────────────────────────────────────────────────────
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  echo = TRUE,
  eval = TRUE,
  error = FALSE,
  dev = "ragg_png", # testo vettoriale (coerente con fig-format: svg)
  dpi = 144,
  out.width = "90%",
  fig.align = "center",
  fig.width = 6,
  fig.asp = 0.618, # rapporto aureo
  R.options = list(digits = 4, width = 76)
)

## ─────────────────────────────────────────────────────────────────────
## 7. Figure: font fallback + tema “umanistico” coerente con il testo
## ─────────────────────────────────────────────────────────────────────

# ——— Font serif preferita: Palatino (se disponibile), altrimenti ET Book, ecc.
fallback_serif <- {
  fams <- unique(systemfonts::system_fonts()$family)

  prefer <- c(
    # Palatino e varianti/alias noti
    "Palatino",
    "Palatino Linotype",
    "Palatino LT Std",
    "Palatino LT",
    "Palatino Nova",
    "URW Palladio L",
    "TeX Gyre Pagella",
    "Book Antiqua",
    # ET Book: nome usato come system font o come webfont nel CSS
    "ET Book",
    "et-book",
    # altri serif classici come ulteriori fallback
    "ETBembo",
    "EB Garamond",
    "Georgia",
    "Times New Roman"
  )

  hit <- prefer[prefer %in% fams]
  if (length(hit)) hit[[1]] else "serif"
}

# Tema ggplot “psico classic”
theme_psico_classic <- function(base_family = fallback_serif, base_size = 14) {
  base <- theme_minimal(base_size = base_size, base_family = base_family)
  base %+replace%
    theme(
      # Testo
      plot.title = element_text(
        face = "bold",
        margin = margin(b = 6),
        color = "#111"
      ),
      plot.subtitle = element_text(margin = margin(b = 8), color = "#222"),
      plot.caption = element_text(
        size = rel(0.9),
        face = "italic",
        color = "#444",
        margin = margin(t = 6)
      ),
      axis.title = element_text(margin = margin(t = 6), color = "#222"),
      axis.text = element_text(color = "#333"),
      strip.text = element_text(
        face = "bold",
        margin = margin(5, 5, 5, 5),
        color = "#222"
      ),

      # Griglie discrete “a filo”
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(linewidth = 0.2, colour = "#00000026"),
      panel.grid.major.y = element_line(linewidth = 0.25, colour = "#00000033"),

      # Assi “hairline”
      axis.line = element_line(linewidth = 0.3, colour = "#00000066"),
      axis.ticks = element_line(linewidth = 0.25, colour = "#00000080"),
      axis.ticks.length = unit(3, "pt"),

      # Pannello e facet
      panel.border = element_rect(
        fill = NA,
        colour = "#00000026",
        linewidth = 0.3
      ),
      panel.spacing = unit(10, "pt"),
      strip.background = element_rect(fill = "#0000000D", colour = NA),

      # Legenda “sopra” e compatta
      legend.position = "top",
      legend.justification = "left",
      legend.title = element_text(face = "bold"),
      legend.key.height = unit(10, "pt"),
      legend.key.width = unit(18, "pt"),

      # Posizionamento titoli/caption
      plot.title.position = "plot",
      plot.caption.position = "plot"
    )
}

# Applica il tema globale
theme_set(theme_psico_classic())

# Default geometrici “editoriali”
update_geom_defaults("point", list(size = 1.8, alpha = 0.9))
update_geom_defaults("line", list(linewidth = 0.4))
update_geom_defaults("segment", list(linewidth = 0.3))
update_geom_defaults("rect", list(color = "#00000040"))

# Palette Okabe–Ito (color-blind safe): scale pronte all'uso
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

# New helpers: drop black by default (common for fills)
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

# Uso tipico:
#   ggplot(df, aes(x, y, color = gruppo)) +
#   geom_line() +
#   scale_color_okabe_ito() +
#   labs(caption = "Nota: intervalli al 95% basati su posteriori gerarchici.")

# Etichette numeriche in stile italiano
label_it <- function(accuracy = NULL) {
  scales::label_number(accuracy = accuracy, decimal.mark = ",", big.mark = ".")
}

# Allinea bayesplot al tema
bayesplot::bayesplot_theme_set(theme_psico_classic(
  base_family = fallback_serif,
  base_size = 14
))
bayesplot::color_scheme_set(scheme = "blue") # oppure "viridis"

# Coerenza visiva con ggdist/tidybayes
options(
  ggdist.distributions_contour_color = "#00000033",
  ggdist.slab_fill = "#0072B210", # blu trasparente
  ggdist.interval_color = "#00000080"
)

# Patchwork: tag coerenti con figure multiple
options(plot.tag = "Figura ") # prefisso
options(plot.tag.position = "topleft") # posizione

# Scorciatoie frequenti
guides_top <- guides(
  color = guide_legend(nrow = 1, byrow = TRUE),
  fill = guide_legend(nrow = 1, byrow = TRUE)
)
thin_ygrid <- theme(panel.grid.major.x = element_blank())
thin_xgrid <- theme(panel.grid.major.y = element_blank())

# se vuoi legenda compatta sempre senza toccare i singoli plot:
theme_update(
  legend.spacing.y = unit(2, "pt"),
  legend.text = element_text(margin = margin(b = 2))
)

## ─────────────────────────────────────────────────────────────────────
## 8. Riproducibilità
## ─────────────────────────────────────────────────────────────────────
set.seed(42)

# =======================================================================
# Fine setup globale
# =======================================================================
