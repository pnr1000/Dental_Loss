ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      helpText("Create descriptive graphs with 
               information from the 2016 Dental Loss Ratio data."),
      radioButtons("rb", "Select Business of Interest", choices = unique(teeth$Business), selected = unique(teeth$Business)[1],inline = FALSE),
      selectInput("si","Select Geographical Region",choices = unique(teeth$Region), selected = unique(teeth$Region)[]),
      sliderInput("sl","Loss Ratio", min = 0, max = 1, value = 10)
      
      
      ),
    mainPanel(
      tabsetPanel(
        tabPanel("README",
                 h2("2016 Dental Loss Ratios"),
                 h3("About this Dataset"),
                 textOutput("readme")
        ),
        tabPanel("Scatter Plot",
                 h2("Scatter Plot of Premiums vs Payments"),
                 metricsgraphicsOutput("scatter")
        ),
        tabPanel("Line Graph",
                 h2("Multiple Line Graph"),
                 plotlyOutput("line")
        ),
        tabPanel("Box Plot",
                 h2("Avg Premiums per Members"),
                 plotlyOutput("box")
        ),
        tabPanel("Data Table",
                 h2("Data Table"),
                 dataTableOutput(outputId = "table")
        )
        
        
      )
      
    )
  )
)