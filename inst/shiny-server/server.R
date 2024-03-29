
repo_dir <- ''         # repository directory
repo_data <- NULL      # repository data
has_rendered_ERT_per_fct <- FALSE

# Formatter for function values. Somewhat overkill with as.numeric, but this prevents unneeded precision
format_FV <- function(v) as.numeric(format(v, digits = getOption("IOHanalyzer.precision", 2),
                                nsmall = getOption("IOHanalyzer.precision", 2)))
format_RT <- function(v) as.integer(v)

# directory where data are extracted from the zip file
exdir <- file.path(tempdir(), 'data')

rand_strings <- function(n = 10) {
  a <- do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE))
  paste0(a, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
}

setTextInput <- function(session, id, name, alternative) {
  v <- REG[[id]]
  if (name %in% names(v))
    updateTextInput(session, id, value = v[[name]])
  else
    updateTextInput(session, id, value = alternative)
}

# register previous text inputs, which is used to restore those values
REG <- lapply(widget_id, function(x) list())

# TODO: maybe give this function a better name
# get the current 'id' of the selected data: funcID + DIM
get_data_id <- function(dsList) {
  if (is.null(dsList) | length(dsList) == 0)
    return(NULL)

  paste(get_funcId(dsList), get_dim(dsList), sep = '-')
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  # clean up the temporarsy files on server when exiting
  session$onSessionEnded(function() {
    # close_connection()
    unlink(exdir, recursive = T)
  })

  for (f in list.files('server', pattern = '.R', full.names = T)) {
    source(f, local = TRUE)
  }

  output$VersionBox <- renderValueBox({
    infoBox(title = "IOHanalyzer version:", value = paste0('v', packageVersion("IOHanalyzer")), icon = icon("code-branch"),
      color = "blue", width = 12, fill = T, href = "https://github.com/IOHprofiler/IOHanalyzer", subtitle = "View source on Github"
    )})
  output$WikiBox <- renderValueBox({
    infoBox(title = "Wiki Page", value = "For full documentation of IOHprofiler", icon = icon("wikipedia-w"),
            color = "blue", width = 12, fill = T, href = "https://iohprofiler.github.io/"
    )})
  output$ContactBox <- renderValueBox({
    infoBox(title = "Contact us by email:", value = "iohprofiler@liacs.leidenuniv.nl", icon = icon("envelope"),
            color = "blue", width = 14, fill = T, href = "mailto:iohprofiler@liacs.leidenuniv.nl"
    )
  })
  available_studies <- get_ontology_var("Study")
  if (is.null(available_studies)) {
    shinyjs::disable("Loading.Type")
  }
  else {
    updateSelectInput(session, 'Ontology.Study', choices = c('None', available_studies), selected = 'None')
  }
})
