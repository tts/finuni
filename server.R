function(input, output, session) {
  
  
  selectedUnivData <- reactive({
    
    if ( input$university == 'All' ) 
      return(data)

     data %>%
        filter(University %in% input$university) 
  })
  
  
  
  
 
  output$plot <- renderggiraph({
  
    
    xc <- as.name(input$xc)
    yc <- as.name(input$yc)
    
    df <- selectedUnivData()

    legend_title <- "University"
    
    gg_point <- ggplot(df, 
                       aes_q(x = xc,
                             y = yc,
                             stroke = df$OA,
                             color = df$University,
                             data_id = df$Title,
                             tooltip = df$Title)) + 
      labs(color=legend_title) +
      scale_x_log10() +
      scale_y_log10() +
      geom_point_interactive(alpha = 0.5, na.rm = TRUE) 
    
    ggiraph(code = {print(gg_point)}, selection_type = "multiple", width_svg = 8, height_svg = 8)
    })
  
  
  selected_state <- reactive({
    input$plot_selected
    })
  
  
  observeEvent(input$reset, {
    session$sendCustomMessage(type = 'plot_set', message = character(0))
    })
  
  
  output$sel <- renderTable({
    
    sel_df <- selectedUnivData()
    
    out <- sel_df[sel_df$Title %in% selected_state(), 
                  c("Link", "Title", "University", "Journal", "OpenAccess", "Authors", "Score", "Twitter", "Mendeley")]
    
  
    if( nrow(out) < 1 ) return(NULL)
    row.names(out) <- NULL
    out
    }, sanitize.text.function = function(x) x)
 
   

  output$nrofitemswithmetrics <- renderValueBox({
    valueBox(
      "Items with metrics", 
      nrow(selectedUnivData()), 
      icon = icon("calculator"),
      color = "yellow"
    )
  })
  
  output$maxaltmetrics <- renderValueBox({
    valueBox(
      "Top Altmetric score", 
      max(selectedUnivData()$Score, na.rm = TRUE), 
      icon = icon("spinner"),
      color = "green",
      href = selectedUnivData()[selectedUnivData()$Score %in% max(selectedUnivData()$Score, na.rm = TRUE), "href"][1]
    )
  })

  output$maxtwitter <- renderValueBox({
    valueBox(
      "Top Twitter score", 
      ifelse(is.finite(max(selectedUnivData()$Twitter, na.rm = TRUE)), max(selectedUnivData()$Twitter, na.rm = TRUE), "N/A"), 
      icon = icon("twitter"),
      color = "light-blue",
      href = selectedUnivData()[selectedUnivData()$Twitter %in% max(selectedUnivData()$Twitter, na.rm = TRUE), "href"][1]
    )
  })
  
  output$maxreddit <- renderValueBox({
    valueBox(
      "Top Reddit score", 
      ifelse(is.finite(max(selectedUnivData()$Reddit, na.rm = TRUE)), max(selectedUnivData()$Reddit, na.rm = TRUE), "N/A"), 
      icon = icon("reddit"),
      color = "orange",
      href = selectedUnivData()[selectedUnivData()$Reddit %in% max(selectedUnivData()$Reddit, na.rm = TRUE), "href"][1]
    )
  })
  
  output$maxwikipedia <- renderValueBox({
    valueBox(
      "Top Wikipedia score", 
      ifelse(is.finite(max(selectedUnivData()$Wikipedia, na.rm = TRUE)), max(selectedUnivData()$Wikipedia, na.rm = TRUE), "N/A"), 
      icon = icon("wikipedia-w"),
      color = "aqua",
      href = selectedUnivData()[selectedUnivData()$Wikipedia %in% max(selectedUnivData()$Wikipedia, na.rm = TRUE), "href"][1]
    )
  })
  
  output$maxyoutube <- renderValueBox({
    valueBox(
      "Top YouTube score", 
      ifelse(is.finite(max(selectedUnivData()$YouTube, na.rm = TRUE)), max(selectedUnivData()$YouTube, na.rm = TRUE), "N/A"), 
      icon = icon("youtube"),
      color = "purple",
      href = selectedUnivData()[selectedUnivData()$YouTube %in% max(selectedUnivData()$YouTube, na.rm = TRUE), "href"][1]
    )
  })
  
  output$maxmendeley <- renderValueBox({
    valueBox(
      "Top Mendeley score", 
      ifelse(is.finite(max(selectedUnivData()$Mendeley, na.rm = TRUE)), max(selectedUnivData()$Mendeley, na.rm = TRUE), "N/A"), 
      icon = icon("line-chart"),
      color = "fuchsia",
      href = selectedUnivData()[selectedUnivData()$Mendeley %in% max(selectedUnivData()$Mendeley, na.rm = TRUE), "href"][1]
    )
  })
  
  
  # Datatable
  output$datatable <- DT::renderDataTable({
    
    totable <- selectedUnivData()
    
    totable <- totable %>% 
      select(-href, -OA)
                          
  
    }, escape = FALSE, options = list(scrollX = T)
)
  
  
}
