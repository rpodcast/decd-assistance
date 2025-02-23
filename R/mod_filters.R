#' filters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filters_ui <- function(id){
  ns <- NS(id)
  tagList(

    shiny::fluidRow(

      shiny::column(
        width = 2,

        # Year range filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_year"),
          label = "Select Fiscal Year",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(
            `actions-box` = TRUE,
            `selected-text-format` = 'count > 2',
            `select-all-text` = "All"
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

        # City drop-down filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_city"),
          label = "Select City",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(
            `actions-box` = TRUE,
            `selected-text-format` = 'count > 1',
            `select-all-text` = "All"
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

        # Industry drop-down filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_industry"),
          label = "Select Industry",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = shinyWidgets::pickerOptions(
            actionsBox = TRUE,
            selectedTextFormat = "count > 1",
            selectAllText = "All",
            virtualScroll = 200L
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

        # Funding Source drop-down filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_funding_source"),
          label = "Select Funding Source",
          choices = c("Manufacturing Assistance Act", "Small Business Express Program"),
          selected = c("Manufacturing Assistance Act", "Small Business Express Program"),
          multiple = TRUE,
          options = list(
            `actions-box` = TRUE,
            `selected-text-format` = 'count > 1',
            `select-all-text` = "All"
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 1,

        # Apply Filters button
        shiny::actionButton(
          class = "btn btn-primary",
          inputId = ns("apply"),
          label = "Apply",
          width = NULL
        ),

        shiny::br(),
        shiny::br(),

        # Reset Filters button
        shiny::actionButton(
          class = "btn btn-warning",
          inputId = ns("reset"),
          label = "Reset",
          width = NULL
        )

      )

    )

  )
}

#' filters Server Functions
#'
#' @noRd
mod_filters_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Create a reactive value object called `current_data`
    # Default is entire data set
    current_data <- reactiveVal(data)

    shiny::observe({

      min_year <- min(data$fiscal_year)
      max_year <- max(data$fiscal_year)

      shiny::updateSliderInput(
        session = session,
        inputId = "filter_year",
        value = c(min_year, max_year),
        min = min_year,
        max = max_year
      )

      years <- unique(data$fiscal_year) |> sort()

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_year",
        choices = years,
        selected = years
      )

      cities <- unique(data$city) |> sort()

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_city",
        choices = cities,
        selected = cities
      )

      industries <- unique(data$industry) |> sort()

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_industry",
        choices = industries,
        selected = industries
      )

    })

    # when user applies filter, update the reactive value for data accordingly
    observe({

      df <- data |>
        dplyr::filter(
          fiscal_year %in% input$filter_year,
          city %in% input$filter_city,
          funding_source %in% input$filter_funding_source,
          industry %in% input$filter_industry
        )

      # Update the`current_data` reactive val to be the filtered data
      current_data(df)

    }) |>
      shiny::bindEvent(input$apply)

    return(current_data)

  })
}

## To be copied in the UI
# mod_filters_ui("filters_1")

## To be copied in the server
# mod_filters_server("filters_1")
