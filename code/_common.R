# Common Packages --------------------------------------------------------------

# Usa pacman per gestire automaticamente i pacchetti
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  here,         # Gestione dei percorsi relativi dei file
  rio,          # Importazione ed esportazione dati
  tidyverse,    # Raccolta di pacchetti per manipolazione e visualizzazione dati
  knitr,        # Supporto per la generazione di documenti, con integrazione LaTeX
  markdown,     # Conversione di markdown in HTML
  scales,       # Funzioni per formattare assi e scale nei grafici
  psych,        # Funzioni per analisi psicometriche
  bayesplot,    # Grafici diagnostici e visualizzazione per modelli bayesiani
  patchwork,    # Composizione di grafici ggplot
  gridExtra,    # Funzioni per layout a griglia
  see,          # Palette Okabe-Ito e altre utility
  tidyr,        # Funzionalità per creare tidy data
  ggokabeito,   # Scale qualitative Okabe-Ito per ggplot2
  MetBrewer     # Palette cromatiche ispirate all'arte
)

options(tidyverse.quiet = TRUE)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  width = 72,
  tidy.opts = list(width.cutoff = 72, tidy = TRUE),
  out.width = "70%",
  fig.align = "center",
  fig.width = 6,
  fig.height = 3.708, # Altezza calcolata usando il rapporto aureo
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
  scipen = 1, 
  digits = 3,
  ggplot2.continuous.colour = "turbo",
  ggplot2.continuous.fill = "turbo",
  show.signif.stars = FALSE,
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  stringr.view_n = 6,
  pillar.bold = TRUE,
  width = 77 # 80 caratteri meno 3 per il commento #>
)

# Theme Settings ---------------------------------------------------------------

# Imposta il tema predefinito di ggplot2 per bayesplot
theme_set(bayesplot::theme_default(base_size = 13, base_family = "sans"))

# Imposta lo schema cromatico per bayesplot
color_scheme_set("darkgray")

# Palette personalizzata basata su Okabe-Ito con un colore aggiuntivo
palette_okabe_enhanced <- c(
  ggokabeito::palette_okabe_ito(order = c(5, 1, 3, 4, 2, 6, 7, 8, 9)),
  "#882E72"
)

# Palette discrete con MetBrewer
scale_colour_discrete <- scale_color_manual(
  values = MetBrewer::met.brewer("Hiroshige", 10)
)
scale_fill_discrete <- scale_fill_manual(
  values = MetBrewer::met.brewer("Hiroshige", 10)
)

# Seed -------------------------------------------------------------------------

set.seed(42) # Fissa il seme per garantire la riproducibilità
