sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Plot", tabName = "altmetric", icon = icon("dashboard")),
    menuSubItem("Data", tabName = "data", icon = icon("angle-double-right"), selected = NULL),
    selectInput(inputId = "university", 
                label = "University", 
                choices = c("All", universities),
                multiple = FALSE,
                selected = "All"),
    selectInput("xc", "Horizontal axis", as.list(metrics_select), selected = "Score"),
    selectInput("yc", "Vertical axis", as.list(metrics_select), selected = "Mendeley"),
    HTML("<p>  <a href='http://www.altmetric.com'>Altmetric</a> and <a href='https://confluence.csc.fi/display/VIR/Julkaisukanavatietokannan+REST-rajapinta'>Virta</a><br/>data as of 2016-12-23.<br/>Altmetric API search<br/>based on DOI.<br/>The bigger the circle,<br/>the more OA.</p>")
  ), width = 160
)


body <- dashboardBody(
  
  tabItems(
    
    tabItem("altmetric",
            fluidRow(
              column(
                width = 8,               
                box(title = "Click to select items to the table below",
                    status = "warning",
                    solidHeader = TRUE,
                    width = "100%",
                    ggiraphOutput("plot", width = "100%"))),
              column(
                width = 4,
                valueBoxOutput("nrofitemswithmetrics", width = NULL),
                valueBoxOutput("maxaltmetrics", width = NULL),
                valueBoxOutput("maxtwitter", width = NULL),
                valueBoxOutput("maxreddit", width = NULL),
                valueBoxOutput("maxwikipedia", width = NULL),
                valueBoxOutput("maxyoutube", width = NULL),
                box(width = "100%",
                    height = "50px",
                    actionButton("reset", label = "Reset selection", 
                                 icon = icon("refresh"), width = "99%")))),
            fluidRow(
              column(
                width = 12,
                box(title = "Selected item(s)",
                    status = "warning",
                    solidHeader = TRUE,
                    width = "100%",
                    tableOutput("sel"))))
    ),
    
    tabItem("data",
            fluidRow(
              box(title = "Table",
                  status = "info",
                  solidHeader = TRUE,
                  width = 12,
                  DT::dataTableOutput("datatable", 
                                     # width = "100%",
                                      height = "600px"))
              )
    )
    
  ))


dashboardPage(
  dashboardHeader(title = "Altmetrics of Finnish university publications 2015",
                  titleWidth = "700"),
  sidebar,
  body,
  skin = "black"
)

