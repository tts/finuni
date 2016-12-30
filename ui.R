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
    selectInput("yc", "Vertical axis", as.list(metrics_select), selected = "Twitter"),
    HTML("<div class='form-group shiny-input-container'><p><a href='http://www.altmetric.com'>Altmetric</a> and <a href='https://confluence.csc.fi/display/VIR/Julkaisukanavatietokannan+REST-rajapinta'>Virta</a> data dated 2016-12-23. Altmetric API searched by DOI</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>The bigger the circle, the more open the source (as in Open Access)</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>R source code of <a href='https://github.com/tts/finunipolicy'>getting data</a>, and <a href='https://github.com/tts/finuni'>building this app</a></p></div>")
    
  ), width = 180
)


body <- dashboardBody(
  
  tabItems(
    
    tabItem("altmetric",
            fluidRow(
              column(
                width = 8,               
                box(title = "Click to select items to table below. You can also zoom in/out",
                    status = "warning",
                    solidHeader = TRUE,
                    width = "100%",
                    ggiraphOutput("plot", width = "100%"))),
              column(
                width = 4,
                valueBoxOutput("nrofitemswithmetrics", width = NULL),
                valueBoxOutput("maxaltmetrics", width = NULL),
                valueBoxOutput("maxtwitter", width = NULL),
                valueBoxOutput("maxmendeley", width = NULL)
                )),
            fluidRow(
              column(
                width = 8,
                box(title = "Selected item(s)",
                    status = "warning",
                    solidHeader = TRUE,
                    width = "100%",
                    tableOutput("sel"))),
              column(
                width = 2,
                box(width = NULL,
                    height = "50px",
                    actionButton("reset", label = "Reset selection", 
                                 icon = icon("refresh"), width = "100%")))
    )),
    
    tabItem("data",
            fluidRow(
              box(title = "Table",
                  status = "info",
                  solidHeader = TRUE,
                  width = 12,
                  DT::dataTableOutput("datatable", 
                                      height = "600px"))
              )
    )
  )
)


dashboardPage(
  dashboardHeader(title = "Altmetrics of Finnish university publications 2015",
                  titleWidth = "700"),
  sidebar,
  body,
  skin = "black"
)

