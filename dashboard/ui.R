## Setting up Dashboard
dashboardPage(
  dashboardHeader(
    title = "Ocean Health Index for the Baltic Sea, 2019 Assessment",
    # titleWidth = 380
    titleWidth = 548
  ),
  
  ## DASHBOARD SIDEBAR ----
  dashboardSidebar(
    width = 290,

    sidebarMenu(
      ## welcome ----
      menuItem("WELCOME", tabName = "welcome"),
      
      ## index calculation ----
      menuItem("INDEX CALCULATION", tabName = "indexcalculation"),
      
      
      ## explore goals ----
      convertMenuItem(
        menuItem(
          "EXPLORE THE GOALS",
          tabName = "explore",
          startExpanded = TRUE,
          
          ## AO Artisanal Fishing Opportunity
          menuSubItem("Artisanal Fishing Opportunity", tabName = "ao", icon = icon(thm$icons$AO)),
          
          ## BD Biodiversity
          menuSubItem("Biodiversity", tabName = "bd", icon = icon(thm$icons$BD)),
          
          ## CS Carbon Storage
          menuSubItem("Carbon Storage", tabName = "cs", icon = icon(thm$icons$CS)),
          
          ## CW Clean Water
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$CW),
              "Clean Water",
              tabName = "cw",
              startExpanded = FALSE,
              
              menuSubItem("Contaminants", tabName = "con"),
              menuSubItem("Eutrophication", tabName = "eut"),
              menuSubItem("Trash", tabName = "tra")
            ), # end clean water menu item
            tabName = "cw"
          ), # end clean water collapse menu item
          
          ## FP Food Provision
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$FP),
              "Food Provision",
              tabName = "fp",
              startExpanded = FALSE,
              
              menuSubItem("Wild-Caught Fisheries", tabName = "fis"),
              menuSubItem("Mariculture", tabName = "mar")
            ), # end food provision menu item
            tabName = "fp"
          ), # end food provision collapse menu item
          
          ## LE Livelihoods & Economies
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$LE),
              "Livelihoods & Economies",
              tabName = "le",
              startExpanded = FALSE,
              
              menuSubItem("Economies", tabName = "eco"),
              menuSubItem("Livelihoods", tabName = "liv")
            ), # end liv and econ menu item
            tabName = "le"
          ), # end liv and econ menu item collapse menu item'
          
          ## SP Sense of Place
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$SP),
              "Sense of Place",
              tabName = "sp",
              startExpanded = FALSE,
              
              menuSubItem("Iconic Species", tabName = "ico"),
              menuSubItem("Lasting Special Places", tabName = "lsp")
            ), # end sense of place menu item
            tabName = "sp"), # end sense of place menu item collapse menu item
          
          ## NP Natural Products
          menuSubItem("Natural Products", tabName = "np", icon = icon(thm$icons$NP)),
          
          ## TR Tourism
          menuSubItem("Tourism", tabName = "tr", icon = icon(thm$icons$TR))
          
          
        ), # end explore goals menu item
        tabName = "explore"), # end explore goals collapse menu item
      
      ## compare and summarize ----
      # menuItem(
      #   "COMPARE & SUMMARIZE",
      #   tabName = "summaries",
      #   startExpanded = FALSE,
      #   
      #   menuSubItem(
      #     "Likely Future versus Present",
      #     tabName = "futures"
      #   ),
      #   menuSubItem(
      #     "Pressures",
      #     tabName = "pressures"
      #   ),
      #   menuSubItem(
      #     "Scenario Exploration",
      #     tabName = "scenarios"
      #   ),
      #   menuSubItem(
      #     "Data Layers",
      #     tabName = "layers"
      #   )
      # ), # end compare and summarize sidebar
      
      ## view options ----
      menuItem(
        "VIEW OPTIONS",
        tabName = "summaries",
        startExpanded = FALSE,
        
        ## input year ----
        sliderInput("view_year", "Year", min = 2019, max = 2019, value = 2019, step = 1, sep = ""),
        
        ## input spatial unit ----
        selectInput(
          "spatial_unit",
          "Spatial Units",
          choices = c(
            `BHI Regions` = "regions",
            `Subbasins` = "subbasins"
          ),
          selected = "regions"
        ),
        
        ## input dimension ----
        selectInput(
          "dimension",
          "Index Dimension",
          choices = c(
            `Score` = "score",
            `Likely Future` = "future",
            `Pressures` = "pressures",
            `Resilience` = "resilience",
            `Current Status` = "status",
            `Short Term Trend` = "trend"
          ),
          selected = "score"
        )
      ), # end view options sidebar
      
      ## learn more ----
      menuItem("LEARN MORE", tabName = "learnmore"),
      
      ## share feedback ----
      menuItem("SHARE FEEDBACK", tabName = "feedback")
      
    ) # end sidebarMenu
  ), # end dashboardSidebar
  
  ## DASHBOARD BODY ----
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$style(
        # border-color: #3c8dbc;  
        # background-color: #f6f9f0; 
        # background-color: #1c3549;
        # background-color: #081010;
        HTML("
          .column_eight {
             border-color: #599089;
             border-width: 1px;
             border-top-width: 6px;
             border-style: solid;
             border-top-style: solid;
             margin: 15px;
             margin-right: 0px;
             margin-top: 0px;
             width: 100%;
             padding: 12px;
             background-color: #061521;
             color: #ecf9f6;
          }
          .column_four {
             border-color: #599089;
             border-width: 1px;
             border-top-width: 6px;
             border-style: solid;
             border-top-style: solid;
             margin: 15px;
             margin-left: 0px;
             margin-top: 0px;
             width: 96%;
             padding: 12px;
             background-color: #061521;
             color: #ecf9f6;
          }
          .columns_container {
             display: grid;
             grid-auto-flow: column;
             grid-template-columns: 8fr 4fr;
             gap: 45px;
          } 
        ")
      )
    ),
    tags$head(tags$style("h4 {color:#3c8dbc;}")),
    tags$script(HTML("$('body').addClass('fixed');")), # lock side and top bars
    
    
    ## color overrides ----
    ## most of these apply to goal score boxes
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "yellow",
        dplyr::filter(thm$palettes$goals_pal, goal == "AO")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "fuchsia",
        dplyr::filter(thm$palettes$goals_pal, goal == "NP")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "orange",
        dplyr::filter(thm$palettes$goals_pal, goal == "CS")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "red",
        dplyr::filter(thm$palettes$goals_pal, goal == "TR")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "purple",
        dplyr::filter(thm$palettes$goals_pal, goal == "LE")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "green",
        dplyr::filter(thm$palettes$goals_pal, goal == "BD")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "olive",
        dplyr::filter(thm$palettes$goals_pal, goal == "CW")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "blue",
        dplyr::filter(thm$palettes$goals_pal, goal == "SP")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "aqua",
        dplyr::filter(thm$palettes$goals_pal, goal == "FP")$color)
    ),
    ## this overrides to make same as dashboard background color
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "light-blue",
        "#def3b6"
      )
    ),
    
    ## PAGES ----
    tabItems(
      ## § welcome ----
      tabItem(
        tabName = "welcome",

        fluidRow(
          box(
            title = tagList(tags$h3("Measuring the Health of our Oceans")),
            collapsible = TRUE,
            collapsed = TRUE,
            status = "primary",
            p("Oceans provide a diverse array of benefits to humans, often with tradeoffs between benefits. Managing these requires a method that can measure the health status in both a comprehensive and quantitative way. Establishing such a method was the motivation behind the Ocean Health Index (OHI)."),
            p("The Baltic Health Index is a regional study using the OHI method but tailored to assess the health status of the social-ecological system of the Baltic Sea. It is an independent, fully-transparent, scientific index which quantifies the status and trends of nine benefits based on inputs from scientists with expertise in each goal area, and stakeholder perspectives. The assessment of the nine benefits includes food provision, artisanal fishing opportunity, natural products, carbon storage, biodiversity, clean water, tourism, livelihood and economy, sense of place."),
            p("Our overarching aim is to maintain and continually improve a tool that can be used by decision-makers to guide management of the Baltic Sea region towards increased sustainability. We strive to use the best open source tools available, to make our data preparation, results, calculations, reference levels and underlying data easily accessible and entirely transparent."),
            width =  12
          )
        ),
        
        ## plots and maps and links
        fluidRow(
          
          ## flowerplot
          flowerplotCardUI(
            id = "baltic_flowerplot",
            title_text = "Aggregated Index Scores",
            sub_title_text = "Individual goal scores are represented by the lengths of the petals in the flowerplot below, and the overall Index score for the region is in the center. Scores under 100 indicate failure to reach the 'acceptable' levels decided upon by the relevant governing bodies, and science experts.",
            additional_text = "Ocean Health Index scores are calculated for individual goals and then combined to get an overall score on a scale of 0-100, where 100 indicates management thresholds are achieved (not necessarily pristine condition)."
          ),

          ## map of overall scores
          tagList(

            box(
              solidHeader = TRUE,
              list(
                ## video
                htmlOutput("iframe_video"),
                br(),
                ## index scores map
                h4("Index Scores around the Baltic Sea"),
                list(
                  list(addSpinner(leafletOutput("index_map", height = 390), spin = "rotating-plane", color = "#d7e5e8"))
                )
              ),
              width = 6
            )
          )
        ),
        
        fluidRow(
          box(
            solidHeader = TRUE,
            h4("The Baltic Health Index Project"),
            br(),
            p("Funding for the BHI2.0, started January 2019 and ongoing, comes from the Johansson Family foundation and partly from the Formas-funded project “When the sum is unknown - a concrete approach to disentangle multiple driver impacts on the Baltic Sea ecosystem”(led by Thorsten Blenckner). The first phase was funded by the Johansson Family foundation and the Baltic Ecosystem Adaptive Management, BEAM, a five-year research programme (2010-2014). The project is jointly led by Stockholm Resilience Centre (SRC), at Stockholm University, Sweden together with the Ocean Health Index team. The BHI project is a purely scientific driven project, without any political narratives and no financial interest."),
            p("This trans-disciplinary project is led by Thorsten Blenckner at Stockholm Resilience Centre, Stockholm University and involves many international management organisations and researchers from around the Baltic Sea. Members of the team conducting the first assessment (started in 2015 with preliminary scores completed in 2017) additionally included Jennifer Griffiths, Ning Jiang, Julie Lowndes, Melanie Frazer, and Cornelia Ludwig. Currently, the second assessment is conducted by Eleanore Campbell, Andrea De Cervo, Susa Niiranen and Thorsten Blenckner."),
            width = 12
          )
        )
      ), # end welcome tab
      
      ## § index calculation ----
      tabItem(
        tabName = "indexcalculation",
        fluidRow(
          box(
            title = tagList(tags$h3("An Index Calculated with Multiple Dimensions")),
            status = "primary",
            width = 12,
            height = 100,
            collapsible = FALSE
          ),
          box(
            solidHeader = TRUE,
            br(),
            imageOutput("method_figure", height = 595),
            width = 8
          ),
          box(
            solidHeader = TRUE,
            list(
              imageOutput("ohi_dims_figure", height = 280),
              p(strong("Framework:"), " The score calculation framework accounts for current status, but also short-term trends (based on 5 previous years, or 10 years for slow-changing variables), as well as cumulative pressures and measures that buffer the system's resilience.", br()), 
              p(strong("Trend:"), " The average rate of change in status during the most recent years; as such, the trend calculation is not trying to predict (or model) the future, but only indicates likely condition based on a linear relationship.", br()),
              p(strong("Pressure:"), " Social and ecological elements that negatively affect the status of a goal.", br()),
              p(strong("Resilience:"), " Elements or actions that can reduce pressures, and maintain or raise future benefits (e.g. treaties, laws, enforcement, habitat protection).", br())
            ),
            width = 4
          )
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = TRUE,
            width = 12,
            title = "How Pressures are Connected to Different Goals", 
            p("This table shows how different pressures are related to different goals. Pressures usually act on multiple goals, and some goals may have more or fewers relevant pressures than others. The values indicate different levels of effect: 1 is the smallest effect, 2 is a moderate effect, 3 is the largest effect."),
            br(),
            div(DT::dataTableOutput("prs_matrix"), style = "font-size: 68%")
          )
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = TRUE,
            width = 12,
            title = "Resilience Components' Relevance to Different Goals", 
            p("This table shows how different resilience elements are related to different goals. The values indicate different levels of effect: 1 is the smallest effect, 2 is a larger effect."),
            br(),
            div(DT::dataTableOutput("res_matrix"), style = "font-size: 68%")
          )
        )
      ), 
      
## § (AO) Artisanal Fishing Opportunity ----
## Artisanal Fishing Opportunity
tabItem(
  tabName = "ao",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Artisanal Fishing Opportunity"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "ao_infobox"),
    box(
      h4(filter(goals_csv, goal == "AO")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This goal has three sub-components: stock, access, and need. For the BHI, the focus is on the coastal fish stock sub-component and will use this as a proxy for the entire goal. For this, we used two HELCOM core indicators: (1) abundance of coastal fish key functional groups (Catch-per-unit effort (CPUE) of cyprinids/mesopredators and CPUE of piscivores); (2) abundance of key coastal fish species (CPUE of perch, cod or flounder, depending on the area).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("Target values for the status assessments are identified based on site-specific time-series data for each indicator (same as in HELCOM HOLAS II), as coastal fish generally have local population structures, limited migration, and show local responses to environmental change.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "ao_map",
      title_text = "Artisanal Fishing Opportunity Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "ao_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "ao_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Pressure associated with sea surface temperature` = "cc_sst_bhi2019",
	`Pressure associated with salinity of the surface layer` = "cc_sal_surf_bhi2019"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The target is reached in Kattegat (Danish coast), Bornholm Basin (Swedish coast), Eastern Gotland basin (Lithuanian coast), Northern Baltic Proper (Finnish coast), Bothnian Sea (Swedish coast), The Quark (Finnish coast) and Bothnian Bay. The more northern areas, where perch is used as the key species and is more abundant, are in better status compared to more southern areas, where flounder is used as the key species, but in now in lower abudance with respect to the target. Similarly, the status of piscivores is better in more northern areas, whereas the status of cyprinids in more north-eastern areas of the Baltic Sea is not good as a result of too high abundance. In particular, the status scores are low in the Gulf of Riga (Estonian coast), Bay of Mecklenburg (Danish coast), Great Belt, The Sound (Danish coast) and Arkona Basin (Danish coast), due to low abundance of key species and piscivores, and also due to increasing abundance for cyprinids in some coastal areas.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/AO/v2019/ao_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Jens Olsson,  ", tags$em(" Institute of Coastal Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Öregrund, Sweden") 
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("ao_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Missing country data:"),
          "Missing data for Germany, Poland and Russia (and only key species data for Denmark) which is why there is no scoring for their respective basins. " 
        ),
        tags$li(
          tags$b("Multiple facets of opportunity:"),
          "Including ‘need’ and ‘access’ sub-components of this goal alongside the condition of coastal fisheries will give a more complete overview of artisanal fishing opportunity. " 
        ),
        tags$li(
          tags$b("Sparce Data in some areas:"),
          "In some basins there is very few monitoring stations and scaling up from monitoring station to subbasin does likely not provide a fully representative assessment." 
        )
      )
    )
  )
), # end AO tab item

## § (BD) Biodiversity ----
## Biodiversity
tabItem(
  tabName = "bd",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Biodiversity"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "bd_infobox"),
    box(
      h4(filter(goals_csv, goal == "BD")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This goal consists of five components: benthic habitats, pelagic habitats, fish, mammals (seals), and seabirds. It has been evaluated using the biological quality ratios and seabird abundance, derived in the integrated biodiversity assessments from HELCOM (the HELCOM assessment tool: https://github.com/NIVA-Denmark/BalticBOOST). These are based on core indicators for key species and species groups, including abundance, distribution, productivity, physiological and demographic characteristics. 

          Statuses of these five biodiversity components are aggregated first within each component, combining coastal area values with area-weighted averages, then combining the values for coastal and offshore areas of each BHI region with equal weight. A single biodiversity status score per region is calculated as geometric mean of the five components. More detailed information on the indicators and the biodiversity assessment can be found at HELCOM (http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("For the seabirds, the HELCOM core indicator threshold of 0.75 abundance, decided by HELCOM, was used as good status (corresponding to a status score of 100 in BHI). For the other four components (benthic habitats, pelagic habitats, fish, and mammals), a biological quality ratio (BQR) of 0.6 was developed by HELCOM with the aim to represent good status and was used as here as the target.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "bd_map",
      title_text = "Biodiversity Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "bd_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "bd_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("In general, the northern Baltic Sea obtained relatively high biodiversity status scores (variability range 90-92) with the highest record in Bothnian Sea (92). Lowest scores were obtained for the Bornholm Basin (variability range 24 - 39) mainly due to low scores in benthic habitat, seals and fish. Central and eastern Baltic Sea is generally characterised by intermediate scores with the biological components often being above the target values of individual components. The lowest scoring across all subbasins was recorded for marine mammals, with the lowest values in the Bornholm and Western Gotland basins (10) and only reaching the target level in Kattegat. Generally, seabirds are in better condition than the other biodiversity components, though collectively they reach the target levels only in Bothnian Sea, Bothnian Bay, and The Quark, and very nearly in Kiel Bay. Benthic habitats score low in the south to central Baltic Sea and Gulf of Finland and the pelagic habitat score low in Gulf of Riga and Finland.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Invasive Species Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/invasive_spp/v2019/invasive_spp_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Bottom Trawling Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/bottom_trawling/v2019/bottom_trawling_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/BD/v2019/bd_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Andrea Belgrano ,  ", tags$em(" Institute of Marine Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Lysekil, Sweden"), br(), "Henn Ojaveer,  ", tags$em(" Pärnu College, University of Tartu, Pärnu, Estonia and National Institute of Aquatic Resources, Technical University of Denmark, Lyngby, Denmark") 
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("bd_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Temporal data:"),
          "The data used here consists of an integrated assessment period (2011-2016), so no trend  was calculated from the same data used in status calculations. The trend dimension included is from the global OHI assessment, which employs a different status calculation approach. " 
        ),
        tags$li(
          tags$b("Varied habitats and functions:"),
          "Including a greater range of more specific habitat types and functional types (in a transparent way), could help make the goal more actionable for managers at local scales." 
        )
      )
    )
  )
), # end BD tab item

## § (CS) Carbon Storage ----
## Carbon Storage
tabItem(
  tabName = "cs",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Carbon Storage"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "cs_infobox"),
    box(
      h4(filter(goals_csv, goal == "CS")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Seagrass (Zostera marina) is an important macrophyte species occurring on shallow sandy bottoms in the Baltic Sea, and observations of Zostera marina were used as an indicator for carbon storage for the Baltic Sea area from HELCOM Red List species list.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("Seagrass designated as present before and after 1995.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "cs_map",
      title_text = "Carbon Storage Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "cs_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "cs_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The conspicuous salinity gradient influences the seagrass distribution in the Baltic Sea, and there is a decreasing seagrass abundance along with decreasing salinity towards the North-eastern Baltic areas. Hence, regions identified to be unsuitable for seagrass growth (north of the Åland Sea and the Archipelago Sea) have been assigned to no status score. A higher abundance of seagrass was observed in the Southern Baltic basins, especially in The Sound, where the score is higher compared to other areas. Our assessment of the carbon storage goal is hence likely an underestimation of the actual carbon storage potential which may have artificially decreased the overall BHI score in many sub-areas. Better data on distribution (depth limits and areal extent) and function (sequestration rates, transport and burial processes) of marine vegetation are required to accurately assess this goal in the future.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CS/v2019/cs_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Christoffer Boström ,  ", tags$em(" Environmental and Marine Biology, Åbo Akademi University, Åbo, Finland"), br(), "Markku Viitasalo,  ", tags$em(" Finnish Environment Institute SYKE, Helsinki, Finland") 
    )
  ),

  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("cs_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Missing data:"),
          "-	Limited availability of seagrass extent data, only spatial distribution models. " 
        ),
        tags$li(
          tags$b("Spatial data:"),
          "Include spatial data from remote sensing for saltmarshes, sheltered shallow bays, lagoons and reed belts. " 
        ),
        tags$li(
          tags$b("Inclusion of other indicators:"),
          "Include freshwater macrophyte distribution and monitoring data for the northern Baltic areas." 
        )
      )
    )
  )
), # end CS tab item

## § (CW) Clean Waters ----
## Clean Waters
tabItem(
  tabName = "cw",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Clean Waters"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "cw_infobox"),
    box(
      h4(filter(goals_csv, goal == "CW")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Three sub-goals for the Clean Waters goal were deemed important for the Baltic Sea: Contaminants, Eutrophication, and Trash. Each of these sub-goals has a status calculated that is equally averaged with the others for an overall goal status, and each sub-goal has a unique set of resilience and pressures.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("Each sub-goal has its own target.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "cw_map",
      title_text = "Clean Waters Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "cw_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "cw_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Secchi depth indicator scores` = "secchi_indicator_status",
        `Secchi depth indicator scores` = "secchi_indicator_trend",
        `PFOS indicator scores` = "pfos_indicator_status",
        `PFOS indicator scores` = "pfos_indicator_trend",
        `PCBs indicator scores` = "pcb_indicator_status",
        `PCBs indicator scores` = "pcb_indicator_trend",
        `Oxygen debt indicator scores` = "oxyg_indicator_status",
        `Oxygen debt indicator scores` = "oxyg_indicator_trend",
        `Dissolved Inorganic Phosphorus indicator scores` = "dip_indicator_status",
        `Dissolved Inorganic Phosphorus indicator scores` = "dip_indicator_trend",
        `Dioxin indicator scores` = "dioxin_indicator_status",
        `Dioxin indicator scores` = "dioxin_indicator_trend",
        `Dissolved Inorganic Nitrogen indicator scores` = "din_indicator_status",
        `Dissolved Inorganic Nitrogen indicator scores` = "din_indicator_trend",
        `Chlorophyll a indicator scores` = "chla_indicator_status",
        `Chlorophyll a indicator scores` = "chla_indicator_trend"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The overall score for the Clean Waters goal is low, especially in south-eastern Baltic basins, where both the Contaminants and Trash sub-goal have low status scores.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/tree/master/prep/CW"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Anna Sobek ,  ", tags$em(" Department of Environmental Science, Stockholm University, Stockholm, Sweden"), br(), "Vivi Fleming,  ", tags$em(" Finnish Environment Institute SYKE, Helsinki, Finland")
    )
  ),
  # fluidRow(
  #   box(
  #     width = 12, 
  #     title = "Experts who guided us in the Goal Preparation and Calculation",
  #     status = "primary", 
  #     solidHeader = TRUE,
  #     "Anna Sobek ,  ", tags$em(" Department of Environmental Science, Stockholm University, Stockholm, Sweden"), br(), "Vivi Fleming,  ", tags$em(" Finnish Environment Institute SYKE, Helsinki, Finland")
  #   )
  # ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("cw_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Missing aspects:"),
          "Including data on microplastics and sea floor litter would result in a more complete assessment for the Trash sub-goal, but these data are not currently available. Harmonized data and standardized indicators for marine litter are currently under development, and their inclusion will also help give a more complete picture of Clean Waters in the Baltic Sea. " 
        ),
        tags$li(
          tags$b("Substances of Very High Concern:"),
          "The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea which is used as one of the indicators in the Contaminants sub-goal to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea, can be developed further to better combine aspects current health and lack of data in the Index. " 
        ),
        tags$li(
          tags$b("Spatial variability:"),
          "Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty and therefore the confidence of the scores differs substantially across regions. " 
        ),
        tags$li(
          tags$b("Target:"),
          "The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty." 
        )
      )
    )
  )
), # end CW tab item

## § (CON) Contaminants ----
## Contaminants
tabItem(
  tabName = "con",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Contaminants"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "con_infobox"),
    box(
      h4(filter(goals_csv, goal == "CON")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Four indicators are combined in this subgoal: the contamination levels of three pollutants/pollutant groups (PCBs, PFOS, and Dioxins), and the monitored proportion of persistent, bioaccumulative and toxic Substances of Very High Concern (SVHC).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The target is having all contamination levels of the three pollutants/pollutant groups fall below their respective thresholds, and all persistent, bioaccumulative and toxic Substances of Very High Concern monitored.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "con_map",
      title_text = "Contaminants Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "con_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "con_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Perfluorooctanesulfonic acid (PFOS) average concentrations (ug/kg)` = "cw_con_pfos_bhi2019_bio",
        `Perfluorooctanesulfonic acid (PFOS) average concentrations (ug/kg)` = "cw_con_pfos_bhi2019_sed",
        `Proportions of monitored Substances of Very High Concern (from European Chemical Agency Candidate List)` = "cw_con_penalty_bhi2019",
        `Average PCBs concentrations (ug/kg, six congeners: CB28, CB52, CB101, CB138, CB153, CB180, a d CB118 in sediments)` = "cw_con_pcb_bhi2019_bio",
        `Average PCBs concentrations (ug/kg, six congeners: CB28, CB52, CB101, CB138, CB153, CB180, a d CB118 in sediments)` = "cw_con_pcb_bhi2019_sed",
        `Average Dioxin concentrations (ug/kg, includes dioxin-like PCBs)` = "cw_con_dioxin_bhi2019_bio",
        `Average Dioxin concentrations (ug/kg, includes dioxin-like PCBs)` = "cw_con_dioxin_bhi2019_sed"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Present-day concentrations of the three pollutants/pollutant groups included in the subgoal generally fall below their relative thresholds, particularly concentrations measured in biota (i.e., fish). The concentrations found in sediments (top 5cm) more often exceed their respective thresholds, reflecting the higher historic concentrations of the contaminants in the Baltic Sea mirrored in subsurface sediment. However, there are many persistent, bioaccumulative and toxic Substances of Very High Concern which are not  monitored across all regions of the Baltic Sea, which lowers the score. The level to which compounds known to be hazardous are monitored in the Baltic Sea is included as an indicator to illustrate that a proper assessment cannot be done due to lack of knowledge on occurrence of pollutants in the Baltic Sea.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/contaminants/v2019/con_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Anna Sobek,  ", tags$em(" Department of Environmental Science, Stockholm University, Stockholm, Sweden")
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("con_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Substances of Very High Concern:"),
          "The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea is used as one of the indicators to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea. This indicator and how it is used to calculate the score can be developed further to better combine the two aspects of the contaminant goal: current health of the Baltic Sea, and lack of data. " 
        ),
        tags$li(
          tags$b("Spatial variability:"),
          "Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores differs substantially across regions. Generally, there is less data on pollutants/pollutant groups from the southeast near the Baltic states and Poland and Russia. " 
        ),
        tags$li(
          tags$b("Thresholds:"),
          "The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty." 
        )
      )
    )
  )
), # end CON tab item

## § (EUT) Eutrophication ----
## Eutrophication
tabItem(
  tabName = "eut",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Eutrophication"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "eut_infobox"),
    box(
      h4(filter(goals_csv, goal == "EUT")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Five indicators are combined in the eutrophication subgoal: offshore Secchi depth, summer chlorophyll-a concentration, oxygen debt and winter concentrations of dissolved inorganic phosphorus (DIP) and nitrogen (DIN). Decreased secchi depth (i.e., increased turbidity) and increased chl-a concentration in the summer are indicators of eutrophication related increase in primary production. Oxygen debt, i.e., “missing” oxygen in relation to fully oxygenated water column in water-bodies that are poorly ventilated, results from increased consumption of oxygen in environments where organic material is decomposed. The oxygen debt indicator is calculated using information from salinity and oxygen profiles at the halocline and below in the deep basins of the Baltic Sea (Baltic Proper and Bornholm Basin) following the methodology of HELCOM (2013, 2018). Phosphorus and nitrogen, on the other hand, are the key limiting nutrients of primary production in the Baltic Sea making the winter concentrations of DIP and DIN indicators of the following summer’s production potential. These five eutrophication indicators are also HELCOM core indicators (Baltic Sea Environmental Proceedings No 143).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("Winter (December-February) nutrient concentrations (dissolved inorganic phosphorus: DIP and dissolved inorganic nitrogen: DIN), summer (June-September) Chlorophyll a (chl-a) concentrations and annually averaged oxygen debt fall below, and summer secchi depth above, the threshold values defined and used by HELCOM (2013, 2018). Thresholds are basin-specific.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "eut_map",
      title_text = "Eutrophication Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "eut_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "eut_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Pressure due to Phosphorus loading` = "po_pload_bhi2019",
	`Pressure due to Nitrogen loading` = "po_nload_bhi2019",
	`Secchi depth (meters, June-September) measurements` = "cw_eut_secchi_bhi2019",
	`Oxygen debt` = "cw_eut_oxydebt_bhi2019"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("In general, the eutrophication status is better in the North, particularly in the Bay of Bothnia, and in the South close to the Danish Straits. However, the eutrophication management target is only met in waters around Kattegat. Lower status scores were calculated for the Central Baltic Sea, and the eutrophication status score was lowest in the Gulf of Riga (approx. 50).
  
 
  The Eutrophication trend from the past 10 years indicates positive development in the areas near the Danish Sounds, where also the current status is good, but also in the Archipelago Sea, and Gulfs of Finland and Gdansk. The trend is negative elsewhere in the Baltic Sea. Based on the trend calculations, most negative development in the near future can be expected in the Gulf of Riga, which already has the lowest status score, as well as in the Quark area. That negative trends are observed in the Gulf of Bothnia, where the status score is relatively high, indicates that even in the “lower-concern” areas one needs to monitor closely the development of eutrophication.
  
 
  For most basins the Secchi depth target is not met at present and secchi depth is lower than the threshold value, Kattegat being the only exception. Also, the future trend is negative in most basins, excluding Kattegat and the Åland Sea.
  
 
  The chl-a target threshold was exceeded in all basins, with exception of Kattegat. The trend in chl-a was negative for management (i.e., increase in chl-a) in Central Basins of the Baltic Sea, as well as in the Gulf of Finland. Positive development was seen in the Southern parts and Gulf of Riga.
  
 
  Present-day oxygen debt is above the threshold both in the Baltic Proper and Bornholm Basin, indicating that the management target has not been met.
  
 
  For DIN, the management target was only met (i.e., lower DIN values) at the entrance to the Baltic Sea. DIN values highest in comparison to the target were found in Gulfs of Riga and Finland. The future trend is weak, but positive (i.e., decreasing DIN) with the exception of most of the northern Baltic Basins. For DIP, the target threshold was clearly exceeded in most of the basins, and met only in the Bothnian Bay and close to the entrance to the Baltic Sea. The future trend for DIP was clearly negative (i.e., increasing DIP) in the North, while slight positive development was identified in the South.
  ")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/eutrophication/v2019/eut_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Vivi Fleming,  ", tags$em(" Finnish Environment Institute SYKE, Helsinki, Finland")
    )
  ),
  
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("eut_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Spatial variability:"),
          "Some of the assessment regions have more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores can differ across regions. " 
        ),
        tags$li(
          tags$b("Thresholds:"),
          "The threshold values that are the same as used by HELCOM 2018. " 
        )
      )
    )
  )
), # end EUT tab item

## § (TRA) Trash ----
## Trash
tabItem(
  tabName = "tra",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Trash"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "tra_infobox"),
    box(
      h4(filter(goals_csv, goal == "TRA")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The amount of mismanaged plastic litter that has the potential to enter the ocean was used as a proxy for the goal, from modelled data by Jambeck et al. (2015). The modelled data were down-weighted for Russia, Germany, Denmark and Sweden (proportion of coastal population/national population) to include only the litter that reaches the Baltic Sea from these countries.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The good environmental status from the Marine Strategy Framework Directive is qualitatively framed as the situation where 'properties and quantities of marine litter do not cause harm to the coastal and marine environment'. Currently, there is no official quantitative reference point set. Therefore, for this assessment the upper reference point was set as the maximum amount of litter among all Baltic surrounding countries in 2010, and the lower reference point is zero litter in the Baltic Sea.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "tra_map",
      title_text = "Trash Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "tra_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "tra_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Trash is a significant issue for the Baltic Sea, as waste in urban areas can find its way to the sea and becomes marine litter. The status is not good in most of the Baltic Sea basins. Despite efforts in clean-up projects at beaches around the Baltic Sea, there is currently lack of consistent Baltic Sea wide monitoring and assessment for litter. As marine litter can be found on beaches and shorelines, floating on the surface, submerged in the water column or sunk to the bottom, core indicators need to be developed and assessed accordingly.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/trash/v2019/tra_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      tags$em(" No expert for this particular sub-goal")
    )
  ),
  
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("tra_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Standardization:"),
          "The majority of litter monitoring methods are not standardized specifically for the Baltic Sea. Data collection needs to be harmonized, to improve comparability of results and thus allow benchmarking. " 
        ),
        tags$li(
          tags$b("Microplastics:"),
          "Including data on microplastics would result in a more complete  picture, but these data are not currently available. " 
        ),
        tags$li(
          tags$b("Work-in-progress:"),
          "In HELCOM, assessment approaches based on core indicators are currently underway for beach litter, litter on the seafloor and microlitter. Threshold values for the assessment are being developed in an EU-process which can be used in the next BHI iteration." 
        )
      )
    )
  )
), # end TRA tab item

## § (FP) Food Provision ----
## Food Provision
tabItem(
  tabName = "fp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Food Provision"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "fp_infobox"),
    box(
      h4(filter(goals_csv, goal == "FP")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The Food Provision goal is divided into two sub-goals: Wild-Caught Fisheries and Mariculture. The more seafood harvested or farmed sustainably, the higher the goal score. Due to limited information and data the Mariculture sub-goal could not be assessed.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The target used for the Wild-Caught Fisheries sub-goal is based on the Maximum Sustainable Yield (MSY) principle. For the the Mariculture sub-goal the aim was to use the maximum nutrient discharge for both phosphorus (P) and nitrogen (N), but due to limited information this sub-goal could not be assessed.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "fp_map",
      title_text = "Food Provision Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "fp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "fp_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Proportion seafood production from wildcaught fisheries vs. Mariculture production` = "wildcaught_weight"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The overall score for the Food Provision goal is high (82), although none of the Baltic subbasin has reached the management target of sustainable fisheries. More detailed information are found in the Fisheries sub-goal descriptions.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
   fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      ""
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Christian Möllmann,  ", tags$em(" Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany")
    )
  ),
 
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("fp_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Complementary data:"),
          "Use survey and effort data to improve future goal calculations for fisheries and collect more information and data on mariculture and its sustainable production" 
        )
      )
    )
  )
), # end FP tab item

## § (FIS) Fisheries ----
## Fisheries
tabItem(
  tabName = "fis",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Fisheries"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "fis_infobox"),
    box(
      h4(filter(goals_csv, goal == "FIS")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The data used for this subgoal are cod (two cod stocks) and herring (four herring stocks) spawning stock biomass (SSB) and fishing mortality (F) data derived from stock assessments performed by the International Council for the Exploration of the Sea (ICES) Baltic Fisheries Assessment Working Group (WGBFAS). The current status of the fish stocks is calculated as a function of the ratio between the single species current biomass at sea (B) and the reference biomass at maximum sustainable yield (BMSY), as well as the ratio between the single species current fishing mortality (F) and the fishing mortality at maximum sustainable yield (FMSY). In EU fisheries management BMSY is defined as the lower bound to SSB when the stock is fished at FMSY, called MSY Btrigger. These ratios (B/BMSY and F/FMSY) are converted to scores between 0 and 1 using as one component this general relationship. Biomass and mortality are not sufficient to characterize the status of the Eastern Baltic cod, as in addition to population size condition have significantly declined. Fulton’s K (Casini et al. 2016) is used here as a measure of condition to penalize the proportion of surveyed cod in length categories 20-60cm (the most commercially important) with Fulton’s K less than 0.8.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The reference points used for the computation are based on the MSY principle and are described as a functional relationship. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process (European Union 2013, World Ocean Review 2013).")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "fis_map",
      title_text = "Fisheries Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "fis_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "fis_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Cod biomass at sea normalized by spawning stock biomass` = "fis_bbmsy_bhi2019_cod",
        `Herring biomass at sea normalized by spawning stock biomass` = "fis_bbmsy_bhi2019_herring",
        `Cod fishing mortality normalized by fishing mortality at max. sustainable yield` = "fis_ffmsy_bhi2019_cod",
        `Herring fishing mortality normalized by fishing mortality at max. sustainable yield` = "fis_ffmsy_bhi2019_herring",
        `Cod landings (tonnes)` = "fis_landings_bhi2019_cod",
        `Herring landings (tonnes)` = "fis_landings_bhi2019_herring"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The overall fisheries status is below 100 and has, therefore, not reached the sustainable fishery target. In particular, the Eastern and Western Baltic cod and the Western Baltic herring stock are below biomass limit reference points (ICES 2020). Central Baltic and Gulf of Riga herring in contrast are in a comparatively good state.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md"
    )
  ),  
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Christian Möllmann,  ", tags$em(" Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany") 
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("fis_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Additional data:"),
          "In the future, we aim to use survey and effort data to improve the goal calculations." 
        )
      )
    )
  )
), # end FIS tab item

## § (MAR) Mariculture ----
## Mariculture
tabItem(
  tabName = "mar",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Mariculture"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "mar_infobox"),
    box(
      h4(filter(goals_csv, goal == "MAR")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Sustainable mariculture represents a good supplementary opportunity that can support food provisioning needs, especially when considering not compromising the water quality in the farmed area and not relying on wild populations to feed or replenish the cultivated species. However, assessing the sustainable production of farmed fish can be difficult, as information is limited (location of the fish farms, species produced, nutrient and antibiotic release from these farms). Overall, in terms of total fish production, mariculture is at the moment not a large industry in the Baltic Sea, and dominated by rainbow trout production, which was included using available national data.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The maximum nutrient discharge for both phosphorus (P) and nitrogen (N) could be used as target for this sub-goal, if information is available. The HELCOM Recommendation, provides a management target that existing and new marine fish farms should not exceed the annual average of 7g of P (total-P) and 50g of N (total-N) per 1kg fish (living weight) produced.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "mar_map",
      title_text = "Mariculture Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "mar_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "mar_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Tonnes of seafood (rainbow trout and finfish) produced in Mariculture operations` = "mar_harvest_bhi2019"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Despite the production of rainbow trouts in some Baltic countries (Denmark, Germany, Sweden and Finland), there is currently very limited data on nutrient discharge, and therefore the Mariculture sub-goal was not assessed and will not contribute to the overall Food Provision goal score.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
    fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/MAR/v2019/mar_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      tags$em(" No expert for this particular sub-goal")
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("mar_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Data consistency:"),
          "Collect more consistent information and data on mariculture and its sustainable production." 
        )
      )
    )
  )
), # end MAR tab item

## § (LE) Coastal Livelihoods & Economies ----
## Coastal Livelihoods & Economies
tabItem(
  tabName = "le",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Coastal Livelihoods & Economies"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "le_infobox"),
    box(
      h4(filter(goals_csv, goal == "LE")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The jobs and revenue produced from marine-related industries directly benefit those who are employed, but also have important indirect value for community identity, tax revenue, and other related economic and social aspects of a stable coastal economy. The Livelihoods and Economies goal is divided into two sub-goals: 'Livelihoods' and 'Economies'. Each is measured separately as the number and quality of jobs and the amount of revenue produced are both of considerable interest to stakeholders and governments, and can have different patterns in some cases.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The target used for Livelihoods sub-goal is the maximum Region-to-Country employment ratio of the past five years, and highest country employment rate in the last fifteen years, whereas for the Economies sub-goal is having all marine economic sectors achieve an average annual growth rate of 1.5%.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "le_map",
      title_text = "Coastal Livelihoods & Economies Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "le_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "le_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The overall score for the Livelihoods and Economies goal is quite high across the entire Baltic Sea, especially along the Swedish basins, where the scores from both the **Livelihoods** and **Economies** sub-goals are quite high. However, the status is generally lower along German basins, where the **Economies** sub-goal scores are lower.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
    fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      ""
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Wilfried Rickels,  ", tags$em(" Kiel Institute for the World Economy, Kiel, Germany") 
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("le_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Marine sector-specific employment data:"),
          "Difficulty in obtaining data on sector-specific employment at a fine enough spatial resolution (Eurostat NUTS3 which distinguishes coastal vs non-coastal regions) has prevented a more focused assessment of marine livelihoods, beyond the current approach’s rough estimation of livelihoods in coastal areas. " 
        ),
        tags$li(
          tags$b("Working conditions and Job satisfaction:"),
          "Ideally, this goal would also reflect working conditions and job satisfaction associated with livelihoods in marine sectors. " 
        ),
        tags$li(
          tags$b("•	Inclusion of Sustainability Information:"),
          "Incorporating information on the sustainability of the different marine sectors and/or activities would help counterbalance penalization for negative economic growth (contraction) associated unsustainable economic activities such as natural gas, petroleum, or sediments extraction. " 
        ),
        tags$li(
          tags$b("Economic Activities as Pressures:"),
          "Extractive economic activities measured in this goal could be included in the index as minor pressures on other goals, in which case the contraction of these sectors would potentially correspond to increases in scores of other goals such as biodiversity or sense of place. " 
        ),
        tags$li(
          tags$b("Data timeseries:"),
          "Data only for years 2009 and 2018 were available by distinct sub-sectors and economic activities in the 2020 EU Blue Economy Report; since the status calculation uses growth rate as a target and only one annual growth rate (CAGR) could be approximated using the two years of data, the OHI trend dimension capturing short-term changes in status (i.e. changes in growth rates for this goal) short-term could not be calculated." 
        )
      )
    )
  )
), # end LE tab item

## § (ECO) Economies ----
## Economies
tabItem(
  tabName = "eco",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Economies"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "eco_infobox"),
    box(
      h4(filter(goals_csv, goal == "ECO")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This goal is composed of a single component: revenue (Gross Value Added) as reported in the 2020 EU Blue economy report. Gross value added (GVA) is defined as the value of output less the value of intermediate consumption, and is used to measure the output or contribution of a particular sector. Annual growth rates between 2009 and 2018 are estimated for each of 7 sectors (Coastal tourism, Marine living resources, Marine non-living resources, Marine renewable energy, Maritime transport, Port activities, Shipbuilding and repair), compared to the 1.5% target growth rate (see below), and averaged across sectors, weighted by sectors’ proportions of the total marine economy GVA.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The target is having all marine economic sectors achieve an average annual growth rate of 1.5%, which comes the first EU Blue Growth study (https://webgate.ec.europa.eu/maritimeforum/node/3550).")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "eco_map",
      title_text = "Economies Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "eco_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "eco_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Coastal tourism",
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Marine living resources",
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Marine non-living resources",
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Marine renewable energy",
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Maritime transport",
        `Gross Value Added (GVA, M€) from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Port activities",
        `Gross Value Added (GVA, M€ from Blue Economy sectors` = "le_eco_yearly_gva_bhi2019_Shipbuilding and repair"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Marine Non-living Resources is the sector with the most negative growth rate (>5% annual decrease), but only three countries have activities recorded in this category: Germany, Denmark, and Poland. This sector includes extraction and mining (and support activities for extraction) of natural gas and petroleum, salt, sand, clays and kaolin. Germany has negative growth rates also in Maritime Transport and Coastal Tourism which further decreases its score, while substantial growth in marine renewable energy for Denmark (the only country with revenue reported in this sector) largely offsets the contraction in its other sectors. Shipbuilding is a shrinking sector in Latvia, Finland, and Poland. Poland, however, has the highest growth rate in Coastal Tourism. ")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/ECO/v2019/eco_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Wilfried Rickels,  ", tags$em(" Kiel Institute for the World Economy, Kiel, Germany")
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("eco_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Inclusion of Sustainability Information:"),
          "Incorporating information on the sustainability of the different marine sectors and/or activities would help counterbalance penalization for negative economic growth (contraction) associated unsustainable economic activities such as natural gas, petroleum, or sediments extraction. " 
        ),
        tags$li(
          tags$b("Economic Activities as Pressures:"),
          "Extractive economic activities measured in this goal could be included in the index as minor pressures on other goals, in which case the contraction of these sectors would potentially correspond to increases in scores of other goals such as biodiversity or sense of place. " 
        ),
        tags$li(
          tags$b("Data timeseries:"),
          "Data only for years 2009 and 2018 were available by distinct sub-sectors and economic activities in the 2020 EU Blue Economy Report; since the status calculation uses growth rate as a target and only one annual growth rate (CAGR) could be approximated using the two years of data, the OHI trend dimension capturing short-term changes in status (i.e. changes in growth rates for this goal) short-term could not be calculated." 
        )
      )
    )
  )
), # end ECO tab item

## § (LIV) Livelihoods ----
## Livelihoods
tabItem(
  tabName = "liv",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Livelihoods"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "liv_infobox"),
    box(
      h4(filter(goals_csv, goal == "LIV")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("Due to an earlier lack of sector-specific employment information, the BHI currently uses overall employment rates in the Baltic coastal regions to represent ocean-dependent livelihood. This approach is based on the e assumption that employment rates in marine sectors are proportional  to those in the coastal regions' economies overall. Subsequent iterations of the BHI will aim to use sector-specific employment data, to more accurately represent the societal value derived from marine livelihoods in the Baltic Sea.  Coastal population and employment are estimated in areas created from intersection of the Eurostat reporting regions (NUTS2) and a buffer zone within 25 km of the coastline extending the BHI region boundaries. From these values, average employment rates in BHI regions are derived to be compared with National employment rates.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The reference point is the maximum Region-to-Country employment ratio of the past five years, and highest country employment rate in the last fifteen years. The region-to-country ratio puts the value into local context, then adjusting with respect to highest country employment rate in the last fifteen years from around the Baltic Sea situates the ratio in broader geographic context.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "liv_map",
      title_text = "Livelihoods Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "liv_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "liv_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Estimates of average regional employment rates in the coastal zone, within 25km of the coast` = "le_liv_regional_employ_bhi2019",
        `National employment rates in countries bordering the Baltic Sea` = "le_liv_national_employ_bhi2019"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Scores in the livelihoods goal are high across the entire Baltic Sea with low cross-section  variability, but still provide relevant insights, in particular if the development dimension over time is taken into account. Poland has the lowest score across the Baltic, occurring along the coast of Bornholm Basin, but has a much higher score associated with the areas around Gdansk. The Bornholm Basin region of Poland is the lowest scoring, but also the fastest growing.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/LIV/v2019/liv_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Wilfried Rickels,  ", tags$em(" Kiel Institute for the World Economy, Kiel, Germany")
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("liv_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
          tags$b("Marine sector-specific employment data:"),
          "Difficulty in obtaining data on sector-specific employment at a fine enough spatial resolution (Eurostat NUTS3 which distinguishes coastal vs non-coastal regions) has prevented a more focused assessment of marine livelihoods,  beyond the current approach’s rough estimation of livelihoods in coastal areas. " 
        ),
        tags$li(
          tags$b("Working conditions and Job satisfaction:"),
          "Ideally, this goal would also reflect working conditions and job satisfaction associated with livelihoods in marine sectors." 
        )
      )
    )
  )
), # end LIV tab item

## § (SP) Sense of Place ----
## Sense of Place
tabItem(
  tabName = "sp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Sense of Place"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "sp_infobox"),
    box(
      h4(filter(goals_csv, goal == "SP")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The Sense of Place goal is divided into two sub-goals: Iconic Species and Lasting Special Places. In particular, the status of Iconic Species was evaluated using species observational data from the HELCOM database, whereas the Lasting Special Places sub-goal assesses the status of MPAs in the Baltic Sea.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The target used for the Iconic Species sub-goal is achieved in case all species are categorised as of ’least concern’, whereas for the Lasting Special Places sub-goal the designation of at least 10% of each BHI region as MPAs with a full implemented management plan is used.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "sp_map",
      title_text = "Sense of Place Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "sp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "sp_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The overall score for the Sense of Place goal is quite low, mainly due to the overall status of MPAs, whose areal coverage is quite high but yet many need to be enforced. However, the status is generally higher in southern basins of the Baltic Sea, where both the **Iconic Species** and **Lasting Special Places** sub-goals scores are higher.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Invasive Species Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/invasive_spp/v2019/invasive_spp_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      ""
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Sofia Wikström,  ", tags$em(" Baltic Sea Centre, Stockholm University, Stockholm, Sweden")
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("sp_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Species ranges:"),
	 "One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area. " 
	),
tags$li(
	 tags$b("Relation to other assessments:"),
	 "Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future. " 
	),
tags$li(
	 tags$b("Data consideration:"),
	 "Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily. Also, some of the management plans are outdated, as the data updates are delayed on the HELCOM MPAs webpage (http://mpas.helcom.fi/apex/f?p=103:5::::::). " 
	),
tags$li(
	 tags$b("Moving target:"),
	 "CBD and EU are now discussing on raising the target for protection to 30% of the sea area, in which case will entail the BHI target to be updated accordingly. " 
	),
tags$li(
	 tags$b("Mapping values:"),
	 "Map important conservation, social and cultural places, which people value highly." 
	)
      )
    )
  )
), # end SP tab item

## § (ICO) Iconic Species ----
## Iconic Species
tabItem(
  tabName = "ico",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Iconic Species"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "ico_infobox"),
    box(
      h4(filter(goals_csv, goal == "ICO")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("The status of iconic species was evaluated using species observational data from the HELCOM database. A subset of species identified as culturally significant in the region included eight fish (cod, flounder, herring, perch, pike, salmon, trout, and sprat), five mammals (grey seal, harbour seal, ringed seal, harbour porpoise, and European otter), and two birds (sea eagle and common eider). The status of each of these iconic species is a numeric weight corresponding to their Red List threat category (ranging from “extinct” to “least concern”) of the International Union for Conservation of Nature (IUCN).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("A maximum score of 100 will be achieved in the case when all species are categorised as ’Least Concern.’")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "ico_map",
      title_text = "Iconic Species Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "ico_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "ico_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `IUCN Categories for Iconic species of the Baltic Sea` = "sp_ico_assessments_bhi2019_Fish and Lamprey",
	`IUCN Categories for Iconic species of the Baltic Sea` = "sp_ico_assessments_bhi2019_Mammals",
	`IUCN Categories for Iconic species of the Baltic Sea` = "sp_ico_assessments_bhi2019_Birds"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Status of iconic species is generally higher in southern basins of the Baltic Sea. More species from the iconic species list are present in the southern basins, including fish species such as flounder (Platichthys flesus) and sprat (Sprattus sprattus) which thrive in higher salinity and are classified on the IUCN scale as ‘least concern’. The different ranges of different seal species also contribute to the pattern of lower scores in the northern basins. Harbour seals (Phoca vitulina vitulina), which are classified as ‘least concern’, are present in the southern but not in the northern basins, while ringed seals (Pusa hispida) classified as ‘vulnerable’ are only present in the northern basins.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Invasive Species Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/invasive_spp/v2019/invasive_spp_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
    fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/ICO/v2019/ico_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      tags$em(" No expert for this particular sub-goal")
    )
  ),

  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("ico_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Species ranges:"),
	 "One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area. " 
	),
tags$li(
	 tags$b("Relation to other assessments:"),
	 "Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future. " 
	),
tags$li(
	 tags$b("Data consideration:"),
	 "Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily." 
	)
      )
    )
  )
), # end ICO tab item

## § (LSP) Lasting Special Places ----
## Lasting Special Places
tabItem(
  tabName = "lsp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Lasting Special Places"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "lsp_infobox"),
    box(
      h4(filter(goals_csv, goal == "LSP")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This sub-goal assesses the area of marine protected areas (MPAs) in each BHI region, and their management status, i.e. “designated”, “partly managed” and “managed”.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The designation of at least 10% of each BHI region as MPAs with a full implemented management plan, in order to give a fair representation of spatial coverage to the country and its respective basin.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "lsp_map",
      title_text = "Lasting Special Places Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "lsp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "lsp_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The areal coverage of MPAs is quite high in almost the whole Baltic Sea,  although many MPAs still need to be enforced. The overall sub-goal score is low as many MPAs are categorized as only “designated” or “partly managed”. However, a few regions with a full implemented management plan have reached the target, such as Åland Sea (Swedish region), Gulf of Finland (Estonian region), Northern Baltic Proper (Estonian region), and Arkona Basin (Swedish region).")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/blob/master/prep/LSP/v2019/lsp_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Sofia Wikström,  ", tags$em(" Baltic Sea Centre, Stockholm University, Stockholm, Sweden") 
    )
  ),
  
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("lsp_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Data delays:"),
	 "Some of the management plans are outdated, as the data updates are delayed on the HELCOM MPAs webpage (http://mpas.helcom.fi/apex/f?p=103:5::::::). " 
	),
tags$li(
	 tags$b("Moving target:"),
	 "CBD and EU are now discussing on raising the target for protection to 30% of the sea area, in which case will entail the BHI target to be updated accordingly. " 
	),
tags$li(
	 tags$b("Mapping values:"),
	 "Map important conservation, social and cultural places, which people value highly." 
	)
      )
    )
  )
), # end LSP tab item

## § (NP) Natural Products ----
## Natural Products
tabItem(
  tabName = "np",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Natural Products"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "np_infobox"),
    box(
      h4(filter(goals_csv, goal == "NP")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This goal was calculated based on data from the pelagic fish sprat (Sprattus sprattus) as this fish is mainly used for fish meal production or animal food. The goal was assessed using spawning stock biomass and fishing mortality data as well as related maximum sustainable yield (MSY) reference points from ICES (2020, see also the Fisheries goal). The current status of the sprat stock is calculated as a function of the ratio between the single species current biomass at sea (B) and the reference biomass at maximum sustainable yield (BMSY), as well as the ratio between the single species current fishing mortality (F) and the fishing mortality at maximum sustainable yield (FMSY). In EU fisheries management, BMSY is defined as the lower bound to SSB when the stock is fished at FMSY, called MSYBtrigger. These ratios (B/BMSY and F/FMSY) are converted to scores between 0 and 1 using this general relationship as one component. The spatial assessment unit is the whole Baltic Sea. No data for other natural products were readily available at the time of the assessment.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("The reference points used for the computation are based on the MSY principle and are described as a functional relationship. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process (European Union 2013, World Ocean Review 2013).")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "np_map",
      title_text = "Natural Products Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "np_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "np_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Sprat landings, tonnes` = "np_landings_bhi2019_sprat",
	`Fishing mortality normalized by fishing mortality at max. sustainable yield` = "np_ffmsy_bhi2019_sprat",
	`Biomass at sea normalized by spawning stock biomass` = "np_bbmsy_bhi2019_sprat"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("The Natural Product score is high (85-94) and has a very low spatial variability, because the ICES sprat assessment unit is the whole Baltic Sea, so the small spatial variability is due to the different pressure and resilience scores in the different regions.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Oxygen Debt Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/oxygen_debt/v2019/oxygen_debt_pressure_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Illegal Oil Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/illegal_oil/v2019/illegal_oil_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Atmospheric Contaminants Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Nutrients Loads Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      tags$em("No expert for this particular goal (some advisement from fisheries goal expert, as used similar models)") 
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("np_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Additional data:"),
	 "The data used here consists only of one species. In the future we aim to add other species such as blue mussels and macroalgae, to provide a more comprehensive picture of the status of natural products in the Baltic Sea." 
	)
      )
    )
  )
), # end NP tab item

## § (TR) Tourism & Recreation ----
## Tourism & Recreation
tabItem(
  tabName = "tr",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Tourism & Recreation"),
      solidHeader = TRUE,
      width = 8
    ),
    scoreBoxUI(id = "tr_infobox"),
    box(
      h4(filter(goals_csv, goal == "TR")$description),
      solidHeader = TRUE,
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Background Information"),
        p("This goal uses data on coastal accommodations (nights stayed in tourist accommodation establishments, in coastal regions) and coastal tourism revenue (gross value added) from the EU Study on Blue Growth. Economic activities categorized under either Accommodation or Transport in the Coastal Tourism sector were included. No sustainability measure of coastal tourism on the Baltic Sea scale was found, and thus this dimension was not included. ")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Scoring Criteria"),
        p("Goal status is calculated from ratios of coastal tourism revenue versus nights stayed in tourist accommodation establishments per unit area of coastal regions. The ratios are scaled such that the maximum value corresponds to a status of 100, i.e. the target is the maximum revenue-to-accommodations ratio achieved between 2012 and 2018.")
      )
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "tr_map",
      title_text = "Tourism & Recreation Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "tr_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    tsplotCardUI(
      id = "tr_tsplot",
      title_text = "Visualizing more Data Behind the Scores",
      sub_title_text = "",
      ht = 700,
      select_choices = list(
        `Gross Value Added (GVA, M€) from coastal tourism sectors, accommodations and transport activities` = "tr_coastal_tourism_gva_bhi2019",
	`Nights spent in coastal tourist accomodations per square kilometer, from Eurostat NUTS3 reporting regions` = "tr_accommodations_bhi2019",
	`Pressure due to lack of water transparency or clarity` = "po_inverse_secchi_bhi2019"
      )
    )
  ),
  fluidRow(
    tags$div(
      class = "columns_container",
      column(
        class = "column_eight",
        width = 8,
        h4("Additional Insights & Discussion"),
        p("Tourism potential as measured by this approach is fulfilled to a high degree in Sweden and Finland. The lowest values are associated with Lithuania and Poland, though Poland is catching up in the tourism sector – its economic growth rate in the Coastal Tourism sector is highest of any country around the Baltic Sea. Nights stayed in tourist accommodations per area in Germany is higher on average than for other countries, including Sweden and Finland, but the ratio of the national revenue from coastal tourism activities relative to this value is lower. While this metric reflects to a degree how much people value experiencing different coastal and ocean areas, the unexpectedly low values associated with the German coast could indicate saturation and greater competition driving down marginal returns from tourist accommodations . More research will be needed to evaluate such patterns and underlying causes and subsequently improve the Tourism goal model.")
      ),
      column(
        class = "column_four",
        width = 4,
        h4("Pressures acting on this Goal"),
        h5(a(
          paste('\n', 'Climate Change Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Secchi Depth Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/pressure_secchi/v2019/pressure_secchi_prep.md', gh_prep), 
          target = '_blank'
        )), 
        h5(a(
          paste('\n', 'Inverse of Worldwide Governance Indicator Scores (WGI) Pressure Layer Data Preparation'),
          href = sprintf('%s/blob/master/prep/pressures/wgi_social/v2019/wgi_social_prep.md', gh_prep), 
          target = '_blank'
        ))
      )
    )
  ),
  
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES, MAPS, & CODE",
      "https://github.com/OHI-Science/bhi-prep/tree/master/prep/TR/v2019/tr_prep.md"
    )
  ), 
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Experts who guided us in the Goal Preparation and Calculation",
      "Wilfried Rickels,  ", tags$em(" Kiel Institute for the World Economy, Kiel, Germany")
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("tr_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      solidHeader = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Lack of Sustainability Dimensions or Ecotourism:"),
	 "no metric of sustainability of coastal tourism on the Baltic Sea scale was found, and thus this dimension was not included. However,  these are important considerations for the BHI as tool for ecosystem-based management, and therefore a priority for inclusion in future iterations of the Index. " 
	),
tags$li(
	 tags$b("Connection between Tourism  and Ocean Health:"),
	 "how dimensions of ocean health affect people’s perceptions and value for spending time in coastal and ocean areas could be explored further, to better model how tourism potential is fulfilled across the Baltic Sea and how it may  respond to management actions or changing environmental conditions. " 
	),
tags$li(
	 tags$b("Spatial units:"),
	 "Data by Eurostat NUTS (Nomenclature of Territorial Units for Statistics) level 3 regions are used to estimate accommodations densities for areas within 25 kilometers of the coastline; coastal tourism revenue is reported by country, presumably derived from data with the same Eurostat NUTS3 spatial assessment units. Better harmonization between datasets of spatial assessment units could improve confidence in results." 
	)
      )
    )
  )
), # end TR tab item

      ## § (END) signal end of goals pages stuff for rebuild functions
      
      ## COMPARE AND SUMMARIZE ----
      ## compare and summarize
      
      # ## § futures ----
      # tabItem(
      #   tabName = "futures",
      #   fluidRow(
      #     box(
      #       h1("Likely Future versus Present"),
      #       width = 12
      #     ),
      #     box(
      #       p("SOMETHING ABOUT LIKELY FUTURE STATUS AND DIFFERENT DIMENSIONS OF OHI"),
      #       width = 12
      #     )
      #   )
      # ), # end futures tab item
      # 
      # ## § pressures ----
      # tabItem(
      #   tabName = "pressures",
      #   fluidRow(
      #     box(
      #       h1("Pressures (Page Under Construction)", style = "color:#9b363d"),
      #       width = 12
      #     ),
      #     box(
      #       p("SOMETHING ABOUT BHI PRESSURES, WITH TIME SERIES PLOTS"),
      #       width = 12
      #     ),
      #     
      #     ## pressures time series plot
      #     box(
      #       width = 9,
      #       addSpinner(plotlyOutput("pressure_ts", height = "750px"), spin = "rotating-plane", color = "#d7e5e8")
      #     ),
      #     ## pressure timeseries plot select var
      #     box(
      #       width = 3,
      #       selectInput(
      #         "press_var",
      #         label = "Pressure Variables to Plot",
      #         choices = c(
      #           `Eutrophication` = "eut_time_data",
      #           `Contaminants PCB` = "con_pcb_time_data",
      #           `Contaminants Dioxin` = "con_dioxin_time_data",
      #           `Anoxia Pressure` = "anoxia_press",
      #           `Nitrogen Load Tonnes` = "N_basin_tonnes"
      #         )
      #       )
      #     ) # end pressure timeseries plot select var
      #   )
      # ), # end pressures item
      # 
      # ## § scenarios ----
      # tabItem(
      #   tabName = "scenarios",
      #   fluidRow(
      #     box(
      #       h1("Scenario Exploration"),
      #       width = 12
      #     ),
      #     box(
      #       p("SOMETHING ABOUT SCENARIOS TESTING APPROACHES, TRIALS, RESULTS"),
      #       width = 12
      #     )
      #   )
      # ), # end scenarios item
      # 
      # ## § layers ----
      # tabItem(
      #   tabName = "layers",
      #   fluidRow(
      #     box(
      #       h1("Data Layers (Page Under Construction)", style = "color:#9b363d"),
      #       width = 12
      #     ),
      #     box(
      #       p("SOMETHING ABOUT PROCESS OF GENERATING LAYERS, AND LAYER VS LAYER SCATTERPLOT"),
      #       width = 12
      #     )
      #   )
      # ), # end layers item
      
      ## § LEARN MORE ----
      tabItem(
        tabName = "learnmore",
        
        ## header
        fluidRow(
          box(
            title = tagList(tags$h3("Read and learn more about the Ocean Health Index and the Baltic Sea")),
            # h3("Read and learn more about the Ocean Health Index and the Baltic Sea"),
            # br(),
            width = 12,
            height = 100,
            collapsible = FALSE,
            status = "primary"
          )
        ),
        ## references list
        fluidRow(
          box(
            solidHeader = TRUE,
            h4("About the Ocean Health Index"),
            br(),
            tags$a(href="https://ohi-science.org/", "The Ocean Health Index, Science Website"),
            br(), br(),
            tags$a(href="https://twitter.com/OHIscience", "Ocean Health Index on Twitter"),
            br(), br(),
            tags$a(href="https://www.cell.com/one-earth/fulltext/S2590-3322(19)30270-2", "NCEAS director Ben Halpern reflects on a Decade of the Ocean Health Index"),
            br(), br(), br(),
            h4("Baltic Health Index Code & Calculations"),
            br(),
            tags$a(href="https://github.com/OHI-Science/bhi", "Baltic Health Index Score Calculations Repository"),
            br(), br(),
            tags$a(href="https://ohi-science.org/bhi-prep/", "Baltic Health Index Data Preparation"),
            br(), br(),
            tags$a(href="https://github.com/OHI-Science/bhi-prep", "Baltic Health Index Data Preparation Code Repository"),
            br(), br(),
            tags$a(href="https://github.com/OHI-Science/ohicore", "Ocean Health Index Core, Functions to combine Goals and Dimensions"),
            br(), br(), br(),
            h4("Other Regional OHI Assessments"),
            br(),
            tags$a(href="https://ohi-science.org/projects/ohi-assessments/", "OHI Regional Assessments, Around the Globe"),
            br(), br(),
            tags$a(href="https://ohi-northeast.shinyapps.io/ne-dashboard/", "Shiny Dashboard for the OHI Northeast, USA"),
            br(), br(), br(),
            h4("Assorted Articles about OHI Assessments & Guiding Principles"),
            br(),
            tags$a(href="https://ohi-science.org/news/transparent-trust-new-england-seas", "A case study about transparency in the Ocean Health Index"),
            br(), br(),
            tags$a(href="https://www.nature.com/articles/s41559-017-0160", "Better Science in Less Time, Lowndes et al."),
            br(), br(), br(),
            width = 12
          )
        )
      ), # end learnmore tab
      
      ## § SHARE FEEDBACK ----
      tabItem(
        tabName = "feedback",
        
        ## header
        fluidRow(
          box(
            htmlOutput("iframe"),
            width = 12
          )
        )
      ) # end feedback tab
    ) # end tabItems
  ) # end dashboardBody
) # end dashboardPage
