library(dplyr)
library(shiny)
library(shinydashboard)
library(ggiraph)
library(DT)
library(ggplot2)

# TODO: add bookmarks in Shiny app
enableBookmarking(store = "url")

# Altmetrics from Altmetric on Finnish university publications published in 2015.
# Altmetric public API queried by DOI.
#
# Publication metadata fetched by university code from Virta REST API
data <- read.csv2("data_2015.csv", stringsAsFactors = FALSE)
data$Title <- gsub("'","", data$Title)

# Finnish university names in English
universities <- read.csv2("universities.csv", stringsAsFactors = FALSE)
universities <- sort(universities$x)

metrics_select <- sort(c("Score", "Mendeley", "Twitter", "Facebook", "CiteULike", "Blogs",
                         "YouTube", "Reddit", "NewsOutlets", "ResearchForums", "Policy", "Weibo", "Wikipedia", "Authors"))

tooltip_css <- "background-color:orange;border-style:dotted;font-style:italic;padding:4px 3px 4px 8px;"

cols <- colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))
