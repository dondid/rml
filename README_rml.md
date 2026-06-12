<div align="center">

# 📊 rml

### R — Machine Learning & Vizualizare Date

**Master TAPI — Universitatea din Craiova, Facultatea de Științe**
**Ionuț-Daniel Dodoc · 2024–2026**

![R](https://img.shields.io/badge/R-4.x-276DC3?style=flat&logo=r&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-Vizualizare%203D-3F4F75?style=flat&logo=plotly&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-IDE-75AADB?style=flat&logo=rstudio&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Widgets-F7DF1E?style=flat&logo=javascript&logoColor=black)

</div>

---

## 📋 Cuprins

| Folder / Fișier | Descriere |
|-----------------|-----------|
| [1/](#1--analiză-prețuri) | Analiză prețuri apartamente și SUV-uri în R |
| [de proba/R/](#de-proba--experimente-r) | Experimente și vizualizări exploratorie |
| [test.r](#testr--vizualizare-3d-cu-conuri) | Vizualizare vectori 3D cu conuri — Plotly |
| [cone_plot.html](#cone_plothtml--output-interactiv) | Output HTML interactiv — grafic 3D cu conuri |

---

## 📁 Structura repo

```
rml/
├── 1/
│   └── analiza_preturi.R          — analiză prețuri apartamente & SUV-uri
│
├── de proba/R/
│   ├── proiest.R                  — script principal experimente
│   ├── apartment_data.csv         — date apartamente
│   ├── suv_data.csv               — date SUV-uri
│   ├── apartment_boxplot.png      — boxplot prețuri apartamente
│   ├── apartment_price_by_rooms.png — preț în funcție de camere
│   ├── apartment_surface_vs_price.png — suprafață vs preț
│   ├── apartment_violinplot.png   — violin plot apartamente
│   ├── suv_boxplot.png            — boxplot SUV-uri
│   ├── suv_mileage_vs_price.png   — kilometraj vs preț
│   └── suv_violinplot.png         — violin plot SUV-uri
│
├── cone_plot_files/               — dependențe HTML widget (Plotly, jQuery, crosstalk)
├── cone_plot.html                 — grafic interactiv 3D exportat
├── test.r                         — script vizualizare vectori 3D
├── package.json
└── package-lock.json
```

---

## 🔬 Detalii proiecte

### 1/ — Analiză Prețuri

Analiză statistică exploratorie pe date imobiliare și auto.

```r
# analiza_preturi.R
# - Încărcare și curățare date apartamente și SUV-uri
# - Statistici descriptive
# - Vizualizări comparative
```

**Date utilizate:**
- `apartment_data.csv` — prețuri apartamente (camere, suprafață, preț)
- `suv_data.csv` — prețuri SUV-uri (an, km, preț)

---

### de proba/ — Experimente R

Set complet de vizualizări generate cu `ggplot2` / `base R`:

| Grafic | Descriere |
|--------|-----------|
| `apartment_boxplot.png` | Distribuție prețuri pe categorii |
| `apartment_price_by_rooms.png` | Preț mediu în funcție de numărul de camere |
| `apartment_surface_vs_price.png` | Corelație suprafață — preț |
| `apartment_violinplot.png` | Distribuție densitate prețuri apartamente |
| `suv_boxplot.png` | Distribuție prețuri SUV-uri |
| `suv_mileage_vs_price.png` | Corelație kilometraj — preț |
| `suv_violinplot.png` | Distribuție densitate prețuri SUV-uri |

**Exemple grafice generate:**

> 📊 `apartment_surface_vs_price.png` — scatter plot suprafață vs preț

> 🎻 `apartment_violinplot.png` — violin plot distribuție prețuri

> 📦 `suv_boxplot.png` — boxplot prețuri SUV pe categorii

---

### test.r — Vizualizare 3D cu Conuri

Script de vizualizare vectori 3D folosind **Plotly cone charts**.

```r
library(plotly)

# Definire vectori 3D
x <- c(0, 1, 2, 0, 1, 2)
y <- c(0, 0, 0, 1, 1, 1)
z <- c(0, 0, 0, 0, 0, 0)
u <- c(1, 0, -1, 1, 0, -1)   # componenta X
v <- c(1, 1, 1, -1, -1, -1)  # componenta Y
w <- c(1, 2, 1, 1, 2, 1)     # componenta Z

fig <- plot_ly(type = "cone",
               x = x, y = y, z = z,
               u = u, v = v, w = w,
               colorscale = "Blues",
               sizemode = "absolute",
               sizeref = 2)
```

**Funcționalități demonstrate:**
- Reprezentare vectori în spațiu 3D
- Colorare după magnitudine (scala Blues)
- Export HTML interactiv pentru browser
- Compatibil RStudio și VS Code

---

### cone_plot.html — Output Interactiv

Graficul 3D generat din `test.r`, exportat ca fișier HTML standalone cu toate dependențele incluse (Plotly.js, jQuery, crosstalk).

Poate fi deschis direct în orice browser web fără a necesita R instalat.

---

## 🛠️ Instalare & Rulare

### Cerințe

```r
# Instalează pachetele necesare
install.packages(c("plotly", "htmltools", "htmlwidgets", "ggplot2"))
```

### Rulare scripturi

```r
# Vizualizare 3D conuri
source("test.r")

# Analiză prețuri
source("1/analiza_preturi.R")

# Experimente
source("de proba/R/proiest.R")
```

### Export HTML

```r
# Salvează graficul interactiv
htmlwidgets::saveWidget(fig, "cone_plot.html", selfcontained = FALSE)
browseURL("cone_plot.html")
```

---

## 📦 Pachete R utilizate

| Pachet | Scop |
|--------|------|
| `plotly` | Grafice interactive 3D |
| `ggplot2` | Vizualizări statistice |
| `htmltools` | Export HTML widgets |
| `htmlwidgets` | Salvare grafice ca HTML |

---

## 👤 Autor

**Ionuț-Daniel Dodoc**
Master TAPI — Tehnici Avansate pentru Prelucrarea Informației
Facultatea de Științe, Universitatea din Craiova

---

<div align="center">
<sub>Repository creat pentru uz academic · Laboratoare R & Machine Learning 2024–2026</sub>
</div>
