library(dplyr)
library(shiny)
library(shinydashboard)
library(ggiraph)
library(DT)
library(ggplot2)


enableBookmarking(store = "url")

data <- read.csv2("data_2015.csv", stringsAsFactors = FALSE)
data$Title <- gsub("'","", data$Title)

universities <- read.csv2("universities.csv", stringsAsFactors = FALSE)
universities <- universities$x

metrics_select <- sort(c("Score", "Mendeley", "Twitter", "Facebook", "GPlus", "CiteULike", "Blogs",
                         "YouTube", "Reddit", "NewsOutlets", "ResearchForums", "Policy", "Weibo", "Wikipedia", "Authors"))

