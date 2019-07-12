#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(nnet)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
 
    output$table0 <- renderTable({
      head(iris,3)
    }) 
    
    set.seed(123)
    trainset <- reactive({result <- as.numeric(input$trainingfraction)
                       train_size <- floor(result * nrow(iris))
                       train_ind <- sample(seq_len(nrow(iris)), size = train_size)
                       train <- iris[train_ind, ]
                       })
  
    testset <- reactive({result <- as.numeric(input$trainingfraction)
                          train_size <- floor(result * nrow(iris))
                          train_ind <- sample(seq_len(nrow(iris)), size = train_size)
                          test <- iris[-train_ind, ]
                        })
    
       output$featureshist <- renderPlot({
          feature_selected <- switch(input$features,
                           sepal_length = trainset()$Sepal.Length,
                           sepal_width = trainset()$Sepal.Width,
                           petal_length = trainset()$Petal.Length,
                           petal_width = trainset()$Petal.Width,
                           )
          newdata <- data.frame(feature = feature_selected, species = trainset()$Species)
          boxplot(feature ~ species, data = newdata, main = 'selected feature of the training set', col = 'orange')
       })
    
     trainset_selfeature <- reactive({
         #train_feature_sel <- data.frame(matrix("", ncol = ncol(trainset()), nrow = nrow(trainset())))
         columns <- c()
         if(input$selectSepalLength){
            columns <- c(columns, 'Sepal.Length')
         }
         if(input$selectSepalWidth){
           columns <- c(columns, 'Sepal.Width')
         }
         if(input$selectPetalLength){
           columns <- c(columns, 'Petal.Length')
         }
         if(input$selectPetalWidth){
           columns <- c(columns, 'Petal.Width')
         }
         columns <- c(columns, 'Species')
         train_feature_sel <- subset(trainset(), select=columns)
         train_feature_sel
     })
   
     testset_selfeature <- reactive({
       columns <- c()
       if(input$selectSepalLength){
         columns <- c(columns, 'Sepal.Length')
       }
       if(input$selectSepalWidth){
         columns <- c(columns, 'Sepal.Width')
       }
       if(input$selectPetalLength){
         columns <- c(columns, 'Petal.Length')
       }
       if(input$selectPetalWidth){
         columns <- c(columns, 'Petal.Width')
       }
       test_feature_sel <- subset(testset(), select=columns)
       test_feature_sel
     })
     
   
  
     pred <- eventReactive(input$goButton, {

          if(ncol(trainset_selfeature()) == 0){
             return()
          }else{  
              if(input$SelectModels == "Softmax Regression")
                model_fit = multinom(Species ~ ., data = trainset_selfeature())
              else if(input$SelectModels == "Support Vector Machine"){
                ctrl <- trainControl(method = "cv", savePred = T, classProb = T)
                model_fit = train(Species ~ ., data = trainset_selfeature(), method = "svmLinear", trControl = ctrl)
              }else{
                 control <- trainControl(method="repeatedcv", number=10, repeats=3)
                 set.seed(1)
                 model_fit = train(Species ~., data = trainset_selfeature(), method = "rf", trControl = ctrl)
              }
          }
          predict(model_fit, testset_selfeature())
          
     })
     
     output$table <- renderTable({
        cm <- confusionMatrix(pred(), testset()$Species)
        as.matrix(cm)
     }) 
        
 

      
     
     
})
