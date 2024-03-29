
# Populate dropdowns for algorithms (in case of bbob) or suites (in case of NG),
# Only enabled when no study is selected
observe({
  req(input$Ontology.Source)

  if (input$Ontology.Study != 'None') {
    return()
  }

  input_source <- input$Ontology.Source
  if (input_source == "Nevergrad") {
    available_suite <- get_ontology_var("Suite", input_source)

    if (is.null(available_suite) || length(available_suite) == 0) {# TODO: the alert msg should be updated
      shinyjs::alert("No connection could be made with the OPTION ontology. Please try again later.")
      shinyjs::disable('Ontology.Load')
      return()
    }

    updateSelectInput(session, 'Ontology.NG_Suite', choices = available_suite, selected = available_suite[[1]])
    shinyjs::disable('Ontology.Load')
    return()
  }

  # available_functions <- get_ontology_var("Fid", input_source)
  # available_dimensions <- get_ontology_var("DIM", input_source)
  available_algorithms <- get_ontology_var("AlgId", input_source)
  # available_iid <- get_ontology_var("Iid", input_source)

  if (is.null(available_algorithms) || length(available_algorithms) == 0) {# TODO: the alert msg should be updated
    shinyjs::alert("No connection could be made with the OPTION ontology. Please try again later.")
    shinyjs::disable('Ontology.Load')
    return()
  }
  # updateSelectInput(session, 'Ontology.Functions', choices = available_functions, selected = available_functions[[1]])
  # updateSelectInput(session, 'Ontology.Dimensions', choices = available_dimensions, selected = available_dimensions[[1]])
  updateSelectInput(session, 'Ontology.Algorithms', choices = available_algorithms, selected = available_algorithms[[1]])
  # updateSelectInput(session, 'Ontology.Iids', choices = available_iid, selected = available_iid[[1]])
  # shinyjs::enable('Ontology.Load')

})


# Populate algorithm dropdown when NG is selected
observe({
  req(input$Ontology.NG_Suite)

  if (input$Ontology.Study != 'None') {
    return()
  }

  input_suite <- input$Ontology.NG_Suite
  # available_functions <- get_ontology_var("Fid", "Nevergrad", suite = input_suite)
  # available_dimensions <- get_ontology_var("DIM", "Nevergrad", suite = input_suite)
  available_algorithms <- get_ontology_var("AlgId", "Nevergrad", suite = input_suite)

  if (is.null(available_algorithms) || length(available_algorithms) == 0) {# TODO: the alert msg should be updated
    shinyjs::alert("No connection could be made with the OPTION ontology. Please try again later.")
    shinyjs::disable('Ontology.Load')
    return()
  }
  # updateSelectInput(session, 'Ontology.Functions', choices = available_functions, selected = available_functions[[1]])
  # updateSelectInput(session, 'Ontology.Dimensions', choices = available_dimensions, selected = available_dimensions[[1]])
  updateSelectInput(session, 'Ontology.Algorithms', choices = available_algorithms, selected = available_algorithms[[1]])
  # shinyjs::enable('Ontology.Load')
})

observe({
  req(input$Ontology.Algorithms)

  if (input$Ontology.Study != 'None') {
    return()
  }

  input_source <- input$Ontology.Source
  input_suite <- input$Ontology.NG_Suite
  sel_algs <- input$Ontology.Algorithms


  available_functions <- get_ontology_var("Fid", input_source, suite = input_suite, algs = sel_algs)
  available_dimensions <- get_ontology_var("DIM", input_source, suite = input_suite, algs = sel_algs)

  updateSelectInput(session, 'Ontology.Functions', choices = available_functions, selected = available_functions[[1]])
  updateSelectInput(session, 'Ontology.Dimensions', choices = available_dimensions, selected = available_dimensions[[1]])

  if (is.null(available_functions) || length(available_functions) == 0) {# TODO: the alert msg should be updated
    shinyjs::alert("No connection could be made with the OPTION ontology. Please try again later.")
    shinyjs::disable('Ontology.Load')
    return()
  }

  if (input_source == "BBOB") {
    available_iid <- get_ontology_var("Iid", input_source, algs = sel_algs)
    updateSelectInput(session, 'Ontology.Iids', choices = available_iid, selected = available_iid[[1]])
  }
  shinyjs::enable('Ontology.Load')

})


observe({
  study_name <- input$Ontology.Study
  req(!is.null(study_name) & study_name != 'None' & study_name != "")

  used_setting <- get_ontology_var("Repo", study = study_name)

  if (used_setting == "Nevergrad") {
    used_suite <- get_ontology_var("Suite", study = study_name)
    source_name <- "Nevergrad"
    updateSelectInput(session, 'Ontology.NG_Suite', selected = used_suite)
  } else {
      source_name <- "BBOB"
      used_suite <- NULL
  }

  used_algorithms <- get_ontology_var("AlgId", datasource = source_name, study = study_name, suite = used_suite)

  used_functions <- get_ontology_var("Fid", datasource = source_name, study = study_name, algs = used_algorithms, suite = used_suite)
  used_dimensions <- get_ontology_var("DIM", datasource = source_name, study = study_name, algs = used_algorithms, suite = used_suite)

  if (is.null(used_functions) || length(used_functions) == 0) {# TODO: the alert msg should be updated
    shinyjs::alert("No connection could be made with the OPTION ontology. Please try again later.")
    shinyjs::disable('Ontology.Load')
    return()
  }
  # if (used_setting == "Nevergrad"){
  #   updateSelectInput(session, 'Ontology.NG_Suite', selected = used_suite)
  # }
  if (source_name == "BBOB"){
    used_iids <- get_ontology_var("Iid", datasource = source_name, study = study_name, algs = used_algorithms, suite = used_suite)
    updateSelectInput(session, 'Ontology.Iids', selected = used_iids)
  }

  updateSelectInput(session, 'Ontology.Source', selected = source_name)
  updateSelectInput(session, 'Ontology.Functions', selected = used_functions)
  # updateSelectInput(session, 'Ontology.Iids', selected = used_iids)
  updateSelectInput(session, 'Ontology.Dimensions', selected = used_dimensions)
  updateSelectInput(session, 'Ontology.Algorithms', selected = used_algorithms)
  shinyjs::enable('Ontology.Load')
})

# load data from ontology according to selected options
observeEvent(input$Ontology.Load, {
  withProgress({
  req(input$Ontology.Source)


  min_target <- max_target <- NULL
  min_budget <- max_budget <- NULL

  if (input$Ontology.Limit_Targets) {
    min_target <- input$Ontology.Min_Target
    max_target <- input$Ontology.Max_Target
  }
  if (input$Ontology.Limit_Targets) {
    min_budget <- input$Ontology.Min_Budget
    max_budget <- input$Ontology.Max_Budget
  }

  data <- get_ontology_data(input$Ontology.Source,
                            input$Ontology.Functions,
                            input$Ontology.Dimensions,
                            input$Ontology.Algorithms,
                            input$Ontology.Iids,
                            input$Ontology.NG_Suite,
                            min_target, max_target,
                            min_budget, max_budget)


  if (length(DataList$data) > 0 && attr(data, 'maximization') != attr(DataList$data, 'maximization')) {
    shinyjs::alert(paste0("Attempting to add data from a different optimization type to the currently",
                          " loaded data.\nPlease either remove the currently loaded data or",
                          " choose a different dataset to load."))
    return(NULL)
  }

  DataList$data <- c(DataList$data, data)
  update_menu_visibility(attr(DataList$data, 'suite'))
  # set_format_func(attr(DataList$data, 'suite'))
  algids <- get_algId(DataList$data)
  if (!all(algids %in% get_color_scheme_dt()[['algnames']])) {
    set_color_scheme("Default", algids)
  }

  }, message = "Processing data from OPTION ontology. This might take a moment.")
})

