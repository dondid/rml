# ===============================================
# APLICAȚIE SHINY - ANALIZA PREȚURI INTERACTIVE
# ===============================================

# Instalează și încarcă pachetele necesare
packages <- c("shiny", "shinydashboard", "DT", "ggplot2", "plotly", 
              "vioplot", "shinyWidgets", "fresh")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# ===============================================
# DATE INIȚIALE
# ===============================================

# Date SUV-uri
suv_initial <- data.frame(
  Type = c("Compact SUV", "Mid-size SUV", "Full-size SUV", "Luxury SUV", 
           "Compact SUV", "Mid-size SUV", "Full-size SUV", "Luxury SUV",
           "Compact SUV", "Mid-size SUV"),
  Engine = c("2.0L I4", "3.5L V6", "5.7L V8", "3.0L V6 Turbo",
             "1.5L I4 Turbo", "2.5L I4", "6.2L V8", "4.0L V8 Twin-Turbo",
             "2.0L I4 Hybrid", "3.6L V6"),
  Fuel = c("Benzină", "Benzină", "Benzină", "Diesel",
           "Benzină", "Hibrid", "Benzină", "Benzină",
           "Hibrid", "Benzină"),
  Year = c(2022, 2021, 2020, 2023, 2022, 2023, 2019, 2024, 2023, 2021),
  Mileage = c(15000, 32000, 58000, 8000, 22000, 12000, 75000, 5000, 10000, 45000),
  Price = c(28000, 35000, 32000, 65000, 25000, 42000, 28000, 95000, 38000, 30000)
)

# Date Apartamente
apt_initial <- data.frame(
  Location = c("Centru", "Centru", "Nord", "Sud", "Est", 
               "Vest", "Centru", "Nord", "Sud", "Est",
               "Vest", "Centru", "Nord", "Sud", "Est"),
  Rooms = c(2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 1, 4, 2, 3, 2),
  Surface = c(55, 75, 50, 95, 70, 48, 80, 52, 100, 68, 
              35, 110, 58, 72, 45),
  Floor = c(3, 5, 2, 7, 4, 1, 6, 3, 8, 2, 4, 9, 1, 5, 2),
  Bathrooms = c(1, 1, 1, 2, 1, 1, 2, 1, 2, 1, 1, 2, 1, 1, 1),
  Dist_Transport = c(0.2, 0.5, 0.8, 1.2, 0.6, 0.3, 0.4, 0.9, 1.5, 0.7,
                     0.25, 0.6, 1.0, 0.8, 0.5),
  Price = c(95000, 125000, 75000, 155000, 98000, 68000, 135000, 78000, 
            165000, 92000, 55000, 185000, 82000, 105000, 72000)
)

# ===============================================
# INTERFAȚA UTILIZATOR (UI)
# ===============================================

ui <- dashboardPage(
  skin = "blue",
  
  # Header
  dashboardHeader(
    title = "📊 Analiza Prețuri Pro",
    titleWidth = 280
  ),
  
  # Sidebar
  dashboardSidebar(
    width = 280,
    sidebarMenu(
      id = "tabs",
      menuItem("🏠 Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("📋 Date & Tabel", tabName = "data", icon = icon("table")),
      menuItem("➕ Adaugă Date", tabName = "add_data", icon = icon("plus-circle")),
      menuItem("✏️ Modifică/Șterge", tabName = "edit_data", icon = icon("edit")),
      menuItem("📈 Grafice Interactive", tabName = "plots", icon = icon("chart-line")),
      menuItem("📊 Statistici", tabName = "stats", icon = icon("calculator")),
      menuItem("🔍 Filtrare & Căutare", tabName = "filter", icon = icon("filter")),
      menuItem("💾 Import/Export", tabName = "import_export", icon = icon("file"))
    ),
    
    hr(),
    
    # Selector tip date
    selectInput("data_type", 
                "📦 Tip Date:",
                choices = c("SUV-uri" = "suv", "Apartamente" = "apt"),
                selected = "apt"),
    
    hr(),
    
    # Info box
    box(
      width = 12,
      background = "light-blue",
      p(icon("info-circle"), strong(" Info:"), style = "margin-bottom: 5px;"),
      p("Aplicație completă pentru analiza și gestionarea datelor de prețuri.", 
        style = "font-size: 11px; margin: 0;")
    )
  ),
  
  # Body
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #f4f6f9; }
        .box { border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .small-box { border-radius: 8px; }
        .nav-tabs-custom { border-radius: 8px; }
        .dataTables_wrapper { font-size: 13px; }
        .btn { border-radius: 5px; margin: 2px; }
        .shiny-input-container { margin-bottom: 10px; }
        h3, h4 { color: #3c8dbc; font-weight: 600; }
      "))
    ),
    
    tabItems(
      # ===== TAB 1: DASHBOARD =====
      tabItem(
        tabName = "dashboard",
        fluidRow(
          valueBoxOutput("total_items", width = 3),
          valueBoxOutput("avg_price", width = 3),
          valueBoxOutput("min_price", width = 3),
          valueBoxOutput("max_price", width = 3)
        ),
        
        fluidRow(
          box(
            title = "📈 Vizualizare Rapidă Prețuri",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            plotlyOutput("dashboard_plot", height = "350px")
          ),
          
          box(
            title = "📊 Distribuție Prețuri",
            status = "info",
            solidHeader = TRUE,
            width = 4,
            plotOutput("dashboard_hist", height = "350px")
          )
        ),
        
        fluidRow(
          box(
            title = "🎯 Produs cu Preț Minim",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            tableOutput("min_product_table")
          ),
          
          box(
            title = "🎯 Produs cu Preț Maxim",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            tableOutput("max_product_table")
          )
        )
      ),
      
      # ===== TAB 2: DATE & TABEL =====
      tabItem(
        tabName = "data",
        fluidRow(
          box(
            title = "📋 Tabel Complet de Date",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("data_table")
          )
        ),
        
        fluidRow(
          box(
            title = "📑 Sumar Date",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            verbatimTextOutput("data_summary")
          )
        )
      ),
      
      # ===== TAB 3: ADAUGĂ DATE =====
      tabItem(
        tabName = "add_data",
        fluidRow(
          box(
            title = "➕ Adaugă Înregistrare Nouă",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            
            conditionalPanel(
              condition = "input.data_type == 'suv'",
              fluidRow(
                column(4, textInput("new_type", "Tip:", placeholder = "Ex: Compact SUV")),
                column(4, textInput("new_engine", "Motor:", placeholder = "Ex: 2.0L I4")),
                column(4, selectInput("new_fuel", "Combustibil:", 
                                      choices = c("Benzină", "Diesel", "Hibrid", "Electric")))
              ),
              fluidRow(
                column(4, numericInput("new_year", "An:", value = 2023, min = 1990, max = 2025)),
                column(4, numericInput("new_mileage", "Kilometraj:", value = 10000, min = 0)),
                column(4, numericInput("new_price_suv", "Preț (EUR):", value = 30000, min = 0))
              )
            ),
            
            conditionalPanel(
              condition = "input.data_type == 'apt'",
              fluidRow(
                column(4, selectInput("new_location", "Locație:", 
                                      choices = c("Centru", "Nord", "Sud", "Est", "Vest"))),
                column(4, numericInput("new_rooms", "Nr. Camere:", value = 2, min = 1, max = 10)),
                column(4, numericInput("new_surface", "Suprafață (m²):", value = 50, min = 10))
              ),
              fluidRow(
                column(3, numericInput("new_floor", "Etaj:", value = 1, min = 0, max = 20)),
                column(3, numericInput("new_bathrooms", "Nr. Băi:", value = 1, min = 1, max = 5)),
                column(3, numericInput("new_dist", "Distanță Transport (km):", value = 0.5, min = 0, step = 0.1)),
                column(3, numericInput("new_price_apt", "Preț (EUR):", value = 80000, min = 0))
              )
            ),
            
            hr(),
            actionButton("add_row", "➕ Adaugă Înregistrare", 
                         class = "btn-success btn-lg", icon = icon("plus")),
            verbatimTextOutput("add_message")
          )
        )
      ),
      
      # ===== TAB 4: MODIFICĂ/ȘTERGE =====
      tabItem(
        tabName = "edit_data",
        fluidRow(
          box(
            title = "✏️ Modifică Date",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            numericInput("row_to_edit", "Selectează rândul de modificat:", 
                         value = 1, min = 1),
            uiOutput("edit_inputs"),
            hr(),
            actionButton("update_row", "💾 Salvează Modificările", 
                         class = "btn-warning", icon = icon("save")),
            verbatimTextOutput("edit_message")
          )
        ),
        
        fluidRow(
          box(
            title = "🗑️ Șterge Date",
            status = "danger",
            solidHeader = TRUE,
            width = 12,
            numericInput("row_to_delete", "Selectează rândul de șters:", 
                         value = 1, min = 1),
            actionButton("delete_row", "🗑️ Șterge Rând", 
                         class = "btn-danger", icon = icon("trash")),
            verbatimTextOutput("delete_message")
          )
        )
      ),
      
      # ===== TAB 5: GRAFICE INTERACTIVE =====
      tabItem(
        tabName = "plots",
        fluidRow(
          box(
            title = "📈 Grafic Principal (Interactive)",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("main_scatter_plot", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = "📊 Boxplot",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotOutput("boxplot_visual", height = "350px")
          ),
          
          box(
            title = "🎻 Violin Plot",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotOutput("violin_visual", height = "350px")
          )
        ),
        
        fluidRow(
          box(
            title = "📊 Grafic Personalizat",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            conditionalPanel(
              condition = "input.data_type == 'apt'",
              selectInput("custom_var", "Alege variabila pentru grafic:",
                          choices = c("Locație" = "Location", 
                                      "Camere" = "Rooms",
                                      "Etaj" = "Floor"))
            ),
            conditionalPanel(
              condition = "input.data_type == 'suv'",
              selectInput("custom_var", "Alege variabila pentru grafic:",
                          choices = c("Tip" = "Type", 
                                      "Combustibil" = "Fuel",
                                      "An" = "Year"))
            ),
            plotlyOutput("custom_plot", height = "400px")
          )
        )
      ),
      
      # ===== TAB 6: STATISTICI =====
      tabItem(
        tabName = "stats",
        fluidRow(
          box(
            title = "📊 Statistici Descriptive Complete",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            verbatimTextOutput("detailed_stats")
          ),
          
          box(
            title = "🎯 Verificare Prag Preț",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            numericInput("price_threshold", "Introduceți pragul de preț (EUR):", 
                         value = 100000, min = 0, step = 1000),
            actionButton("check_threshold", "🔍 Verifică", 
                         class = "btn-info", icon = icon("search")),
            hr(),
            verbatimTextOutput("threshold_result")
          )
        ),
        
        fluidRow(
          box(
            title = "📈 Analiză Corelații",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            plotOutput("correlation_plot", height = "400px")
          )
        )
      ),
      
      # ===== TAB 7: FILTRARE =====
      tabItem(
        tabName = "filter",
        fluidRow(
          box(
            title = "🔍 Filtrare Avansată",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(6, 
                     sliderInput("price_range", "Interval Preț (EUR):",
                                 min = 0, max = 200000, 
                                 value = c(0, 200000), step = 1000)
              ),
              column(6,
                     conditionalPanel(
                       condition = "input.data_type == 'suv'",
                       sliderInput("mileage_range", "Interval Kilometraj:",
                                   min = 0, max = 100000,
                                   value = c(0, 100000), step = 1000)
                     ),
                     conditionalPanel(
                       condition = "input.data_type == 'apt'",
                       sliderInput("surface_range", "Interval Suprafață (m²):",
                                   min = 0, max = 150,
                                   value = c(0, 150), step = 5)
                     )
              )
            ),
            
            actionButton("apply_filter", "🔍 Aplică Filtre", 
                         class = "btn-primary", icon = icon("filter")),
            actionButton("reset_filter", "🔄 Resetează Filtre", 
                         class = "btn-secondary", icon = icon("redo")),
            
            hr(),
            DTOutput("filtered_table")
          )
        )
      ),
      
      # ===== TAB 8: IMPORT/EXPORT =====
      tabItem(
        tabName = "import_export",
        fluidRow(
          box(
            title = "📥 Importă Date",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            fileInput("file_upload", "Alege fișier CSV:",
                      accept = c(".csv")),
            actionButton("import_data", "📥 Importă", 
                         class = "btn-info", icon = icon("upload")),
            verbatimTextOutput("import_message")
          ),
          
          box(
            title = "📤 Exportă Date",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            downloadButton("download_csv", "📥 Descarcă CSV", 
                           class = "btn-success"),
            downloadButton("download_excel", "📥 Descarcă Excel", 
                           class = "btn-success"),
            hr(),
            p("Descarcă datele curente în format CSV sau Excel.")
          )
        ),
        
        fluidRow(
          box(
            title = "📊 Generează Raport PDF",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            textInput("report_title", "Titlu Raport:", 
                      value = "Raport Analiza Prețuri"),
            downloadButton("generate_report", "📄 Generează Raport PDF", 
                           class = "btn-primary")
          )
        )
      )
    )
  )
)

# ===============================================
# SERVER LOGIC
# ===============================================

server <- function(input, output, session) {
  
  # Date reactive
  data <- reactiveValues(
    suv = suv_initial,
    apt = apt_initial
  )
  
  # Funcție helper pentru date curente
  current_data <- reactive({
    if (input$data_type == "suv") {
      data$suv
    } else {
      data$apt
    }
  })
  
  # ===== VALUE BOXES (Dashboard) =====
  output$total_items <- renderValueBox({
    valueBox(
      nrow(current_data()),
      if(input$data_type == "suv") "Total SUV-uri" else "Total Apartamente",
      icon = icon("list"),
      color = "blue"
    )
  })
  
  output$avg_price <- renderValueBox({
    valueBox(
      paste(format(mean(current_data()$Price), big.mark = ","), "EUR"),
      "Preț Mediu",
      icon = icon("euro-sign"),
      color = "green"
    )
  })
  
  output$min_price <- renderValueBox({
    valueBox(
      paste(format(min(current_data()$Price), big.mark = ","), "EUR"),
      "Preț Minim",
      icon = icon("arrow-down"),
      color = "yellow"
    )
  })
  
  output$max_price <- renderValueBox({
    valueBox(
      paste(format(max(current_data()$Price), big.mark = ","), "EUR"),
      "Preț Maxim",
      icon = icon("arrow-up"),
      color = "red"
    )
  })
  
  # ===== DASHBOARD PLOTS =====
  output$dashboard_plot <- renderPlotly({
    df <- current_data()
    
    if (input$data_type == "suv") {
      p <- ggplot(df, aes(x = Mileage, y = Price)) +
        geom_point(aes(color = Fuel, size = Year), alpha = 0.7) +
        geom_smooth(method = "lm", se = TRUE, color = "red", linetype = "dashed") +
        labs(title = "Kilometraj vs Preț", x = "Kilometraj (km)", y = "Preț (EUR)") +
        theme_minimal() +
        theme(legend.position = "right")
    } else {
      p <- ggplot(df, aes(x = Surface, y = Price)) +
        geom_point(aes(color = Location, size = Rooms), alpha = 0.7) +
        geom_smooth(method = "lm", se = TRUE, color = "darkblue", linetype = "dashed") +
        labs(title = "Suprafață vs Preț", x = "Suprafață (m²)", y = "Preț (EUR)") +
        theme_minimal() +
        theme(legend.position = "right")
    }
    
    ggplotly(p)
  })
  
  output$dashboard_hist <- renderPlot({
    df <- current_data()
    hist(df$Price, 
         breaks = 15,
         col = "steelblue",
         border = "white",
         main = "Distribuție Prețuri",
         xlab = "Preț (EUR)",
         ylab = "Frecvență")
    abline(v = mean(df$Price), col = "red", lwd = 2, lty = 2)
    legend("topright", legend = "Media", col = "red", lwd = 2, lty = 2)
  })
  
  # ===== MIN/MAX TABLES =====
  output$min_product_table <- renderTable({
    df <- current_data()
    min_row <- df[which.min(df$Price), ]
    min_row
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  output$max_product_table <- renderTable({
    df <- current_data()
    max_row <- df[which.max(df$Price), ]
    max_row
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  # ===== DATA TABLE =====
  output$data_table <- renderDT({
    datatable(current_data(), 
              options = list(pageLength = 10, scrollX = TRUE),
              filter = 'top',
              rownames = TRUE)
  })
  
  output$data_summary <- renderPrint({
    summary(current_data())
  })
  
  # ===== ADD DATA =====
  observeEvent(input$add_row, {
    if (input$data_type == "suv") {
      new_row <- data.frame(
        Type = input$new_type,
        Engine = input$new_engine,
        Fuel = input$new_fuel,
        Year = input$new_year,
        Mileage = input$new_mileage,
        Price = input$new_price_suv
      )
      data$suv <- rbind(data$suv, new_row)
      output$add_message <- renderText("✅ SUV adăugat cu succes!")
    } else {
      new_row <- data.frame(
        Location = input$new_location,
        Rooms = input$new_rooms,
        Surface = input$new_surface,
        Floor = input$new_floor,
        Bathrooms = input$new_bathrooms,
        Dist_Transport = input$new_dist,
        Price = input$new_price_apt
      )
      data$apt <- rbind(data$apt, new_row)
      output$add_message <- renderText("✅ Apartament adăugat cu succes!")
    }
  })
  
  # ===== EDIT DATA =====
  output$edit_inputs <- renderUI({
    req(input$row_to_edit)
    df <- current_data()
    
    if (input$row_to_edit > nrow(df)) {
      return(p("⚠️ Rândul selectat nu există!"))
    }
    
    row_data <- df[input$row_to_edit, ]
    
    if (input$data_type == "suv") {
      tagList(
        fluidRow(
          column(4, textInput("edit_type", "Tip:", value = row_data$Type)),
          column(4, textInput("edit_engine", "Motor:", value = row_data$Engine)),
          column(4, selectInput("edit_fuel", "Combustibil:", 
                                choices = c("Benzină", "Diesel", "Hibrid", "Electric"),
                                selected = row_data$Fuel))
        ),
        fluidRow(
          column(4, numericInput("edit_year", "An:", value = row_data$Year)),
          column(4, numericInput("edit_mileage", "Kilometraj:", value = row_data$Mileage)),
          column(4, numericInput("edit_price_suv", "Preț:", value = row_data$Price))
        )
      )
    } else {
      tagList(
        fluidRow(
          column(4, selectInput("edit_location", "Locație:", 
                                choices = c("Centru", "Nord", "Sud", "Est", "Vest"),
                                selected = row_data$Location)),
          column(4, numericInput("edit_rooms", "Nr. Camere:", value = row_data$Rooms)),
          column(4, numericInput("edit_surface", "Suprafață:", value = row_data$Surface))
        ),
        fluidRow(
          column(3, numericInput("edit_floor", "Etaj:", value = row_data$Floor)),
          column(3, numericInput("edit_bathrooms", "Nr. Băi:", value = row_data$Bathrooms)),
          column(3, numericInput("edit_dist", "Distanță:", value = row_data$Dist_Transport)),
          column(3, numericInput("edit_price_apt", "Preț:", value = row_data$Price))
        )
      )
    }
  })
  
  observeEvent(input$update_row, {
    req(input$row_to_edit)
    
    if (input$data_type == "suv") {
      data$suv[input$row_to_edit, ] <- data.frame(
        Type = input$edit_type,
        Engine = input$edit_engine,
        Fuel = input$edit_fuel,
        Year = input$edit_year,
        Mileage = input$edit_mileage,
        Price = input$edit_price_suv
      )
      output$edit_message <- renderText("✅ Date actualizate cu succes!")
    } else {
      data$apt[input$row_to_edit, ] <- data.frame(
        Location = input$edit_location,
        Rooms = input$edit_rooms,
        Surface = input$edit_surface,
        Floor = input$edit_floor,
        Bathrooms = input$edit_bathrooms,
        Dist_Transport = input$edit_dist,
        Price = input$edit_price_apt
      )
      output$edit_message <- renderText("✅ Date actualizate cu succes!")
    }
  })
  
  # ===== DELETE DATA =====
  observeEvent(input$delete_row, {
    req(input$row_to_delete)
    
    if (input$data_type == "suv") {
      if (input$row_to_delete <= nrow(data$suv)) {
        data$suv <- data$suv[-input$row_to_delete, ]
        output$delete_message <- renderText("✅ Rând șters cu succes!")
      } else {
        output$delete_message <- renderText("⚠️ Rândul nu există!")
      }
    } else {
      if (input$row_to_delete <= nrow(data$apt)) {
        data$apt <- data$apt[-input$row_to_delete, ]
        output$delete_message <- renderText("✅ Rând șters cu succes!")
      } else {
        output$delete_message <- renderText("⚠️ Rândul nu există!")
      }
    }
  })
  
  # ===== PLOTS =====
  output$main_scatter_plot <- renderPlotly({
    df <- current_data()
    
    if (input$data_type == "suv") {
      p <- ggplot(df, aes(x = Mileage, y = Price, text = paste("Tip:", Type))) +
        geom_point(aes(color = Type), size = 4, alpha = 0.7) +
        geom_smooth(method = "lm", se = TRUE) +
        labs(title = "Kilometraj vs Preț", x = "Kilometraj (km)", y = "Preț (EUR)") +
        theme_minimal()
    } else {
      p <- ggplot(df, aes(x = Surface, y = Price, text = paste("Locație:", Location))) +
        geom_point(aes(color = Location), size = 4, alpha = 0.7) +
        geom_smooth(method = "lm", se = TRUE) +
        labs(title = "Suprafață vs Preț", x = "Suprafață (m²)", y = "Preț (EUR)") +
        theme_minimal()
    }
    
    ggplotly(p, tooltip = "text")
  })
  
  output$boxplot_visual <- renderPlot({
    df <- current_data()
    boxplot(df$Price,
            main = "Boxplot Prețuri",
            ylab = "Preț (EUR)",
            col = "lightblue",
            border = "darkblue",
            horizontal = FALSE)
    abline(h = mean(df$Price), col = "red", lwd = 2, lty = 2)
    text(1.3, mean(df$Price), sprintf("Media: %.0f EUR", mean(df$Price)), 
         col = "red", pos = 4)
  })
  
  output$violin_visual <- renderPlot({
    df <- current_data()
    vioplot(df$Price,
            col = "lightyellow",
            border = "orange",
            main = "Violin Plot Prețuri",
            ylab = "Preț (EUR)")
    abline(h = mean(df$Price), col = "red", lwd = 2, lty = 2)
  })
  
  output$custom_plot <- renderPlotly({
    df <- current_data()
    req(input$custom_var)
    
    p <- ggplot(df, aes_string(x = input$custom_var, y = "Price")) +
      geom_boxplot(aes_string(fill = input$custom_var), alpha = 0.7) +
      geom_jitter(width = 0.2, alpha = 0.5, size = 2) +
      labs(title = paste("Prețuri în funcție de", input$custom_var),
           x = input$custom_var, y = "Preț (EUR)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # ===== STATISTICS =====
  output$detailed_stats <- renderPrint({
    df <- current_data()
    cat("============================================\n")
    cat("       STATISTICI DESCRIPTIVE COMPLETE      \n")
    cat("============================================\n\n")
    
    cat("PREȚURI:\n")
    cat(sprintf("  Media:               %.2f EUR\n", mean(df$Price)))
    cat(sprintf("  Mediană:             %.2f EUR\n", median(df$Price)))
    cat(sprintf("  Deviație Standard:   %.2f EUR\n", sd(df$Price)))
    cat(sprintf("  Minim:               %.2f EUR\n", min(df$Price)))
    cat(sprintf("  Maxim:               %.2f EUR\n", max(df$Price)))
    cat(sprintf("  Cuartila 1 (Q1):     %.2f EUR\n", quantile(df$Price, 0.25)))
    cat(sprintf("  Cuartila 3 (Q3):     %.2f EUR\n", quantile(df$Price, 0.75)))
    cat(sprintf("  IQR:                 %.2f EUR\n", IQR(df$Price)))
    cat(sprintf("  Rang:                %.2f EUR\n", max(df$Price) - min(df$Price)))
    cat(sprintf("  Coeficient Variație: %.2f%%\n", (sd(df$Price)/mean(df$Price))*100))
    
    cat("\n--------------------------------------------\n")
    cat("DISTRIBUȚIE:\n")
    cat(sprintf("  Număr total înregistrări: %d\n", nrow(df)))
    cat(sprintf("  Asimetrie (Skewness):     %.3f\n", 
                (mean(df$Price) - median(df$Price)) / sd(df$Price)))
    
    cat("\n============================================\n")
  })
  
  observeEvent(input$check_threshold, {
    df <- current_data()
    threshold <- input$price_threshold
    above <- sum(df$Price > threshold)
    below <- sum(df$Price <= threshold)
    pct_above <- (above / nrow(df)) * 100
    
    output$threshold_result <- renderText({
      paste0(
        "============================================\n",
        "  REZULTATE VERIFICARE PRAG: ", format(threshold, big.mark = ","), " EUR\n",
        "============================================\n\n",
        "Peste prag:     ", above, " (", sprintf("%.1f%%", pct_above), ")\n",
        "Sub/Egal prag:  ", below, " (", sprintf("%.1f%%", 100 - pct_above), ")\n\n",
        "Total verificat: ", nrow(df), " înregistrări\n",
        "============================================"
      )
    })
  })
  
  output$correlation_plot <- renderPlot({
    df <- current_data()
    
    if (input$data_type == "suv") {
      numeric_cols <- df[, c("Year", "Mileage", "Price")]
    } else {
      numeric_cols <- df[, c("Rooms", "Surface", "Floor", "Bathrooms", "Dist_Transport", "Price")]
    }
    
    cor_matrix <- cor(numeric_cols)
    
    par(mar = c(5, 5, 4, 2))
    image(1:ncol(cor_matrix), 1:nrow(cor_matrix), t(cor_matrix),
          col = colorRampPalette(c("red", "white", "blue"))(100),
          xlab = "", ylab = "", axes = FALSE,
          main = "Matrice de Corelații")
    axis(1, at = 1:ncol(cor_matrix), labels = colnames(cor_matrix), las = 2)
    axis(2, at = 1:nrow(cor_matrix), labels = rownames(cor_matrix), las = 1)
    
    for (i in 1:nrow(cor_matrix)) {
      for (j in 1:ncol(cor_matrix)) {
        text(j, i, sprintf("%.2f", cor_matrix[i, j]), cex = 1.2)
      }
    }
  })
  
  # ===== FILTERING =====
  filtered_data <- reactive({
    df <- current_data()
    
    # Filter by price
    df <- df[df$Price >= input$price_range[1] & df$Price <= input$price_range[2], ]
    
    # Additional filters
    if (input$data_type == "suv") {
      df <- df[df$Mileage >= input$mileage_range[1] & df$Mileage <= input$mileage_range[2], ]
    } else {
      df <- df[df$Surface >= input$surface_range[1] & df$Surface <= input$surface_range[2], ]
    }
    
    df
  })
  
  output$filtered_table <- renderDT({
    datatable(filtered_data(),
              options = list(pageLength = 10, scrollX = TRUE),
              rownames = TRUE)
  })
  
  observeEvent(input$apply_filter, {
    # Trigger reactive update
    output$filtered_table <- renderDT({
      datatable(filtered_data(),
                options = list(pageLength = 10, scrollX = TRUE),
                rownames = TRUE,
                caption = paste("Rezultate filtrate:", nrow(filtered_data()), "înregistrări"))
    })
  })
  
  observeEvent(input$reset_filter, {
    updateSliderInput(session, "price_range", value = c(0, 200000))
    if (input$data_type == "suv") {
      updateSliderInput(session, "mileage_range", value = c(0, 100000))
    } else {
      updateSliderInput(session, "surface_range", value = c(0, 150))
    }
  })
  
  # ===== IMPORT/EXPORT =====
  observeEvent(input$import_data, {
    req(input$file_upload)
    
    tryCatch({
      imported <- read.csv(input$file_upload$datapath, stringsAsFactors = FALSE)
      
      if (input$data_type == "suv") {
        required_cols <- c("Type", "Engine", "Fuel", "Year", "Mileage", "Price")
        if (all(required_cols %in% colnames(imported))) {
          data$suv <- imported
          output$import_message <- renderText("✅ Date SUV importate cu succes!")
        } else {
          output$import_message <- renderText("❌ Fișierul nu are coloanele necesare pentru SUV!")
        }
      } else {
        required_cols <- c("Location", "Rooms", "Surface", "Floor", "Bathrooms", "Dist_Transport", "Price")
        if (all(required_cols %in% colnames(imported))) {
          data$apt <- imported
          output$import_message <- renderText("✅ Date Apartamente importate cu succes!")
        } else {
          output$import_message <- renderText("❌ Fișierul nu are coloanele necesare pentru Apartamente!")
        }
      }
    }, error = function(e) {
      output$import_message <- renderText(paste("❌ Eroare la import:", e$message))
    })
  })
  
  output$download_csv <- downloadHandler(
    filename = function() {
      paste0(input$data_type, "_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(current_data(), file, row.names = FALSE)
    }
  )
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste0(input$data_type, "_data_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      if (!require(writexl)) install.packages("writexl")
      library(writexl)
      write_xlsx(current_data(), file)
    }
  )
  
  output$generate_report <- downloadHandler(
    filename = function() {
      paste0("raport_", input$data_type, "_", Sys.Date(), ".html")
    },
    content = function(file) {
      df <- current_data()
      
      html_content <- paste0(
        "<!DOCTYPE html>",
        "<html><head>",
        "<meta charset='UTF-8'>",
        "<title>", input$report_title, "</title>",
        "<style>",
        "body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }",
        "h1 { color: #3c8dbc; border-bottom: 3px solid #3c8dbc; padding-bottom: 10px; }",
        "h2 { color: #555; margin-top: 30px; }",
        ".stat-box { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }",
        "table { width: 100%; border-collapse: collapse; margin: 20px 0; background: white; }",
        "th { background: #3c8dbc; color: white; padding: 12px; text-align: left; }",
        "td { padding: 10px; border-bottom: 1px solid #ddd; }",
        "tr:hover { background: #f9f9f9; }",
        ".footer { margin-top: 40px; text-align: center; color: #888; font-size: 12px; }",
        "</style>",
        "</head><body>",
        "<h1>", input$report_title, "</h1>",
        "<p><strong>Data generării:</strong> ", Sys.Date(), "</p>",
        "<p><strong>Tip date:</strong> ", if(input$data_type == "suv") "SUV-uri" else "Apartamente", "</p>",
        
        "<div class='stat-box'>",
        "<h2>📊 Statistici Generale</h2>",
        "<p><strong>Total înregistrări:</strong> ", nrow(df), "</p>",
        "<p><strong>Preț mediu:</strong> ", format(mean(df$Price), big.mark = ","), " EUR</p>",
        "<p><strong>Preț minim:</strong> ", format(min(df$Price), big.mark = ","), " EUR</p>",
        "<p><strong>Preț maxim:</strong> ", format(max(df$Price), big.mark = ","), " EUR</p>",
        "<p><strong>Deviație standard:</strong> ", format(sd(df$Price), big.mark = ","), " EUR</p>",
        "</div>",
        
        "<div class='stat-box'>",
        "<h2>📋 Tabel Date Complete</h2>",
        knitr::kable(df, format = "html", table.attr = "class='data-table'"),
        "</div>",
        
        "<div class='footer'>",
        "<p>Raport generat automat cu Aplicația Analiza Prețuri Pro</p>",
        "</div>",
        "</body></html>"
      )
      
      writeLines(html_content, file)
    }
  )
}

# ===============================================
# RULARE APLICAȚIE
# ===============================================

shinyApp(ui = ui, server = server)