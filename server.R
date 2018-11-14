server <- function(input, output, session) {
  filtered_data <- reactive({filter(teeth, Business == input$rb)})
  observe({
    updateSelectInput(session,"si", choices = unique(filtered_data()$Region))
  })
  
  
  filtered_data_2 <- reactive({filter(filtered_data(), Region == input$si, `Loss Ratio` <= input$sl)})
  
  output$scatter <- renderMetricsgraphics(
    {
      mjs_plot(filtered_data_2(), x=Premiums, y=Payments) %>%
        mjs_point(color_accessor=Year, size_accessor=Members) %>%
        mjs_labs(x="Premiums Earned From Dental Policies", y="Direct Costs")    
    }
  )
  
  output$table <- renderDataTable(
    {
      select(filtered_data_2(),c("Year","Premiums","Payments","Members","Loss Ratio","Business","Region"))
    }
  )
  output$line <- renderMetricsgraphics({
    bin1 <- filtered_data_2()[which(filtered_data_2()$Premium_bin == "High"),]
    density1 <- density(bin1$Avg)
    
    bin2 <- filtered_data_2()[which(filtered_data_2()$Premium_bin == "Low"),]
    density2 <- density(bin2$Avg)
    
    p <- plot_ly(x = ~density1$x, y = ~density1$y, type = 'scatter', mode = 'lines', name = 'High Premium', fill = 'tozeroy') %>%
      add_trace(x = ~density2$x, y = ~density2$y, name = 'Low Premium', fill = 'tozeroy') %>%
      layout(xaxis = list(title = 'Avg Premiums per Month'),
             yaxis = list(title = 'Density'))
  })
  output$box <- renderPlotly({
    p <- plot_ly(type = 'box') %>%
      add_boxplot(data = filtered_data_2(), y = filtered_data_2()$Avg, jitter = 0.3, pointpos = -1.8, boxpoints = 'all',
                  marker = list(color = 'rgb(7,40,89)'),
                  line = list(color = 'rgb(7,40,89)'),
                  name = "All Points") %>%
      add_boxplot(data = filtered_data_2, y = filtered_data_2()$Avg, name = "Suspected Outlier", boxpoints = 'suspectedoutliers',
                  marker = list(color = 'rgb(8,81,156)',
                                outliercolor = 'rgba(219, 64, 82, 0.6)',
                                line = list(outliercolor = 'rgba(219, 64, 82, 1.0)',
                                            outlierwidth = 2)),
                  line = list(color = 'rgb(8,81,156)')) %>%
      layout(title = "Box Plot Styling Outliers")
    ggplotly(p)
  })
  output$readme <- renderText({ 
    "This app aims to explore a few insights from the 2016 Dental Loss Ratio Data. The data 
    serves as a dental insurance summary database provided by the Washington office of the
    Insurance Commissioner. A note on this data is that the data captured comes from the sum
    of individual businesses and group businesses. Another note is that reasonable approximations
    are allowed when exact information is not readily available to the reporting entity.
    
    This app contains three graphs, a scatter plot, line graph and box plot. The scatter plot
    compares dental premiums earned for the year with direct costs inccured from providing dental
    treatments. The colors of the points represent the different years of reported data, 2015
    and 2016, and the size of the points represents the number of lives insured.
    
    In the line graph, the blue line depicts high dental premiums and the orange line is for
    low dental premiums. Both lines look at the average amount of dental premiums per month
    for each reporting entity.
    
    Finally, in the box plot examines the average amount of dental premiums per month per member
    of the reporting entity. It attempts to highlight some of the suspected outliers within the 
    dataset.
    
    The final tab of this app shows a reactive data table, that updates with the filters set in
    place to give a visual as to what data is being used when filters are in place."
  })
  
  }