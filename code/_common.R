# =======================================================================
# _common.R - Setup globale per i file .qmd del manuale Bayes per psicologi
# Carica pacchetti comuni, imposta backend, opzioni grafiche e tabelle uniformi
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
conflicts_prefer(stats::var)
conflicts_prefer(stats::sd)

## ─────────────────────────────────────────────────────────────────────
## 2. Pacchetti per analisi bayesiana
## ─────────────────────────────────────────────────────────────────────
library(brms) # modellazione Bayesiana ad alto livello
library(rstan) # backend Stan; usato da brms e diagnostica
library(loo) # model comparison (ELPD, LOO-CV)
library(posterior) # oggetti draws e funzioni diagnostiche
library(priorsense) # diagnostica dei prior
library(reliabilitydiag) # diagnostica di calibratura predittiva

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
library(conflicted)

# Tema uniforme leggibile per tutte le figure
theme_set(bayesplot::theme_default(base_family = "serif", base_size = 14))

# Palette base (3 colori Set1), con nomi mnemonici
palette_set1 <- RColorBrewer::brewer.pal(3, "Set1")
names(palette_set1) <- c("uno", "due", "tre")

conflict_prefer("filter", "dplyr") # Always use dplyr::filter
conflict_prefer("select", "dplyr") # Always use dplyr::select

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
## 6. Opzioni globali knitr
## ─────────────────────────────────────────────────────────────────────
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  echo = TRUE,
  eval = TRUE,
  error = FALSE,
  out.width = "70%",
  fig.align = "center",
  fig.width = 6,
  fig.asp = 0.618, # rapporto aureo
  R.options = list(digits = 4, width = 76)
)

## ─────────────────────────────────────────────────────────────────────
## 7. Riproducibilità
## ─────────────────────────────────────────────────────────────────────
set.seed(42)

# =======================================================================
# Fine setup globale
# =======================================================================
