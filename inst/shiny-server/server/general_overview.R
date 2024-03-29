overview_table_single <- reactive({
  data <- DATA()
  req(length(data) > 0)
  df <- get_overview(subset(data, ID %in% input$Overview.Single.ID))
                     
  df$budget %<>% as.numeric
  df$runs %<>% as.integer
  df$funcId %<>% as.integer
  df$DIM %<>% as.integer
  df$succ %<>% as.integer
  df$"worst recorded" <- format_FV(df$"worst recorded")
  df$"worst reached" <- format_FV(df$"worst reached")
  df$"mean reached" <- format_FV(df$"mean reached")
  df$"median reached" <- format_FV(df$"median reached")
  df$"best reached" <- format_FV(df$"best reached")
  df$"max evals used" %<>% as.numeric
  df
})

output$Overview.Single.Table <- DT::renderDataTable({
  req(input$Overview.Single.ID)
  overview_table_single()
}, filter = list(position = 'top', clear = FALSE),
options = list(dom = 'lrtip', pageLength = 15, scrollX = T, server = T))

output$Overview.Single.Download <- downloadHandler(
  filename = function() {
    eval(overview_single_name)
  },
  content = function(file) {
    df <- overview_table_single()
    df <- df[input[["Overview.Single.Table_rows_all"]]]
    save_table(df, file)
  }
)

overview_table_all <- reactive({
  data <- DATA_RAW()
  req(length(data) > 0)
  df <- get_overview(data)
  df$"worst recorded" <- format_FV(df$"worst recorded")
  df$"worst reached" <- format_FV(df$"worst reached")
  df$"mean reached" <- format_FV(df$"mean reached")
  df$"best reached" <- format_FV(df$"best reached")
  df
})

output$Overview.All.Table <- DT::renderDataTable({
  overview_table_all()
}, filter = list(position = 'top', clear = FALSE),
options = list(dom = 'lrtip', pageLength = 15, scrollX = T, server = T))

output$Overview.All.Download <- downloadHandler(
  filename = function() {
    eval(overview_all_name)
  },
  content = function(file) {
    df <- overview_table_all()
    df <- df[input[["Overview.All.Table_rows_all"]]]
    save_table(df, file)
  }
)