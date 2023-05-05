# Load required packages
library(shiny)
library(ggplot2)
if (!require(pacman))
  install.packages("pacman")

#Not all these packages are needed here, obviously
pacman::p_load(
  R.devices,
  shiny,
  magrittr,
  dplyr,
  ggplot2,
  shinyWidgets,
  svglite,
  slickR,
  ggpubr
)

# Load iris dataset
data(iris)

# Define UI
ui <- fluidPage(
  # Sidebar panel for inputs
  sidebarPanel(
    # Select x-axis variable
    selectInput("choice", "X-axis variable", choices = c(100, 150)),
  ),
  # Main panel for output
  mainPanel(
    # Plot output
    slickROutput("plot")
  )
)

# Define server
server <- function(input, output, session) {
  observe({
    fig_list = list()
    for (i in 1L:2L){ #Creating two plots to make a carousel
      fig_list[[i]] <- 
        {
          svglite::xmlSVG(
            code = {
              g = ggplot(iris[(40*i):input$choice, ], aes(x = Sepal.Length, 
                                                     y = Petal.Length)) +
                geom_point() 
              print(g)
            },
            standalone = T)
        }
    }
    output[["plot"]] = renderSlickR({
      slickR(fig_list, "plot") +
        settings(
          customPaging = htmlwidgets::JS(
            "function(slick,index) {
                            return '<a>'+(index+1)+'</a>';
                       }"
          ),
          dots = T #if we remove this, then only one plot is generated.
        )
    })
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)
