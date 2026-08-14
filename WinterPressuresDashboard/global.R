library(shiny)
library(bslib)
library(shinyBS)
library(patchwork)
library(ggplot2)
library(ggiraph)
library(shinyWidgets)
library(tidyverse)
library(stringr)
library(shinyjs)
library(ggtext)
library(gridtext)
library(ggh4x)
library(rsconnect)
library(shinycssloaders)

# current url:  https://h4e5yf-nagat0guled.shinyapps.io/winterpressuresdashboard/

# load model output file
#df <- read.csv("..\\Analysis\\Model_output_for_plots\\plot_model_output.csv")

df <- read.csv("data/dummy_model_output.csv")

source("R/labels.R")
source("R/logos.R")

uob_red <- "#a6192e"

# map columns in dataset to labels for dashboard
