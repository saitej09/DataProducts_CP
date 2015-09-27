library(shiny)
library(dplyr)
library(ggvis)

shinyServer(function(input, output, session) {
        #load the data when the user inputs a file
         
       
        theData <- reactive({
                infile <- input$datfile        
                if(is.null(infile))
                        return(NULL) 
                      
                d <- read.csv(infile$datapath, header=input$header, sep=input$sep)
                
        })
        output$contents <- renderTable({
                dt = theData()
        })
        
        
        # dynamic variable names
        observe({
                data<-theData()
                updateSelectInput(session, 'x', choices = names(data))
                updateSelectInput(session, 'y', choices = names(data))
                
        }) # end observe
        
        #gets the y variable name, will be used to change the plot legends
        yVarName<-reactive({
                input$y
        })
        
        #gets the x variable name, will be used to change the plot legends
        xVarName<-reactive({
                input$x
        })
        
        #make the filteredData frame
        
        filteredData<-reactive({
                data<-isolate(theData())
                #if there is no input, make a dummy dataframe
                if(input$x=="x" && input$y=="y"){
                        if(is.null(data)){
                                data<-data.frame(x=0,y=0)
                        }
                }else{
                        data<-data[,c(input$x,input$y)]
                        names(data)<-c("x","y")
                }
                data
        })
        
        #plot the ggvis plot in a reactive block so that it changes with filteredData
        vis<-reactive({
                plotData<-filteredData()
                plotData %>%
                        ggvis(~x, ~y,opacity  := input$opacity) %>%
                        
                        layer_lines(stroke := "red", strokeWidth := 1) %>%
                        add_axis("y", title = yVarName()) %>%
                        add_axis("x", title = xVarName()) %>%
                        add_tooltip(function(df) format(sqrt(df$x),digits=2))
        })
        vis%>%bind_shiny("plot", "plot_ui")
        
})