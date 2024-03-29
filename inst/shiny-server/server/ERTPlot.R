# The expected runtime plot ---------------------
# TODO: wrapp this as a separate function for DataSet class
# TODO: add very brief explanation on each function here

output$ERT_PER_FUN <- renderPlotly({
  render_ert_per_fct()
})

get_data_ERT_PER_FUN <- reactive({
  req(input$ERTPlot.Min, input$ERTPlot.Max, length(DATA()) > 0)
  selected_algs <- input$ERTPlot.Algs
  data <- subset(DATA(), ID %in% input$ERTPlot.Algs)
  fstart <- input$ERTPlot.Min %>% as.numeric
  fstop <- input$ERTPlot.Max %>% as.numeric
  budget <- input$ERTPlot.Additional.Budget %>% as.numeric
  options('IOHanalyzer.PAR_penalty' = input$ERTPlot.ParX)
  generate_data.Single_Function(data, fstart, fstop, input$ERTPlot.semilogx, 
                                'by_RT', include_opts = input$ERTPlot.inclueOpts, 
                                budget = budget)
})

render_ert_per_fct <- reactive({
  withProgress({
    y_attrs <- c()
    if (input$ERTPlot.show.ERT) y_attrs <- c(y_attrs, 'ERT')
    if (input$ERTPlot.show.Par) y_attrs <- c(y_attrs, paste0('PAR-', input$ERTPlot.ParX))
    if (input$ERTPlot.show.median) y_attrs <- c(y_attrs, 'median')
    if (input$ERTPlot.show.fixed_prob) {
      y_attrs <- c(y_attrs, paste0(input$ERTPlot.Fixed_Prob * 100, '%'))
      options('IOHanalyzer.quantile' = unique(c(getOption('IOHanalyzer.quantile'), input$ERTPlot.Fixed_Prob)))
    }
    show_legend <- T
    if (length(y_attrs) > 0) {
      p <- plot_general_data(get_data_ERT_PER_FUN(), x_attr = 'target', y_attr = y_attrs, 
                             type = 'line', legend_attr = 'ID', show.legend = show_legend, 
                             scale.ylog = input$ERTPlot.semilogy,
                             scale.xlog = input$ERTPlot.semilogx, x_title = "Best-so-far f(x)-value",
                             y_title = "Function Evaluations",
                             scale.reverse = !attr(DATA(), 'maximization'))
      show_legend <- F
    }
    else
      p <- NULL
    if (input$ERTPlot.show.CI) {
      p <- plot_general_data(get_data_ERT_PER_FUN(), x_attr = 'target', y_attr = 'mean', 
                             type = 'ribbon', legend_attr = 'ID', lower_attr = 'lower', 
                             upper_attr = 'upper', p = p, show.legend = show_legend, 
                             scale.ylog = input$ERTPlot.semilogy,
                             scale.xlog = input$ERTPlot.semilogx, x_title = "Best-so-far f(x)-value",
                             y_title = "Function Evaluations",
                             scale.reverse = !attr(DATA(), 'maximization'))
      show_legend <- F
    }
    if (input$ERTPlot.show.Quantiles) {
      quantiles <- paste0(getOption("IOHanalyzer.quantiles", c(0.2, 0.98)) * 100, '%')
      p <- plot_general_data(get_data_ERT_PER_FUN(), x_attr = 'target', y_attr = 'median', 
                             type = 'ribbon', legend_attr = 'ID', lower_attr = quantiles[[1]], 
                             upper_attr = quantiles[[length(quantiles)]], p = p, 
                             show.legend = show_legend, 
                             scale.ylog = input$ERTPlot.semilogy,
                             scale.xlog = input$ERTPlot.semilogx, x_title = "Best-so-far f(x)-value",
                             y_title = "Function Evaluations",
                             scale.reverse = !attr(DATA(), 'maximization'))
      show_legend <- F
    }
    if (input$ERTPlot.show.runs) {
      fstart <- isolate(input$ERTPlot.Min %>% as.numeric)
      fstop <- isolate(input$ERTPlot.Max %>% as.numeric)
      data <- isolate(subset(DATA(), ID %in% input$ERTPlot.Algs))
      dt <- get_RT_sample(data, seq_FV(get_funvals(data), from = fstart, to = fstop, length.out = 50,
                                       scale = ifelse(isolate(input$ERTPlot.semilogx), 'log', 'linear')))
      nr_runs <- ncol(dt) - 4
      for (i in seq_len(nr_runs)) {
        p <- plot_general_data(dt, x_attr = 'target', y_attr = paste0('run.', i), type = 'line',
                               legend_attr = 'ID', p = p, show.legend = show_legend, 
                               scale.ylog = input$ERTPlot.semilogy,
                               scale.xlog = input$ERTPlot.semilogx, x_title = "Best-so-far f(x)-value",
                               y_title = "Function Evaluations",
                               scale.reverse = !attr(DATA(), 'maximization'))
        show_legend <- F
      }
    }
    p
  },
  message = "Creating plot"
  )
})

output$ERTPlot.Download <- downloadHandler(
  filename = function() {
    eval(FIG_NAME_ERT_PER_FUN)
  },
  content = function(file) {
    save_plotly(render_ert_per_fct(), file)
  },
  contentType = paste0('image/', input$ERTPlot.Format)
)

# update_ert_per_fct_axis <- observe({
#   plotlyProxy("ERT_PER_FUN", session) %>%
#     plotlyProxyInvoke(
#       "restyle", 
#       list(
#         xaxis = list(title = 'best-so-far-f(x)-value', 
#                      type = ifelse(input$ERTPlot.semilogx, 'log', 'linear')),
#         yaxis = list(title = 'function evaluations', 
#                      type = ifelse(input$ERTPlot.semilogy, 'log', 'linear'))
#       )
#     )
# })
# 
# render_ert_per_fct <- reactive({
#   withProgress({
#     req(input$ERTPlot.Min, input$ERTPlot.Max, length(DATA()) > 0)
#     selected_algs <- input$ERTPlot.Algs
#     
#     data <- subset(DATA(), algId %in% input$ERTPlot.Algs)
#     req(length(data) > 0)
#     
#     fstart <- input$ERTPlot.Min %>% as.numeric
#     fstop <- input$ERTPlot.Max %>% as.numeric
#     
#     Plot.RT.Single_Func(data, Fstart = fstart, Fstop = fstop,
#                        show.CI = input$ERTPlot.show.CI,
#                        show.ERT = input$ERTPlot.show.ERT,
#                        show.mean = input$ERTPlot.show.mean,
#                        show.median = input$ERTPlot.show.median,
#                        scale.xlog = input$ERTPlot.semilogx,
#                        scale.ylog = isolate(input$ERTPlot.semilogy),
#                        includeOpts = input$ERTPlot.inclueOpts,
#                        scale.reverse = !attr(data, 'maximization'))
#   },
#   message = "Creating plot"
#   )
# })

output$ERTPlot.Multi.Plot <- renderPlotly(
  render_ERTPlot_multi_plot()
)

get_data_ERT_multi_func_bulk <- reactive({
  data <- subset(DATA_RAW(), 
                 DIM == input$Overall.Dim)
  if (length(get_id(data)) < 20) { #Arbitrary limit for the time being
    rbindlist(lapply(get_funcId(data), function(fid) {
      generate_data.Single_Function(subset(data, funcId == fid), scale_log = input$ERTPlot.Multi.Logx, 
                                    which = 'by_RT')
    }))
  }
  else
    NULL
})

get_data_ERT_multi_func <- reactive({
  req(isolate(input$ERTPlot.Multi.Algs))
  input$ERTPlot.Multi.PlotButton
  data <- subset(DATA_RAW(),
                 DIM == input$Overall.Dim)
  if (length(get_funcId(data)) < 2) {
    shinyjs::alert("This functionality is only available when 2 or more functions
                   are present in the dataset")
  }
  if (length(get_id(data)) < 20 & length(get_funcId(data)) < 30) {
    get_data_ERT_multi_func_bulk()[(ID %in% isolate(input$ERTPlot.Multi.Algs)) &
                                     (funcId %in% isolate(input$ERTPlot.Multi.Funcs)), ]
  }
  else {
    selected_algs <- isolate(input$ERTPlot.Multi.Algs)
    data <- subset(DATA_RAW(),
                   ID %in% selected_algs,
                   funcId %in% isolate(input$ERTPlot.Multi.Funcs),
                   DIM == input$Overall.Dim)
    rbindlist(lapply(get_funcId(data), function(fid) {
    generate_data.Single_Function(subset(data, funcId == fid), scale_log = input$ERTPlot.Multi.Logx, 
                                  which = 'by_RT')
    }))
  }
})

render_ERTPlot_multi_plot <- reactive({
  req(isolate(input$ERTPlot.Multi.Algs))
  withProgress({
    dt <- get_data_ERT_multi_func()
    if (is.null(dt)) 
      return(NULL)
  plot_general_data(dt, x_attr = 'target', y_attr = 'ERT', 
                    subplot_attr = 'funcId', type = 'line', scale.xlog = input$ERTPlot.Multi.Logx, 
                    scale.ylog = input$ERTPlot.Multi.Logy, x_title = 'Best-so-far f(x)', 
                    y_title = 'ERT', show.legend = T,
                    scale.reverse = !attr(DATA(), 'maximization'))
  },
  message = "Creating plot")
})

output$ERTPlot.Multi.Download <- downloadHandler(
  filename = function() {
    eval(FIG_NAME_ERT_PER_FUN_MULTI)
  },
  content = function(file) {
    save_plotly(render_ERTPlot_multi_plot(), file)
  },
  contentType = paste0('image/', input$ERTPlot.Multi.Format)
)




