filler_box <- function(width = 12, collapsible = T, collapsed = T) {
  box(
    title = HTML('<p style="font-size:120%;">Get Provenance Information</p>'),
    width = width, solidHeader = T, status = "primary",
    collapsible = collapsible, collapsed = collapsed,
    # dataTableOutput('data_info')
    selectInput('i9', label = "Please Select the Study Name", choices = c("Dimension Selection in Axis-Parallel Brent-STEP Method
for Black-Box Optimization of Separable Continuous
Functions", "The Impact of Initial Designs on the Performance of
MATSuMoTo on the Noiseless BBOB-2015 Testbed"), selected = "")
  )
}

mockup_box <- function(width = 12, collapsible = F, collapsed = T, 
                           height = '1200px') {
  box(
    title = HTML('<p style="font-size:120%;">Create Query on Ontology</p>'), 
    width = width, height = height, collapsed = collapsed, collapsible = collapsible,
    solidHeader = T, status = "primary",  
    sidebarPanel(
      width = 12,
      
      HTML_P("Create a Query from the ontology:"),
      
      # selectInput('i1', label = "Select the va type source",
      #             choices = c(""), selected = NULL, width = '50%'),
      
      # checkboxInput("c3", "Choose Specific Data Source", value = FALSE),
      # conditionalPanel(condition = 'input["c3"] == true',
      selectInput('i3', label = "Please choose the data source", choices = c("BBOB", "IOHprofiler", "Nevergrad"), selected = "BBOB", width = '50%', multiple = T),
      # ),

      checkboxInput("c4", "Use Specific Functions", value = FALSE),
      conditionalPanel(condition = 'input["c4"] == true',
      selectInput('i4',
                  label = "Please choose the functions",
                  choices = seq(24), selected = seq(10,15), width = '50%', multiple = T)),

      checkboxInput("c5", "Use Specific Dimensions", value = FALSE),
      conditionalPanel(condition = 'input["c5"] == true',
      selectInput('i5',
                  label = "Please choose the dimensions",
                  choices = c(2,5,10,20,40), selected = c(5,20), width = '50%', multiple = T)),

      checkboxInput("c8", "Use Specific Instances", value = FALSE),
      conditionalPanel(condition = 'input["c8"] == true',
                       selectInput('i8',
                                   label = "Please choose the instances",
                                   choices = seq(15), selected = c(1,2,3,4,5), width = '50%', multiple = T)),

      checkboxInput("c6", "Use Specific Algorithms", value = FALSE),
      conditionalPanel(condition = 'input["c6"] == true',
      selectInput('i6',
                  label = "Please choose the algorithm",
                  choices = c("CMA-ES", "DE", "MLSL", "PSO"), selected = c("CMA-ES", "DE"), width = '50%', multiple = T)),
      # radioButtons("i2", label = "Select the type of data to get", choices = c("Fixed-Target", "Fixed-Budget", "Fixed-Probability"), selected = "Fixed-Budget"),

      # checkboxInput("c7", "Use Specific Targets", value = FALSE),
      # conditionalPanel(condition = 'input["c7"] == true',
      # numericInput("i7", label = "Select the Target Value", value = 500)),

      actionButton('o8', 'Load Data')
      
      
    )
  )
}