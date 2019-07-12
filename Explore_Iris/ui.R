#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Explore the Iris"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h4("Select trainingset portion"),
        radioButtons("trainingfraction", "trainingset portion:", 
                     c("0.9" = 0.9,
                       "0.8" = 0.8,
                       "0.7" = 0.7,
                       "0.6" = 0.6),
                       selected = 0.7
                     ),
        h4("Show boxplots for features"),
        radioButtons("features", "features:",
                     c("Sepal Length" = "sepal_length",
                        "Sepal Width" = "sepal_width",
                        "Petal Length" = "petal_length",
                        "Petal Width" = "petal_width")),
        h4("Select features for training"),
        checkboxInput("selectSepalLength", "Sepal Length", value = TRUE),
        checkboxInput("selectSepalWidth", "Sepal Width", value = TRUE),
        checkboxInput("selectPetalLength", "Petal Length", value = TRUE),
        checkboxInput("selectPetalWidth", "Petal Width", value = TRUE),
        h4("Select Prediction Models"),
        radioButtons(inputId = "SelectModels", label = "Models", 
                     choices = c("Softmax Regression",
                       "Support Vector Machine",
                       "Random Forest"),
                     selected = "Softmax Regression"
        ),
       actionButton("goButton",  "Go!")
    ),
      

       
    # Show a plot of the generated distribution
     mainPanel(
       h3("Table"),
       tableOutput("table0"),
       h3("Boxplots"),
       plotOutput("featureshist"),
       h3("Confusion Matrix"),
       tableOutput("table")
     )
  )
))
