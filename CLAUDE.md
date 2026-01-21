# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Shiny dashboard for the **Baltic Health Index (BHI) 2019 assessment**, an interactive data visualization tool for exploring Baltic Sea health and environmental resource management. The dashboard displays BHI assessment results, input data layers, and intermediate metrics.

**Live deployment:** Currently at https://baltic-ohi.shinyapps.io/dashboard/ (will soon move to https://ocean-src.shinyapps.io/baltic-health-index-2019)

## Architecture

### Shiny Application Structure

The main Shiny app is located in the `dashboard/` directory:

- **`global.R`**: Loads libraries, sets global variables (assessment year = 2019, GitHub URLs), sources all R functions and modules, loads data from SQLite database (`dashboard/data/bhi.db`), and prepares spatial objects (regions, subbasins, MPAs)
- **`ui.R`**: Defines the user interface layout with shinydashboard sidebar navigation organized by goals (AO, BD, CS, CW, etc.)
- **`server.R`**: Contains server-side reactive logic for all dashboard pages. Organized in the same order as the sidebar: welcome page, then goals alphabetically with subgoals nested. Each goal section follows a consistent pattern with score boxes, maps, barplots, data tables, and timeseries plots.

### Modular Components

Located in `dashboard/modules/`, these are Shiny modules providing reusable UI/server pairs:

- `flowerplot_card.R`: Radar/flower plots showing all goals for a selected region
- `map_card.R`: Leaflet maps with goal scores by spatial unit
- `barplot_card.R`: Bar charts comparing scores across regions/subbasins
- `scorebox_card.R`: Value boxes displaying overall goal scores
- `tsplot_card.R`: Time series plots for data layers
- `addfigs_card.R`: Additional figures/visualizations

### Visualization and Mapping Functions

Located in `dashboard/R/`:

- `mapping.R`: Functions to create spatial objects and leaflet maps
  - `make_rgn_sf()`: Joins BHI region shapefile with goal scores
  - `make_subbasin_sf()`: Aggregates scores to HELCOM subbasin level
  - `leaflet_map()`: Creates interactive leaflet maps with score visualization
- `visualization.R`: Functions for plots and charts
  - `scores_barplot()`: Creates barplots of scores by region/subbasin
  - Additional plotting utilities for the dashboard
- `theme.R`: BHI theme customization for visualizations

### Data Storage

All data is stored in `dashboard/data/`:

- `bhi.db`: SQLite database containing:
  - `IndexScores`: Goal scores by dimension, region, and year
  - `Goals`: Goal metadata and names
  - `DataSources`: Information about data layers
  - `FlowerConf`: Configuration for flower plots
  - `Regions`: BHI region metadata
  - `Subbasins`: HELCOM subbasin information
  - `Pressures`: Pressure layers and weights by goal
  - `Resilience`: Resilience components and weights by goal
  - `DataLayers`: Full layer names and metadata
- `regions.rds`, `subbasins.rds`, `mpas.rds`: Spatial shapefiles as R objects

### Rebuild Scripts

Located in `rebuild/`, these scripts are used to regenerate dashboard components:

- `rebuilding.R`: Helper functions for extracting layer information from the BHI repository
- `goalpage.R`: Generates goal page content programmatically
- `flowerplot.R`: Rebuilds flowerplot configurations
- `shinytext.R`: Manages text content for the dashboard

## Goal Structure

The BHI 2019 assessment evaluates 9 goals for Baltic Sea health:

- **AO**: Artisanal Fishing Opportunity
- **BD**: Biodiversity
  - **HAB**: Habitats
  - **SPP**: Species
- **CS**: Carbon Storage
- **CW**: Clean Waters
  - **CON**: Contaminants
  - **EUT**: Eutrophication
  - **TRA**: Trash
- **FP**: Food Provision
  - **FIS**: Fisheries
  - **MAR**: Mariculture
- **LE**: Coastal Livelihoods & Economies
  - **ECO**: Economies
  - **LIV**: Livelihoods
- **NP**: Natural Products
- **SP**: Sense of Place
  - **ICO**: Iconic Species
  - **LSP**: Lasting Special Places
- **TR**: Tourism & Recreation

Each goal in `server.R` follows the same modular pattern:
1. Score box (top right info box)
2. Map visualization with dimension/spatial unit/year reactivity
3. Barplot comparison across regions
4. Data table of input layers
5. Time series plot with layer selection

## Data Flow

1. Assessment year is set in `global.R` (2019)
2. Data is loaded from SQLite database into global environment
3. Scores are organized into nested list structure: `full_scores_lst[[goal]][[dimension]][[year]]`
4. Spatial data is joined with scores to create map-ready objects
5. Reactive inputs (dimension, spatial_unit, view_year) filter data for visualization
6. Modules receive reactive parameters and render outputs

## Spatial Units

The dashboard supports two spatial aggregation levels controlled by `input$spatial_unit`:
- **Regions**: 42 BHI assessment regions (region_id 1-42)
- **Subbasins**: HELCOM subbasins (aggregated from regions using area-weighted averaging)

## External Data Sources

The dashboard references external GitHub repositories:
- `gh_raw_bhi`: https://raw.githubusercontent.com/OHI-Science/bhi/master/baltic2019draft/
- `gh_raw_bhiprep`: https://raw.githubusercontent.com/OHI-Science/bhi-prep/master/
- `gh_prep`: https://github.com/OHI-Science/bhi-prep

## Deployment

The app is hosted on shinyapps.io.

## Key Patterns

### Adding a New Goal

When adding goal pages, follow the established pattern in `server.R`:
1. Create score box with `callModule(scoreBox, "{goal}_infobox", goal_code = "{GOAL}")`
2. Create map with `callModule(mapCard, "{goal}_map", ...)` passing reactive inputs
3. Create barplot with `callModule(barplotCard, "{goal}_barplot", ...)`
4. Create data table filtering `data_info` by goal code
5. Create timeseries plot with reactive layer selection using `observeEvent` pattern

### Reactive Value Pattern

The dashboard uses `reactiveValues()` to track selections:
```r
values <- reactiveValues(`{goal}_tsplot-select` = "default_layer")
observeEvent(input$`{goal}_tsplot-select`, {
  values$`{goal}_tsplot-select` <- input$`{goal}_tsplot-select`
  callModule(tsplotCard, "{goal}_tsplot", layer_selected = reactive(values$`{goal}_tsplot-select`), ...)
})
```

### Dimension Types

The dashboard visualizes multiple dimensions from the OHI framework:
- `score`: Overall goal score (0-100)
- `trend`: Direction and rate of change
- `pressure`: Cumulative pressures affecting the goal
- `resilience`: Management and ecological resilience
- `status`: Current state
- `future`: Projected state

## Custom UI Elements

`convertMenuItem()` function (in `global.R`) enables expandable/collapsible sidebar menu items with subitems, adapted from OHI-Northeast dashboard.
