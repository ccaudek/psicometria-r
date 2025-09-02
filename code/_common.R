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
conflict_prefer("chisq.test", "stats")

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
  posterior.num_args = list(digits = 3) # Coordinato con CSS precision
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
## 4. COORDINAZIONE COLORI E VARIABILI CSS
## ─────────────────────────────────────────────────────────────────────

# Palette esatta dal CSS con conversione RGB precisa
css_palette <- list(
  # Colori principali dal :root CSS
  paper_warm = "#fdfcf8", # --bs-body-bg
  paper_cream = "#f8f6f0", # --paper-cream (per sfondi delicati)
  text_primary = "#2d2926", # --bs-body-color (inchiostro seppia scuro)
  text_secondary = "#5d5349", # --bs-secondary-color
  text_muted = "#8b8680", # --bs-muted-color
  accent_warm = "#8B4513", # --accent-warm (marrone sella)
  accent_light = "#A0522D", # --accent-light (sienna per rubriche)

  # Colori derivati per bordi e effetti
  border_warm = "#2d292633", # color-mix(in srgb, #2d2926 20%, transparent)
  border_light = "#2d29261f", # color-mix(in srgb, #2d2926 12%, transparent)
  shadow_subtle = "#0000000a", # rgba(0, 0, 0, 0.03)

  # Colori enhanced dal CSS avanzato
  ink_primary = "#1a1611", # Deep warm black
  ink_secondary = "#3d342a", # Warm dark brown
  ink_tertiary = "#6b5b4a", # Medium brown
  rubric_red = "#a0522d", # Sienna per enfasi
  illumination_blue = "#4a5568" # Muted blue per accenti
)

# Funzione per convertire hex in RGB per mix-color CSS-like
color_mix_rgb <- function(color1, color2, percentage) {
  col1_rgb <- col2rgb(color1)[, 1]
  col2_rgb <- col2rgb(color2)[, 1]
  mixed_rgb <- round(
    col1_rgb * (percentage / 100) + col2_rgb * (1 - percentage / 100)
  )
  rgb(mixed_rgb[1], mixed_rgb[2], mixed_rgb[3], maxColorValue = 255)
}

## ─────────────────────────────────────────────────────────────────────
## 5. TIPOGRAFIA - Coordinazione con stack CSS
## ─────────────────────────────────────────────────────────────────────

# ── 5. TIPOGRAFIA - Selezione robusta del serif coerente col CSS ───────────────

# Ritorna un family name ESATTO presente in systemfonts::system_fonts()
locate_serif_family <- function() {
  sf <- systemfonts::system_fonts()

  # Elenco di preferenze (in ordine): personalizza come vuoi
  prefer <- c(
    "Palatino nova Pro", # tua prima scelta (se registrata)
    "Palatino", # macOS: /System/Library/Fonts/Palatino.ttc
    "Palatino Linotype", # spesso su Windows
    "Georgia"
  )

  # normalizza per confronto case-insensitive
  fams <- unique(sf$family)

  for (p in prefer) {
    hit <- fams[grepl(paste0("^", p, "$"), fams, ignore.case = TRUE)]
    if (length(hit) > 0) return(hit[1])
  }

  # fallback finale
  "serif"
}

# Se vuoi registrare manualmente Palatino nova Pro (se hai i file .ttf/.otf),
# fallo QUI prima di chiamare locate_serif_family():
# systemfonts::register_font(
#   name = "Palatino nova Pro",
#   plain = "/percorso/PalatinoNovaPro-Regular.ttf",
#   italic = "/percorso/PalatinoNovaPro-Italic.ttf",
#   bold = "/percorso/PalatinoNovaPro-Bold.ttf",
#   bolditalic = "/percorso/PalatinoNovaPro-BoldItalic.ttf"
# )

renaissance_serif <- locate_serif_family()
message("Font serif selezionato per i grafici: ", renaissance_serif)


## ─────────────────────────────────────────────────────────────────────
## 6. TEMA GGPLOT2 - Perfetta integrazione con CSS
## ─────────────────────────────────────────────────────────────────────

theme_manuscript <- function(
  base_family = renaissance_serif,
  base_size = 16.5 # Coordinato con CSS font-size-root: 19px * 0.9
) {
  # Calcolo delle dimensioni basato su scala CSS
  scale_minor_third <- 1.2
  scale_major_third <- 1.25
  scale_perfect_fourth <- 1.333

  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # Sfondo coordinato esattamente con CSS
      plot.background = element_rect(
        fill = css_palette$paper_warm,
        color = NA
      ),
      panel.background = element_rect(
        fill = css_palette$paper_warm,
        color = NA
      ),

      # Tipografia che replica la gerarchia CSS h1-h6
      plot.title = element_text(
        family = base_family,
        face = "plain",
        size = base_size * scale_perfect_fourth^2, # h1-size equivalente
        color = css_palette$text_primary,
        margin = margin(b = 12),
        lineheight = 1.2
      ),

      plot.subtitle = element_text(
        family = base_family,
        face = "italic",
        size = base_size * scale_major_third, # h2-size equivalente
        color = css_palette$text_secondary,
        margin = margin(b = 10),
        lineheight = 1.4
      ),

      plot.caption = element_text(
        family = base_family,
        size = base_size * 0.9, # Leggermente ridotto
        face = "italic",
        color = css_palette$text_muted,
        hjust = 0,
        margin = margin(t = 15),
        lineheight = 1.5
      ),

      # Assi con colori CSS esatti
      axis.title = element_text(
        size = base_size * 0.95,
        color = css_palette$text_primary,
        family = base_family,
        face = "plain",
        margin = margin(8)
      ),

      axis.text = element_text(
        size = base_size * 0.87,
        color = css_palette$text_secondary,
        family = base_family
      ),

      # Griglia che replica i bordi CSS
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(
        color = css_palette$border_light,
        linewidth = 0.3,
        linetype = "solid"
      ),

      # Bordi panel coordinati con tabelle CSS
      panel.border = element_rect(
        fill = NA,
        color = css_palette$border_warm,
        linewidth = 0.5
      ),

      # Facet che replica .callout/.figure styling
      strip.background = element_rect(
        fill = css_palette$paper_cream,
        color = css_palette$border_warm,
        linewidth = 0.3
      ),

      strip.text = element_text(
        size = base_size * 0.92,
        color = css_palette$text_primary,
        family = base_family,
        face = "plain",
        margin = margin(6, 8, 6, 8)
      ),

      # Legenda con spaziatura CSS
      legend.position = "bottom",
      legend.justification = "center",
      legend.title = element_text(
        face = "plain",
        size = base_size * 0.92,
        color = css_palette$text_primary,
        family = base_family
      ),
      legend.text = element_text(
        size = base_size * 0.87,
        color = css_palette$text_secondary,
        family = base_family,
        margin = margin(r = 10, t = 2, b = 2)
      ),
      legend.spacing.y = unit(4, "pt"),
      legend.margin = margin(t = 18),

      # Asse con tick style CSS
      axis.line = element_line(
        color = css_palette$border_warm,
        linewidth = 0.4
      ),

      axis.ticks = element_line(
        color = css_palette$border_warm,
        linewidth = 0.3
      ),

      axis.ticks.length = unit(5, "pt"),

      # Spaziatura coordinata con CSS --space-*
      panel.spacing = unit(15, "pt"), # --space-sm equivalente
      plot.margin = margin(t = 25, r = 25, b = 20, l = 20),

      # Posizionamento titoli
      plot.title.position = "plot",
      plot.caption.position = "plot"
    )
}

# Applica il tema globalmente
theme_set(theme_manuscript())

theme_set(theme_manuscript(base_family = renaissance_serif))

# Forza il family di default del testo in ggplot (utile per geoms testuali)
theme_update(text = element_text(family = renaissance_serif))


## ─────────────────────────────────────────────────────────────────────
## 7. PALETTE COLORI — Colorblind-safe e coerenti con il CSS
## ─────────────────────────────────────────────────────────────────────

# NOTA: evitiamo il nero/nero-antico per i dati (lo teniamo per testi/assi se serve).
# Base colorblind-safe (Okabe–Ito) + coerenza con i tuoi brand colors.
# Ordine pensato per massimizzare distinguibilità in dicromatismo rosso–verde.

palette_cb_main <- c(
  blue = "#0072B2", # OI Blue
  orange = "#E69F00", # OI Orange
  sky = "#56B4E9", # OI Sky
  purple = "#CC79A7", # OI Reddish purple
  teal = "#009E73", # OI Bluish green (ok, ma evita confronti diretti col rosso saturo)
  brand_blue = css_palette$illumination_blue, # tuo blu ardesia
  sienna = css_palette$accent_light, # tua sienna (arancio/marrone)
  grey = "#7F7F7F" # neutro al posto del nero
)

# Per retro-compatibilità con le tue funzioni scale_*_manuscript():
manuscript_palette <- unname(palette_cb_main)

# Scala monocromatica neutra (NO nero)
sepia_scale <- c(
  "#6B5B4A",
  color_mix_rgb("#6B5B4A", css_palette$paper_warm, 75),
  color_mix_rgb("#6B5B4A", css_palette$paper_warm, 85),
  color_mix_rgb("#6B5B4A", css_palette$paper_warm, 92),
  color_mix_rgb("#6B5B4A", css_palette$paper_warm, 97)
)

# Sequenziali (colorblind-safe)
seq_blue_pal <- grDevices::colorRampPalette(c(
  "#EAF3FB",
  "#56B4E9",
  "#1F5A89",
  "#003B66"
))
seq_orange_pal <- grDevices::colorRampPalette(c(
  "#FFF4DF",
  "#F2C66A",
  "#E69F00",
  "#9A6A00"
))

# Divergente (blu ↔ arancio) con carta al centro
div_blue_orange_pal <- grDevices::colorRampPalette(c(
  "#0072B2",
  css_palette$paper_warm,
  "#E69F00"
))

# ── Scale wrapper (discrete) coerenti col tema ─────────────────────────
scale_color_manuscript <- function(..., na.value = "#BFBFBF", drop = FALSE) {
  ggplot2::scale_color_manual(
    values = manuscript_palette,
    ...,
    na.value = na.value,
    drop = drop
  )
}
scale_fill_manuscript <- function(..., na.value = "#BFBFBF", drop = FALSE) {
  ggplot2::scale_fill_manual(
    values = manuscript_palette,
    ...,
    na.value = na.value,
    drop = drop
  )
}

# Sepia (discrete) per compatibilità API precedente
scale_color_sepia <- function(..., na.value = "#BFBFBF", drop = FALSE) {
  ggplot2::scale_color_manual(
    values = sepia_scale,
    ...,
    na.value = na.value,
    drop = drop
  )
}
scale_fill_sepia <- function(..., na.value = "#BFBFBF", drop = FALSE) {
  ggplot2::scale_fill_manual(
    values = sepia_scale,
    ...,
    na.value = na.value,
    drop = drop
  )
}

# ── Gradienti (continui) ───────────────────────────────────────────────
scale_color_seq_blue <- function(..., limits = NULL)
  ggplot2::scale_color_gradientn(
    colors = seq_blue_pal(256),
    ...,
    limits = limits
  )
scale_fill_seq_blue <- function(..., limits = NULL)
  ggplot2::scale_fill_gradientn(
    colors = seq_blue_pal(256),
    ...,
    limits = limits
  )
scale_color_seq_orange <- function(..., limits = NULL)
  ggplot2::scale_color_gradientn(
    colors = seq_orange_pal(256),
    ...,
    limits = limits
  )
scale_fill_seq_orange <- function(..., limits = NULL)
  ggplot2::scale_fill_gradientn(
    colors = seq_orange_pal(256),
    ...,
    limits = limits
  )

# Divergente (continua)
scale_color_div_blue_orange <- function(..., limits = NULL)
  ggplot2::scale_color_gradientn(
    colors = div_blue_orange_pal(256),
    ...,
    limits = limits
  )
scale_fill_div_blue_orange <- function(..., limits = NULL)
  ggplot2::scale_fill_gradientn(
    colors = div_blue_orange_pal(256),
    ...,
    limits = limits
  )


## ─────────────────────────────────────────────────────────────────────
## 8. DEFAULTS GEOMETRICI - Coordinati con CSS styling
## ─────────────────────────────────────────────────────────────────────

# Aggiorna i defaults per coordinare con lo stile CSS
update_geom_defaults(
  "point",
  list(
    size = 2.5,
    alpha = 0.85,
    stroke = 0.4,
    color = palette_cb_main[["grey"]] # prima: css_palette$text_primary
  )
)

update_geom_defaults(
  "line",
  list(
    linewidth = 0.7,
    color = palette_cb_main[["brand_blue"]], # prima: css_palette$text_primary
    alpha = 0.9
  )
)

update_geom_defaults(
  "segment",
  list(
    linewidth = 0.5,
    color = css_palette$text_secondary,
    alpha = 0.8
  )
)

update_geom_defaults(
  "rect",
  list(
    color = css_palette$border_warm,
    fill = css_palette$paper_cream,
    alpha = 0.7
  )
)

update_geom_defaults(
  "text",
  list(
    family = renaissance_serif,
    color = css_palette$text_primary,
    size = 3.8
  )
)

update_geom_defaults(
  "bar",
  list(
    fill = css_palette$accent_warm,
    color = css_palette$paper_warm,
    alpha = 0.85,
    linewidth = 0.3
  )
)

# Densità e stat_bin per histogram coordinati con figure CSS
update_geom_defaults(
  "density",
  list(
    fill = palette_cb_main[["sky"]], # prima: css_palette$text_secondary
    color = palette_cb_main[["blue"]], # prima: css_palette$text_primary
    alpha = 0.55,
    linewidth = 0.7
  )
)

update_stat_defaults(
  "bin",
  list(
    fill = css_palette$text_secondary,
    color = css_palette$paper_warm,
    alpha = 0.75,
    linewidth = 0.2,
    bins = 30
  )
)

## ─────────────────────────────────────────────────────────────────────
## 9. KNITR - Settings coordinati con CSS figure styling
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
  dpi = 200,
  out.width = "85%",
  fig.align = "center",
  fig.asp = 0.618,
  fig.width = 7,
  fig.height = 4.33,
  dev.args = list(
    background = css_palette$paper_warm # <- corretto per ragg
  ),
  R.options = list(
    digits = 3,
    width = 80,
    scipen = 4
  )
)

## ─────────────────────────────────────────────────────────────────────
## 10. TABELLE - Styling coordinato con CSS table rules
## ─────────────────────────────────────────────────────────────────────

library(tinytable)

# Opzioni coordinated con il CSS table styling
options(
  tinytable_format_num_fmt = "significant_cell",
  tinytable_format_digits = 3,
  tinytable_tt_digits = 3,
  tinytable_theme = "void"
)

# CSS personalizzato che replica esattamente lo styling delle tabelle
tabella_css_manuscript <- function(data, caption = NULL, note = NULL) {
  tt(data) %>%
    style_tt(
      # Font coordinato con CSS
      family = renaissance_serif,
      fontsize = "0.95em",

      # Colori header che replicano thead th CSS
      background = list(
        "tinytable_header" = css_palette$ink_secondary
      ),

      color = list(
        "tinytable_header" = css_palette$paper_warm,
        "tinytable_body" = css_palette$text_primary
      ),

      # Bordi coordinati con CSS table rules
      line_color = css_palette$border_warm,
      line_width = 0.5
    ) %>%

    # Formattazione numeri italiana
    format_tt(
      digits = 3,
      num_fmt = function(x) format(x, decimal.mark = ",", big.mark = ".")
    ) %>%

    # Aggiunta caption se presente
    {
      if (!is.null(caption)) {
        group_tt(., j = list(caption = 1:ncol(data)), caption = caption)
      } else .
    } %>%

    # Aggiunta nota se presente
    {
      if (!is.null(note)) {
        footnote(., note, i = nrow(data))
      } else .
    }
}

## ─────────────────────────────────────────────────────────────────────
## 11. CONFIGURAZIONI BAYESIANE - Coordinate con l'estetica CSS
## ─────────────────────────────────────────────────────────────────────

# Tema predefinito di bayesplot (indipendente dal tuo ggplot theme globale)
bayesplot::bayesplot_theme_set(bayesplot::theme_default())

# Schema colori predefinito
bayesplot::color_scheme_set("darkgray")

## ─────────────────────────────────────────────────────────────────────
## 12. FUNZIONI HELPER - Coordinate con utilità CSS
## ─────────────────────────────────────────────────────────────────────

# Modificatori tema che replicano le CSS utility classes
griglia_sottile_y <- theme(
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank()
)

griglia_sottile_x <- theme(
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank()
)

nessuna_griglia <- theme(panel.grid = element_blank())

# Posizioni legenda coordinate con CSS
legenda_in_alto <- theme(
  legend.position = "top",
  legend.justification = "center",
  legend.margin = margin(b = 15)
)

legenda_destra <- theme(
  legend.position = "right",
  legend.justification = "top",
  legend.margin = margin(l = 15)
)

# Funzione per ombreggiature che replica CSS box-shadow
ombra_figure <- theme(
  panel.border = element_rect(
    color = css_palette$border_warm,
    fill = NA,
    linewidth = 0.5
  ),
  plot.background = element_rect(
    fill = css_palette$paper_warm,
    color = NA
  )
)

# Annotazioni nel stile delle note CSS
aggiungi_nota_manuscritta <- function(plot, nota, posizione = "caption") {
  if (posizione == "caption") {
    plot +
      labs(caption = paste("Nota:", nota)) +
      theme(
        plot.caption = element_text(
          hjust = 0,
          family = renaissance_serif,
          face = "italic",
          size = rel(0.85),
          color = css_palette$text_muted,
          lineheight = 1.4
        )
      )
  } else {
    plot +
      labs(subtitle = nota) +
      theme(
        plot.subtitle = element_text(
          face = "italic",
          size = rel(0.92),
          color = css_palette$text_secondary,
          lineheight = 1.4,
          margin = margin(b = 12)
        )
      )
  }
}

# Formattazione italiana coordinata con CSS
formato_italiano <- function(accuracy = 0.01, scale = 1) {
  scales::label_number(
    accuracy = accuracy,
    scale = scale,
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

## ─────────────────────────────────────────────────────────────────────
## 13. CONFIGURAZIONI FINALI
## ─────────────────────────────────────────────────────────────────────

# Impostazioni console coordinate con CSS readability
library(pillar)
options(
  pillar.negative = FALSE,
  pillar.subtle = FALSE,
  pillar.bold = TRUE,
  pillar.width = Inf,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  tibble.width = Inf,
  width = 80, # Coordinato con text wrapping
  scipen = 4,
  digits = 3, # Precisione coordinata
  show.signif.stars = FALSE
)

# Patchwork coordinato con figure CSS
patchwork_theme_manuscript <- theme_manuscript() +
  theme(
    plot.tag = element_text(
      size = rel(1.05),
      face = "plain",
      color = css_palette$text_primary,
      family = renaissance_serif,
      hjust = 0
    ),
    plot.tag.position = c(0.02, 0.98)
  )

options(
  patchwork.annotation.theme = patchwork_theme_manuscript
)

# Aggiornamento globale theme per coordinate tutte le geometrie
theme_update(
  legend.spacing.y = unit(4, "pt"),
  legend.text = element_text(margin = margin(b = 3, r = 8)),
  legend.key.spacing.y = unit(3, "pt"),
  legend.key.size = unit(12, "pt")
)

# if (!requireNamespace("colorspace", quietly = TRUE)) install.packages("colorspace")
# colorspace::swatchplot(list(
#   main   = manuscript_palette,
#   deutan = colorspace::simulate_cvd(manuscript_palette, "deutan"),
#   protan = colorspace::simulate_cvd(manuscript_palette, "protan")
#), off = 0.02)

conflicts_prefer(ggplot2::theme_void)
