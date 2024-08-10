library(shiny)
library(DT)
library(openxlsx)

# Define UI
ui <- fluidPage(
  titlePanel("Academic Author CV Search"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file",
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      downloadButton("downloadExcel", "Download Excel"),
      hr(),
      helpText("Upload a CSV file with a single column of author names.")
    ),
    
    mainPanel(
      DTOutput("table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expression to read the uploaded file
  authors <- reactive({
    req(input$file)
    tryCatch({
      df <- read.csv(input$file$datapath, stringsAsFactors = FALSE)
      df
    }, error = function(e) {
      message("Error reading CSV file: ", e$message)
      return(NULL)
    })
  })
  
  # Render the data table with Google search links
  output$table <- renderDT({
    df <- authors()
    if (is.null(df) || nrow(df) == 0) return(NULL)
    
    author_names <- df[[1]]
    
    # Create Google search links
    df$Search_Link <- sapply(author_names, function(name) {
      google_search_url <- paste0("https://www.google.com/search?q=", URLencode(paste(name, "cardiac MRI consultant cv")))
      paste0('<a href="', google_search_url, '" target="_blank">Search CV</a>')
    })
    
    # Render the data table with HTML links
    datatable(df, escape = FALSE, options = list(pageLength = 5, autoWidth = TRUE))
  })
  
  # Download handler for exporting data to Excel
  output$downloadExcel <- downloadHandler(
    filename = function() {
      paste("authors_with_links_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      df <- authors()
      if (is.null(df) || nrow(df) == 0) return(NULL)
      
      # Create a workbook
      wb <- createWorkbook()
      
      # Add a worksheet
      addWorksheet(wb, "Authors")
      
      # Write data to the worksheet
      writeData(wb, sheet = 1, x = df, colNames = TRUE)
      
      # Save workbook to file
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
