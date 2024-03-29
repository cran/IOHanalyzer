rt_histogram_box <- function(width = 12, collapsed = T, collapsible = T) {
  box(title = 'Histogram of Fixed-Target Runtimes',
      width = width, collapsible = collapsible, solidHeader = TRUE, collapsed = collapsed,
      status = "primary",
      sidebarPanel(
        width = 2,
        textInput('RTPMF.Hist.Target', label = HTML('Select the target value'),
                  value = ''),
        selectInput(
          'RTPMF.Hist.Algs',
          label = 'Select which IDs to include:',
          multiple = T, 
          selected = NULL, 
          choices = NULL
          ) %>% 
          shinyInput_label_embed(
            custom_icon() %>%
              bs_embed_popover(
                title = "ID selection", 
                content = alg_select_info, 
                placement = "auto"
                )
            ),

        HTML_P('Choose whether the histograms are <b>overlaid</b> in one plot
             or <b>separated</b> in several subplots:'),
        selectInput('RTPMF.Hist.Mode', '',
                    choices = c("overlay", "subplot"),
                    selected = 'subplot'),
        checkboxInput("RTPMF.Hist.Equal", "Use equal bins for all algorithms", F),
        hr(),
        selectInput('RTPMF.Hist.Format', label = 'Select the figure format',
                    choices = supported_fig_format, selected = supported_fig_format[[1]]),

        downloadButton('RTPMF.Hist.Download', label = 'Download the figure')
      ),

      mainPanel(
        width = 10,
        column(
          width = 12, align = "center",
          HTML_P('This histogram counts how many runs needed between
                  \\(t\\) and \\(t+1\\) function evaluations. The bins
                  \\([t,t+1)\\) are chosen automatically. The bin size is determined
                  by the so-called <b>Freedman–Diaconis rule</b>: \\(\\text{Bin size}=
                  2\\frac{Q_3 - Q_1}{\\sqrt[3]{n}}\\), where \\(Q_1, Q_3\\) are the \\(25\\%\\)
                  and \\(75\\%\\) percentile of the runtime and \\(n\\) is the sample size.
                  The displayed algorithms can be selected by clicking on the legend on the right.
                  A <b>tooltip</b> and <b>toolbar</b> appears when hovering over the figure.'),
          plotlyOutput.IOHanalyzer('RT_HIST', aspect_ratio = 16/14)
        )
      )
  )
}

rt_pmf_box <- function(width = 12, collapsed = T, collapsible = T) {
  box(title = 'Empirical Probability Mass Function of the Runtime',
      width = width, collapsible = collapsible, solidHeader = TRUE,
      status = "primary", collapsed = collapsed,
      sidebarLayout(
        sidebarPanel(
          width = 2,
          textInput('RTPMF.Bar.Target', label = 'Select the target value', value = ''),
          
          selectInput(
            'RTPMF.Bar.Algs',
            label = 'Select which IDs to include:',
            multiple = T, 
            selected = NULL, 
            choices = NULL
            ) %>% 
            shinyInput_label_embed(
              custom_icon() %>%
                bs_embed_popover(
                  title = "ID selection", 
                  content = alg_select_info, 
                  placement = "auto"
                  )
              ),
          
          # checkboxInput('RTPMF.Bar.Sample', label = 'Show runtime for each run', value = T),
          checkboxInput('RTPMF.Bar.Logy', label = 'Scale y axis \\(\\log_{10}\\)', value = F),
          checkboxInput('RTPDF.Bar.Points', label = 'Show individual points', value = F),
          hr(),
          selectInput('RTPMF.Bar.Format', label = 'Select the figure format',
                      choices = supported_fig_format, selected = supported_fig_format[[1]]),

          downloadButton('RTPMF.Bar.Download', label = 'Download the figure')
        ),

        mainPanel(
          width = 10,
          column(
            width = 12, align = "center",
            HTML('<p align="left" style="font-size:120%;"><b>Warning! </b>The
                 <b>probability mass function</b> of the runtime is approximated by the
                 treating the runtime as a <i>continuous</i> random variable and 
                 applying the <b>kernel estimation</b> (KDE):</p>'),
            HTML('<p align="left" style="font-size:120%;">
                 The plot shows the distribution of the first hitting
                 times of the individual runs (dots), and an estimated
                 distribution of the probability mass function.
                 The displayed algorithms can be selected by clicking on
                 the legend on the right. A <b>tooltip</b> and <b>toolbar</b>
                 appear when hovering over the figure. This also includes the
                 option to download the plot as png file. A csv file with the runtime
                 data can be downlowaded from the
                 <a href="#shiny-tab-ERT_data", data-toggle="tab"> Data Summary tab</a>.'),
            plotlyOutput.IOHanalyzer('RT_PMF')
            )
          )
        )
      )
}
