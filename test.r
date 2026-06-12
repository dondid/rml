# Instalează pachetele necesare (decomentează dacă nu sunt instalate)
# install.packages(c("plotly", "htmltools"))

# Încarcă bibliotecile
library(plotly)

# Creează date pentru mai multe conuri pentru a face exemplul mai interesant
x <- c(0, 1, 2, 0, 1, 2)
y <- c(0, 0, 0, 1, 1, 1)
z <- c(0, 0, 0, 0, 0, 0)
u <- c(1, 0, -1, 1, 0, -1) # componenta x a vectorului
v <- c(1, 1, 1, -1, -1, -1) # componenta y a vectorului
w <- c(1, 2, 1, 1, 2, 1) # componenta z a vectorului

# Creează plot-ul cu conuri
fig <- plot_ly(
  type = "cone",
  x = x, y = y, z = z,
  u = u, v = v, w = w,
  colorscale = "Blues",
  showscale = TRUE,
  sizemode = "absolute",
  sizeref = 2
)

# Adaugă layout
fig <- fig %>% layout(
  title = "Vizualizare vectori 3D cu conuri",
  scene = list(
    aspectmode = "data",
    camera = list(
      eye = list(x = 1.5, y = 1.5, z = 1.2)
    ),
    xaxis = list(title = "Axa X"),
    yaxis = list(title = "Axa Y"),
    zaxis = list(title = "Axa Z")
  )
)

# METODA 1: Afișează graficul direct (funcționează în RStudio)
fig

# METODA 2: Deschide într-un browser web (recomandată pentru VS Code)
htmltools::browsable(fig)

# METODA 3: Salvează ca fișier HTML și deschide-l manual
# htmlwidgets::saveWidget(fig, "cone_plot.html", selfcontained = FALSE)
# browseURL("cone_plot.html")  # decomentează pentru a deschide fișierul
