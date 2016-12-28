function(input, output, session) {
  
  
  selectedUnivData <- reactive({
    
    if ( input$university == 'All' ) 
      return(data)

     data %>%
        filter(University %in% input$university) 
  })
  
  
  select_metrics <- reactive({
    
    # Are there columns that are all NA?
    all_na_cols <- apply(selectedUnivData(), 2, function(x) all(is.na(x)));  
    cols_with_all_na <- names(all_na_cols[all_na_cols>0]);    
    
    # Exclude these from the metrics vector so that they cannot be selected
    new_metrics <- setdiff(metrics_select, cols_with_all_na)
    new_metrics
    
  })
  
  
  # Update the selection of metrics in the UI if necessary
  observe({
    updateSelectInput(session, "xc",
                      choices = as.list(select_metrics()),
                      selected = "Score")
    updateSelectInput(session, "yc",
                      choices = as.list(select_metrics()),
                      selected = "Authors")
  })
  

  output$plot <- renderggiraph({
  
    xc <- as.name(input$xc)
    yc <- as.name(input$yc)
    
    df <- selectedUnivData()

    legend_title <- "University"
    
    gg_point <- ggplot(df, 
                       aes_q(x = xc,
                             y = yc,
                             size = df$OA,
                             color = df$University,
                             data_id = df$Title,
                             tooltip = df$Title)) + 
      labs(color=legend_title) +
      scale_x_continuous(trans="log10") +
      scale_y_continuous(trans="log10") +
      geom_point_interactive(alpha = 0.5, na.rm = TRUE) +
      scale_size(guide = "none")
  
    
    ggiraph(code = {print(gg_point)}, 
            selection_type = "multiple", 
            width_svg = 8, height_svg = 8, 
            hover_css = "fill:yellow", 
            zoom_max = 3)
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
                  c("Link", "Title", "University", "Journal", "OpenAccess", "Authors", "Score")]
    
  
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
