# ==============================================================================
# TYTU£: Zajecia_2_Data_Science_workflow_Czytelne_wykresy.R
# OPIS: Minimalny workflow analityczny pracy z danymi z 7 czytelnymi wykresami
# AUTOR: Natalia Liszniañska
# ==============================================================================

# ------------------------------------------------------------------------------
# SEKCJA 0: Instalacja i ³adowanie pakietów ----
# ------------------------------------------------------------------------------
pakiety <- c("readxl", "dplyr", "ggplot2", "writexl", "scales")
for(p in pakiety){
  if(!require(p, character.only = TRUE)){
    install.packages(p, dependencies = TRUE)
    library(p, character.only = TRUE)
  }
}

# ------------------------------------------------------------------------------
# SEKCJA 1: Import danych ----
# ------------------------------------------------------------------------------
setwd("C:/Users/nl469254/Downloads")
kraje_1 <- read.csv("kraje_makro_1.csv")
kraje_2 <- read.csv("kraje_makro_2.csv")

# ------------------------------------------------------------------------------
# SEKCJA 2: Przygotowanie danych ----
# ------------------------------------------------------------------------------
kraje_1$X <- NULL
kraje_2$X <- NULL
colnames(kraje_2) <- c("Kod_kraju", "Nazwa", "Region", "Urbanizacja_proc.", "Internet_proc.")
kraje_2$Region <- gsub("&", "and", kraje_2$Region)
kraje_2$Region <- as.factor(kraje_2$Region)

# ------------------------------------------------------------------------------
# SEKCJA 3: Scalanie danych ----
# ------------------------------------------------------------------------------
kraje <- merge(kraje_1, kraje_2, by.x = "Kod", by.y = "Kod_kraju")
kraje$Nazwa <- NULL

# ------------------------------------------------------------------------------
# SEKCJA 4: Podstawowa analiza danych ----
# ------------------------------------------------------------------------------
kraje <- kraje %>%
  mutate(Populacja_mln = Populacja / 1e6,
         PKB_per_capita = PKB / Populacja)

analiza_regiony <- kraje %>%
  group_by(Region) %>%
  summarise(
    liczba_krajow = n(),
    sredni_internet = mean(Internet_proc., na.rm = TRUE),
    srednia_urbanizacja = mean(Urbanizacja_proc., na.rm = TRUE)
  ) %>%
  arrange(desc(sredni_internet))
print(analiza_regiony)

# ------------------------------------------------------------------------------
# SEKCJA 5: Wizualizacja danych (7 czytelnych wykresów) ----
# ------------------------------------------------------------------------------
library(ggplot2)
library(scales)

# Wykres 1: Urbanizacja a PKB per capita (czytelne punkty)
ggplot(kraje, aes(x = Urbanizacja_proc., y = PKB_per_capita, color = Region)) +
  geom_point(size = 4, alpha = 0.8) +
  scale_y_log10(labels = comma) +
  labs(title = "Urbanizacja a PKB per capita",
       x = "Urbanizacja (%)",
       y = "PKB per capita (USD, skala log)",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Wykres 2: Liczba krajów w regionach
ggplot(kraje, aes(x = Region)) +
  geom_bar(fill = "steelblue", alpha = 0.8) +
  coord_flip() +
  labs(title = "Liczba krajów w regionach œwiata") +
  theme_minimal()

# Wykres 3: Populacja a PKB z rozmiarem punktu = PKB per capita
ggplot(kraje, aes(x = Populacja_mln, y = PKB, size = PKB_per_capita, color = Region)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  scale_y_log10(labels = comma) +
  labs(title = "Skala gospodarki i demografia",
       x = "Populacja (mln, log10)",
       y = "PKB (USD, log10)",
       size = "PKB per capita") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Wykres 4: Histogram PKB per capita
ggplot(kraje, aes(x = PKB_per_capita)) +
  geom_histogram(fill = "orange", bins = 30, alpha = 0.8) +
  scale_x_log10(labels = comma) +
  labs(title = "Rozk³ad PKB per capita",
       x = "PKB per capita (USD, log10)",
       y = "Liczba krajów") +
  theme_minimal()

# Wykres 5: Boxplot PKB per capita wg regionu
ggplot(kraje, aes(x = Region, y = PKB_per_capita, fill = Region)) +
  geom_boxplot(alpha = 0.7) +
  scale_y_log10(labels = comma) +
  labs(title = "PKB per capita wg regionów",
       x = "Region",
       y = "PKB per capita (USD, log10)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

# Wykres 6: Urbanizacja vs Internet access
ggplot(kraje, aes(x = Urbanizacja_proc., y = Internet_proc., color = Region)) +
  geom_point(size = 3, alpha = 0.8) +
  labs(title = "Urbanizacja a dostêp do Internetu",
       x = "Urbanizacja (%)",
       y = "Dostêp do Internetu (%)",
       color = "Region") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Wykres 7: Œredni PKB per capita vs œrednia urbanizacja w regionach
ggplot(analiza_regiony, aes(x = srednia_urbanizacja, y = sredni_internet, label = Region)) +
  geom_point(color = "darkgreen", size = 5, alpha = 0.7) +
  geom_text(vjust = -0.5, size = 4) +
  labs(title = "Œredni poziom urbanizacji a œredni dostêp do Internetu w regionach",
       x = "Œrednia urbanizacja (%)",
       y = "Œredni dostêp do Internetu (%)") +
  theme_minimal()

# ------------------------------------------------------------------------------
# SEKCJA 6: Eksport danych ----
# ------------------------------------------------------------------------------
write.csv(kraje, "kraje_analiza_final.csv", row.names = FALSE)
write_xlsx(kraje, "Zajecia_2_wyniki.xlsx")

print("Skrypt wykonany pomyœlnie! Pliki zosta³y zapisane w folderze roboczym.")