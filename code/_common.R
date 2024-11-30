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
  ggExtra, # Funzionalità extra per ggplot2 (grafici marginali)
  ggpubr, # Funzionalità di pubblicazione per grafici ggplot
  viridis, # Palette di colori per ggplot (ideale per scale percettivamente uniformi)
  MASS # Pacchetto per metodi statistici aggiuntivi
)

# Knitr Chunk Options ----------------------------------------------------------

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE,
  fig.retina = 2,
  fig.width = 6,
  fig.asp = 2/3,
  fig.show = "hold"
)

options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  stringr.view_n = 6,
  # Temporarily deactivate cli output for quarto
  cli.num_colors = 0,
  cli.hyperlink = FALSE,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 for #> comment
)

ggplot2::theme_set(ggplot2::theme_gray(12))

# Theme Settings ---------------------------------------------------------------

# theme_set(bayesplot::theme_default(base_size = 18, base_family = "sans"))

# Seed -------------------------------------------------------------------------

set.seed(42) # Fissa il seme per la riproducibilità
