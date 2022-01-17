library(readr)
library(plotly)
library(shiny)
library(shinydashboard)

#Reading data
Sample_data <- read_csv("Sample_data.csv", 
                        col_types = cols(hourly_load = col_number(), 
                                         Predicted = col_double()), na = "NA")

#Plotting data
main_plot <-  plot_ly(Sample_data, 
                      x = ~Time)

main_plot <- main_plot %>% add_lines(y = ~hourly_load, name = "Hourly Load", type = 'scatter', mode = 'lines')
main_plot <- main_plot %>% add_lines(y = ~Predicted, name = "Predicted", type = 'scatter', mode = 'lines', visible = FALSE)



#This modifies the look of graph
main_plot <- main_plot %>% layout(plot_bgcolor='#e5ecf6', 
                                  xaxis = list(
                                    title = 'Time',
                                    range = c('2020-01-01 00:00:00', '2020-12-31 23:00:00'),
                                    zerolinecolor = '#ffff',
                                    zerolinewidth = 2,
                                    gridcolor = 'ffff'),
                                  yaxis = list(
                                    title = "Hourly Load (MW)",
                                    range = c(5000, 35000),
                                    zerolinecolor = '#ffff',
                                    zerolinewidth = 2,
                                    gridcolor = 'ffff'))

#This is for variable range selection of data
main_plot <- main_plot %>% layout(
  title = "Hourly Load",
  xaxis = list(
    rangeselector = list(
      buttons = list(
        list(
          count = 3,
          label = "3 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 6,
          label = "6 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 1,
          label = "1 yr",
          step = "year",
          stepmode = "backward"),
        list(step = "all",
             label = "All"))),
    
    rangeslider = list(type = "date"))
  )



#This gives the feature of multiple selection of Y-Axis
main_plot <- main_plot %>% layout(updatemenus = list(
  list(
    x = 1.3,
    y = 0.0,
    buttons = list(
      list(method = "restyle",
           args = list("visible", list(TRUE, FALSE)),
           label = "Hourly Load"),
      
      list(method = "restyle",
           args = list("visible", list(FALSE, TRUE)),
           label = "Predicted")))
))

#This gives objects for plot of temperatures of different cities
Lhr_plot <- plot_ly(Sample_data, x = ~Time , y = ~Lahore_apparentTemperature, type = 'scatter', mode = 'lines')
Mul_plot <- plot_ly(Sample_data, x = ~Time , y = ~Multan_apparentTemperature, type = 'scatter', mode = 'lines')
Fsl_plot <- plot_ly(Sample_data, x = ~Time , y = ~Faislabad_apparentTemperature, type = 'scatter', mode = 'lines')
Qut_plot <- plot_ly(Sample_data, x = ~Time , y = ~Quetta_apparentTemperature, type = 'scatter', mode = 'lines')
Psh_plot <- plot_ly(Sample_data, x = ~Time , y = ~Peshawar_apparentTemperature, type = 'scatter', mode = 'lines')
Guj_plot <- plot_ly(Sample_data, x = ~Time , y = ~Gujranwala_apparentTemperature, type = 'scatter', mode = 'lines')
Hyd_plot <- plot_ly(Sample_data, x = ~Time , y = ~Hyderabad_apparentTemperature, type = 'scatter', mode = 'lines')
Suk_plot <- plot_ly(Sample_data, x = ~Time , y = ~Sukkur_apparentTemperature, type = 'scatter', mode = 'lines')
Isl_plot <- plot_ly(Sample_data, x = ~Time , y = ~Islamabad_apparentTemperature, type = 'scatter', mode = 'lines')



ui <- dashboardPage(
  dashboardHeader(title = "Energy consumption"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(plotlyOutput("plot"), 
          width = 12, 
          status = "primary"),
      tabBox(title = "Temperature",
             width = 12,
             id = "tabset1",
             tabPanel("Lahore", Lhr_plot),
             tabPanel("Multan", Mul_plot),
             tabPanel("Faisalabad", Fsl_plot),
             tabPanel("Quetta", Qut_plot),
             tabPanel("Peshawar", Psh_plot),
             tabPanel("Gujranwala", Guj_plot),
             tabPanel("Hyderabad", Hyd_plot),
             tabPanel("Sukkur", Suk_plot),
             tabPanel("Islamabad", Isl_plot))
    )
           
  )
)

server <- function(input, output) {
  output$plot <- renderPlotly({
    main_plot
  })
}

shinyApp(ui, server)

