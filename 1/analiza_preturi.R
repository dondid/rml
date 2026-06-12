# ===============================================
# VARIANTA A: SUV-uri
# ===============================================

# 1. Crearea fișierului cu date SUV
suv_data <- data.frame(
  type = c("Compact SUV", "Mid-size SUV", "Full-size SUV", "Luxury SUV", 
           "Compact SUV", "Mid-size SUV", "Full-size SUV", "Luxury SUV",
           "Compact SUV", "Mid-size SUV"),
  engine = c("2.0L I4", "3.5L V6", "5.7L V8", "3.0L V6 Turbo",
             "1.5L I4 Turbo", "2.5L I4", "6.2L V8", "4.0L V8 Twin-Turbo",
             "2.0L I4 Hybrid", "3.6L V6"),
  fuel = c("Benzină", "Benzină", "Benzină", "Diesel",
           "Benzină", "Hibrid", "Benzină", "Benzină",
           "Hibrid", "Benzină"),
  year = c(2022, 2021, 2020, 2023, 2022, 2023, 2019, 2024, 2023, 2021),
  mileage = c(15000, 32000, 58000, 8000, 22000, 12000, 75000, 5000, 10000, 45000),
  price = c(28000, 35000, 32000, 65000, 25000, 42000, 28000, 95000, 38000, 30000)
)

# Salvare în fișier CSV
write.csv(suv_data, "suv_data.csv", row.names = FALSE)

cat("===== ANALIZA SUV-URI =====\n\n")

# Găsirea minimului și maximului de preț
min_price_suv <- min(suv_data$price)
max_price_suv <- max(suv_data$price)

min_suv <- suv_data[suv_data$price == min_price_suv, ]
max_suv <- suv_data[suv_data$price == max_price_suv, ]

cat("1. Prețul minim și caracteristicile SUV-ului:\n")
cat(sprintf("   Preț: %d EUR\n", min_price_suv))
print(min_suv)
cat("\n")

cat("   Prețul maxim și caracteristicile SUV-ului:\n")
cat(sprintf("   Preț: %d EUR\n", max_price_suv))
print(max_suv)
cat("\n")

# 2. Grafic: Mileage vs Price
png("suv_mileage_vs_price.png", width = 800, height = 600)
plot(suv_data$mileage, suv_data$price,
     main = "Relația între Kilometraj și Preț (SUV-uri)",
     xlab = "Kilometraj (km)",
     ylab = "Preț (EUR)",
     pch = 19,
     col = "steelblue",
     cex = 1.5)
abline(lm(price ~ mileage, data = suv_data), col = "red", lwd = 2)
grid()
dev.off()

cat("2. Grafic salvat: suv_mileage_vs_price.png\n\n")

# 3. Verificare preț peste prag
threshold_suv <- 35000
above_threshold_suv <- sum(suv_data$price > threshold_suv)

cat(sprintf("3. Număr de SUV-uri cu prețul peste %d EUR: %d\n\n", 
            threshold_suv, above_threshold_suv))

# 4. Statistici și grafice
mean_price_suv <- mean(suv_data$price)
sd_price_suv <- sd(suv_data$price)

cat("4. Statistici descriptive pentru prețuri SUV:\n")
cat(sprintf("   Media: %.2f EUR\n", mean_price_suv))
cat(sprintf("   Deviația standard: %.2f EUR\n\n", sd_price_suv))

# Boxplot
png("suv_boxplot.png", width = 600, height = 600)
boxplot(suv_data$price,
        main = "Boxplot - Prețuri SUV-uri",
        ylab = "Preț (EUR)",
        col = "lightblue",
        border = "darkblue")
text(1.3, mean_price_suv, sprintf("Media: %.0f", mean_price_suv), col = "red")
abline(h = mean_price_suv, col = "red", lty = 2)
dev.off()

cat("   Boxplot salvat: suv_boxplot.png\n")

# Violin plot (necesită vioplot package)
if (!require(vioplot)) {
  install.packages("vioplot")
  library(vioplot)
}

png("suv_violinplot.png", width = 600, height = 600)
vioplot(suv_data$price,
        col = "lightgreen",
        main = "Violin Plot - Prețuri SUV-uri",
        ylab = "Preț (EUR)")
dev.off()

cat("   Violin plot salvat: suv_violinplot.png\n\n")


# ===============================================
# VARIANTA B: Apartamente
# ===============================================

# 1. Crearea fișierului cu date apartamente
apt_data <- data.frame(
  location = c("Centru", "Centru", "Nord", "Sud", "Est", 
               "Vest", "Centru", "Nord", "Sud", "Est",
               "Vest", "Centru", "Nord", "Sud", "Est"),
  rooms = c(2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 1, 4, 2, 3, 2),
  surface = c(55, 75, 50, 95, 70, 48, 80, 52, 100, 68, 
              35, 110, 58, 72, 45),
  floor = c(3, 5, 2, 7, 4, 1, 6, 3, 8, 2, 
            4, 9, 1, 5, 2),
  bathrooms = c(1, 1, 1, 2, 1, 1, 2, 1, 2, 1, 
                1, 2, 1, 1, 1),
  dist_transport = c(0.2, 0.5, 0.8, 1.2, 0.6, 0.3, 0.4, 0.9, 1.5, 0.7,
                     0.25, 0.6, 1.0, 0.8, 0.5),
  price = c(95000, 125000, 75000, 155000, 98000, 68000, 135000, 78000, 
            165000, 92000, 55000, 185000, 82000, 105000, 72000)
)

# Salvare în fișier CSV
write.csv(apt_data, "apartment_data.csv", row.names = FALSE)

cat("\n===== ANALIZA APARTAMENTE =====\n\n")

# Găsirea minimului și maximului de preț
min_price_apt <- min(apt_data$price)
max_price_apt <- max(apt_data$price)

min_apt <- apt_data[apt_data$price == min_price_apt, ]
max_apt <- apt_data[apt_data$price == max_price_apt, ]

cat("1. Prețul minim și caracteristicile apartamentului:\n")
cat(sprintf("   Preț: %d EUR\n", min_price_apt))
print(min_apt)
cat("\n")

cat("   Prețul maxim și caracteristicile apartamentului:\n")
cat(sprintf("   Preț: %d EUR\n", max_price_apt))
print(max_apt)
cat("\n")

# 2. Grafic: Surface vs Price
png("apartment_surface_vs_price.png", width = 800, height = 600)
plot(apt_data$surface, apt_data$price,
     main = "Relația între Suprafață și Preț (Apartamente)",
     xlab = "Suprafață (m²)",
     ylab = "Preț (EUR)",
     pch = 19,
     col = "coral",
     cex = 1.5)
abline(lm(price ~ surface, data = apt_data), col = "darkred", lwd = 2)
grid()
dev.off()

cat("2. Grafic salvat: apartment_surface_vs_price.png\n\n")

# 3. Verificare preț peste prag
threshold_apt <- 100000
above_threshold_apt <- sum(apt_data$price > threshold_apt)

cat(sprintf("3. Număr de apartamente cu prețul peste %d EUR: %d\n\n", 
            threshold_apt, above_threshold_apt))

# 4. Statistici și grafice
mean_price_apt <- mean(apt_data$price)
sd_price_apt <- sd(apt_data$price)

cat("4. Statistici descriptive pentru prețuri apartamente:\n")
cat(sprintf("   Media: %.2f EUR\n", mean_price_apt))
cat(sprintf("   Deviația standard: %.2f EUR\n\n", sd_price_apt))

# Summary statistics
cat("   Summary statistics:\n")
print(summary(apt_data$price))
cat("\n")

# Boxplot
png("apartment_boxplot.png", width = 600, height = 600)
boxplot(apt_data$price,
        main = "Boxplot - Prețuri Apartamente",
        ylab = "Preț (EUR)",
        col = "lightcoral",
        border = "darkred")
text(1.3, mean_price_apt, sprintf("Media: %.0f", mean_price_apt), col = "blue")
abline(h = mean_price_apt, col = "blue", lty = 2)
dev.off()

cat("   Boxplot salvat: apartment_boxplot.png\n")

# Violin plot
png("apartment_violinplot.png", width = 600, height = 600)
vioplot(apt_data$price,
        col = "lightyellow",
        main = "Violin Plot - Prețuri Apartamente",
        ylab = "Preț (EUR)")
dev.off()

cat("   Violin plot salvat: apartment_violinplot.png\n\n")

# Grafic comparativ pentru analiză mai detaliată
png("apartment_price_by_rooms.png", width = 800, height = 600)
boxplot(price ~ rooms, data = apt_data,
        main = "Distribuția Prețurilor în Funcție de Numărul de Camere",
        xlab = "Număr de Camere",
        ylab = "Preț (EUR)",
        col = rainbow(length(unique(apt_data$rooms))))
dev.off()

cat("   Grafic bonus salvat: apartment_price_by_rooms.png\n")

cat("\n===== ANALIZA COMPLETĂ =====\n")
cat("Toate fișierele și graficele au fost generate cu succes!\n")
