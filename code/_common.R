# Common Packages --------------------------------------------------------------

# Utilizza pacman per gestire automaticamente i pacchetti
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  here, # Gestione dei percorsi relativi dei file
  rio, # Importare, esportare dati
  tidyverse, # Raccolta di pacchetti per manipolazione e visualizzazione dei dati
  knitr, # Supporto per la generazione di documenti, con integrazione LaTeX
  markdown, # Conversione di markdown in HTML
  scales, # Funzioni per formattare assi e scale nei grafici
  psych, # Funzioni per analisi psicometriche
  bayesplot, # Grafici diagnostici e di visualizzazione per modelli bayesiani
  patchwork, # Composizione di grafici ggplot
  gridExtra, # Funzioni per visualizzare layout a griglia
  see, # Provides palette_okabeito
  tidyr, # Funzionalità per creare tidy data
  ggokabeito # Qualitative Okabe-Ito Scales for ggplot2 
)

options(tidyverse.quiet = TRUE)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  width = 72,
  tidy.opts = list(width.cutoff = 72, tidy = TRUE),
  out.width = "70%",
  fig.align = "center",
  fig.width = 6,
  fig.height = 3.708, # width * 1 / phi (phi = golden ratio)
  fig.show = "hold",
  R.options = list(
    digits = 3,
    width = 76
  ),
  formatR.indent = 2,
  dplyr.summarise.inform = FALSE,
  dplyr.print_min = 5,
  dplyr.print_max = 5,
  ggrepel.max.overlaps = 100
)

options(
  show.signif.stars = FALSE,
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  stringr.view_n = 6,
  # Disattiva temporaneamente l'output CLI per Quarto
  # cli.num_colors = 0,
  # cli.hyperlink = FALSE,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 per il commento #>
)


# Theme Settings ---------------------------------------------------------------

# ggplot2::theme_set(ggplot2::theme_gray(12))
theme_set(bayesplot::theme_default(base_size = 13, base_family = "sans"))

color_scheme_set("brightblue") # bayesplot

# From https://osf.io/k824z
# Have to add a colour to the palette to be able to use 10 items
palette_okabe_enhanced <- 
  c(ggokabeito::palette_okabe_ito(order = c(5,1,3,4,2,6,7,8,9)), "#882E72")


# Seed -------------------------------------------------------------------------

set.seed(42) # Fissa il seme per la riproducibilità




