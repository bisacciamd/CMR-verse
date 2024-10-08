library(shiny)
library(DT)
library(openxlsx)

# Define UI
ui <- fluidPage(
  titlePanel("Academic Author CV Search"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV or Excel file",
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv", ".xlsx")),
      downloadButton("downloadExcel", "Download Excel"),
      hr(),
      helpText("Upload a CSV or Excel file with columns for author names and affil_city.")
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
    ext <- tools::file_ext(input$file$name)
    
    tryCatch({
      if (ext == "csv") {
        df <- read.csv(input$file$datapath, stringsAsFactors = FALSE)
      } else if (ext == "xlsx") {
        df <- read.xlsx(input$file$datapath, sheet = 1)
      } else {
        stop("Unsupported file type")
      }
      df
    }, error = function(e) {
      message("Error reading file: ", e$message)
      return(NULL)
    })
  })
  
  # Render the data table with Google search links
  output$table <- renderDT({
    df <- authors()
    if (is.null(df) || nrow(df) == 0) return(NULL)
    
    # Check if both author names and affil_city columns exist
    if (!all(c("author", "affil_city") %in% colnames(df))) {
      stop("The uploaded file must contain columns named 'author' and 'affil_city'.")
    }
    
    author_names <- df[["author"]]
    affil_cities <- df[["affil_city"]]
    
    # Create Google search links including author name and affil_city
    df$Search_Link <- mapply(function(name, city) {
      search_query <- paste(name, city, "magnetic resonance cv")
      google_search_url <- paste0("https://www.google.com/search?q=", URLencode(search_query))
      paste0('<a href="', google_search_url, '" target="_blank">Search CV</a>')
    }, name = author_names, city = affil_cities)
    
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
