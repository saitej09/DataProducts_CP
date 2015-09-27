library(ggvis)
library(shiny)
#uploaded dataset viewer
shinyUI(fluidPage(
        # Application title
        titlePanel("XY Plots from a csv file"),
        # Sidebar with controls to upload a csv and specify the number
        # of observations to view 
        div(),
        sidebarPanel(
                fileInput('datfile', 'Choose CSV File',
                          accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                tags$hr(), #horizontal line
                checkboxInput('header', 'Header', TRUE),
                radioButtons('sep', 'Separator',
                             c(Comma=',',
                               Semicolon=';',
                               Tab='\t'),
                             'Comma'),
                #sliderInput("size", "Stroke Width:", 
                        #    min=0, max=5, value=1,step= 0.5),
                
                #numericInput("obs", "Number of observations to view:", 10),
                selectInput('x', 'x:' ,'x'),
                selectInput('y', 'y:', 'y'),
                sliderInput("opacity", "Opacity", 
                            min = 0, max = 1, value = 1, step= 0.1),
                uiOutput("plot_ui")
        ),
        mainPanel(
                tabsetPanel(
                        
                        #tabPanel("Summary", verbatimTextOutput("summary")), 
                        tabPanel("Table", tableOutput('contents')),
                        tabPanel("Plot", ggvisOutput("plot")),
                        tabPanel("About the App",
                                 mainPanel(
                                         includeMarkdown("Appdetails.md")
                                 )
                        )
                )
        )
        )
)