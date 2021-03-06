library(sp)
library(dplyr)
library(readr)
library(leaflet)

add_map_datalayers <- function(goalmap, lyrs_latlon, lyrs_polygons, year = assess_year){
  
  
  ## get the datasets for plotting ----
  
  ## points
  plot_latlon <- list()
  if(length(lyrs_latlon) > 0){
    for(lyr in lyrs_latlon){
      if(RCurl::url.exists(paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv"))){
        dfloc <- paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv")
      } else if(RCurl::url.exists(paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv"))){
        dfloc <- paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv")
      } else {
        warning(sprintf("file %s doesn't exist in either layers or intermediate folder", lyr))
        dfloc = NULL
      }
      lyr_df <- readr::read_csv(dfloc, col_types = cols())
      colnames(lyr_df) <- stringr::str_replace(names(lyr_df), "scen_year", "year")
      if(!"year" %in% names(lyr_df)){
        lyr_df <- dplyr::mutate(lyr_df, year = default_year)
      }
      plot_latlon[[stringr::str_remove(lyr, "_bhi[0-9]{4}")]] <- lyr_df
    }
  }
  
  ## polygons
  # lyrs_polygons <- list(
  #   lyrs = list("dip_indicator", "din_indicator"),
  #   plotvar = list("score", "score"),
  #   cols = list(c("#8c031a","#cc0033","#fff78a","#f6ffb3","#009999","#0278a7"), c("#8c031a","#cc0033","#fff78a","#f6ffb3","#009999","#0278a7")),
  #   paldomain = list(c(0, 100), c(0, 100))
  # )
  plot_polygons <- list()
  polylyrs_pals <- list()
  if(length(lyrs_polygons$lyrs) > 0){
    for(i in 1:length(lyrs_polygons$lyrs)){
      lyr <- lyrs_polygons$lyrs[i]
      if(RCurl::url.exists(paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv"))){
        dfloc <- paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv")
      } else if(RCurl::url.exists(paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv"))){
        dfloc <- paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv")
      } else {
        warning(sprintf("file %s doesn't exist in either layers or intermediate folder", lyr))
        dfloc = NULL
      }
      lyr_df <- readr::read_csv(dfloc, col_types = cols())
      colnames(lyr_df) <- stringr::str_replace(names(lyr_df), "scen_year", "year")
      if(!"year" %in% names(lyr_df)){
        lyr_df <- dplyr::mutate(lyr_df, year = assess_year)
      }
      plot_polygons[[stringr::str_remove(lyr, "_bhi[0-9]{4}")]] <- lyr_df
      
      polylyrs_pals[[stringr::str_remove(lyr, "_bhi[0-9]{4}")]][["cols"]] <- unlist(lyrs_polygons$cols[i])
      polylyrs_pals[[stringr::str_remove(lyr, "_bhi[0-9]{4}")]][["paldomain"]] <- unlist(lyrs_polygons$paldomain[i])
      polylyrs_pals[[stringr::str_remove(lyr, "_bhi[0-9]{4}")]][["plotvar"]] <- unlist(lyrs_polygons$plotvar[i])
    }
  }
  
  ## set up overlays menu in top corner
  goalmap <- goalmap %>%
    addLayersControl(
      overlayGroups = c("marine_protected_areas", names(plot_latlon), names(plot_polygons)),
      options = layersControlOptions(collapsed = TRUE)
    )
  
  
  ## plot_polygons ----
  ## will need to be given with corresponding color palettes
  for(lyr in unlist(lyrs_polygons$lyr)){
    
    ## case when lyrs_polygon are dataframes with region_ids
    ## (will add case where polygons dont align with bhi regions e.g. MPAs later)
    if("region_id" %in% names(plot_polygons[[lyr]])){
      
      ## if the lyrs have multiple years and/or dimensions, 
      ## will filter to match selected year and ohi dimension
      ## also rename to specify column to map data from
      if(all(c("dimension", "year") %in% names(plot_polygons[[lyr]]))){
        filterlyr <- filter(plot_polygons[[lyr]], year == year, dimension == "status")
      } else {
        filterlyr <- plot_polygons[[lyr]]
      }
      colnames(filterlyr) <- stringr::str_replace(
        names(filterlyr), 
        polylyrs_pals[[lyr]][["plotvar"]], 
        "Value"
      )
      ## spatialdataframes with sp package, rather than sf...
      spatiallyr <- rgns_shp
      spatiallyr@data <- spatiallyr@data %>% 
        filter(year == year) %>% 
        select(-year, -dimension) %>% 
        left_join(filterlyr, by = "region_id")
      
      ## make color palette function for the additional data layer
      lyrpal <- leaflet::colorNumeric(
        palette = polylyrs_pals[[lyr]][["cols"]],
        domain = polylyrs_pals[[lyr]][["paldomain"]]
      )
      # rc1 <- colorRampPalette(colors = c("#8c031a", "#cc0033"), space = "Lab")(25)
      # rc2 <- colorRampPalette(colors = c("#cc0033", "#fff78a"), space = "Lab")(20)
      # rc3 <- colorRampPalette(colors = c("#fff78a", "#f6ffb3"), space = "Lab")(20)
      # rc4 <- colorRampPalette(colors = c("#f6ffb3", "#009999"), space = "Lab")(15)
      # rc5 <- colorRampPalette(colors = c("#009999", "#457da1"), space = "Lab")(5)
      # lyrpal <- leaflet::colorNumeric(
      #   palette = c(rc1, rc2, rc3, rc4, rc5),
      #   domain = polylyrs_pals[[lyr]][["paldomain"]]
      # )
      
      ## add the layers to the map!
      goalmap <- goalmap %>%
        addPolygons(
          group = lyr,
          stroke = TRUE, 
          opacity = 0.5, 
          weight = 2, 
          fillOpacity = 1, 
          smoothFactor = 0.5,
          color = thm$cols$map_polygon_border1, 
          fillColor = ~lyrpal(Value),
          data = spatiallyr
        ) %>% 
        addLegend(
          group = lyr,
          pal = lyrpal, 
          values = ~Value, 
          opacity = 1, 
          data = spatiallyr
        )
    }
  }
  
  ## plot_latlon ----
  ## will all be single color with transparency
  for(lyr in names(plot_latlon)){
    
    ## if the lyrs have multiple years and/or dimensions, 
    ## will filter to match selected year and ohi dimension
    if(all(c("dimension", "scen_year") %in% names(plot_latlon[[lyr]]))){
      filterlyr <- filter(plot_latlon[[lyr]], scen_year == year, dimension == "status")
    } else {
      filterlyr <- plot_latlon[[lyr]]
    }
    
    goalmap <- goalmap %>%
      addCircleMarkers(
        group = lyr,
        data = filterlyr, 
        fillColor = "midnightblue", 
        fillOpacity = 0.5,
        opacity = 0,
        radius = 2
      )
  }
  goalmap <- goalmap %>% 
    hideGroup(c(names(plot_latlon), names(plot_polygons)))
  
  
  return(goalmap)
}

#' create leaflet maps
#'
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#' @param mapping_data_sp  sf object associating scores with spatial polygons,
#' i.e. having goal score and geometries information
#' @param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment year
#' @param legend_title text to be used as the legend title
#'
#' @return leaflet map with BHI goal scores by BHI region or Subbasins
leaflet_map <- function(full_scores_lst, basins_or_rgns = "subbasins",
                        goal_code = "Index", dim = "score", year = assess_year,
                        legend_title){
  
  ## wrangle data for plotting ----
  if(basins_or_rgns == "subbasins"){
    leaflet_plotting_sf <- make_subbasin_sf(
      subbasins_shp = read_rds(file.path(dir_main, "data", "subbasins.rds")), 
      scores_lst = full_scores_lst, 
      goal_code,
      dim, 
      year
    )
  } else {
    leaflet_plotting_sf <- make_rgn_sf(
      bhi_rgns_shp = read_rds(file.path(dir_main, "data", "regions.rds")), 
      scores_lst = full_scores_lst, 
      goal_code,
      dim, 
      year
    )
  }
  
  ## theme and map setup ----
  if(dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
  thm <- apply_bhi_theme()
  
  ## create asymmetric color ranges for legend
  # colours = c("#8c031a", "#cc0033", "#fff78a", "#f6ffb3", "#009999", "#0278a7"),
  # values = c(0, 0.15, 0.4, 0.6, 0.8, 0.95, 1),
  
  rc1 <- colorRampPalette(colors = c("#8c031a", "#cc0033"), space = "Lab")(25)
  rc2 <- colorRampPalette(colors = c("#cc0033", "#fff78a"), space = "Lab")(20)
  rc3 <- colorRampPalette(colors = c("#fff78a", "#f6ffb3"), space = "Lab")(20)
  rc4 <- colorRampPalette(colors = c("#f6ffb3", "#009999"), space = "Lab")(15)
  rc5 <- colorRampPalette(colors = c("#009999", "#457da1"), space = "Lab")(5)
  
  if(dim == "pressures"){
    pal <- leaflet::colorNumeric(
      palette = rev(c(rc1, rc2, rc3, rc4, rc5)),
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  } else {
    pal <- leaflet::colorNumeric(
      palette = c(rc1, rc2, rc3, rc4, rc5),
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  }
  
  ## create leaflet map ----
  map <- leaflet::leaflet(data = leaflet_plotting_sf) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    setView(18, 59, zoom = 5) %>%
    addLegend(
      "bottomright", 
      pal = pal, 
      values = c(paldomain[1]:paldomain[2]),
      title = legend_title, 
      opacity = 0.8, 
      layerId = "colorLegend"
    ) %>%
    addPolygons(
      layerId = ~Name,
      stroke = TRUE, 
      opacity = 0.5, 
      weight = 2, 
      fillOpacity = 0.6, 
      smoothFactor = 0.5,
      color = thm$cols$map_polygon_border1, 
      fillColor = ~pal(score)
    )
  
  ## return list result with dataframe too ----
  leaflet_fun_result <- list(
    map = map,
    data_sf = leaflet_plotting_sf@data
  )
  
  return(leaflet_fun_result)
}

#' make sf obj with subbasin-aggregated goal scores
#'
#' @param subbasins_shp a shapefile read into R as a sf (simple features) object;
#' must have an attribute column with subbasin full names
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment yearr
#'
#' @return sf obj with subbasin-aggregated goal scores

make_subbasin_sf <- function(subbasins_shp, scores_lst, goal_code = "Index", dim = "score", year = assess_year){
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  mapping_data <- left_join(
    rename(subbasins_df, Name = subbasin, region_id = subbasin_id),
    scores_lst[[goal_code]][[dim]][[as.character(year)]],
    by = "region_id"
  )
  ## join with spatial information from subbasin shapfile
  ## spatialdataframes with sp package, rather than sf...
  subbasins_shp_tab <- subbasins_shp@data %>% 
    dplyr::mutate(Name = as.character(Name)) %>%
    dplyr::mutate(Name = ifelse(
      Name == "Åland Sea",
      "Aland Sea", Name)
    ) %>%
    dplyr::left_join(mapping_data, by = "Name")
  subbasins_shp@data <- subbasins_shp_tab
  
  return(subbasins_shp)
}

#' make bhi-regiomns sf obj joined with goal scores
#'
#' @param bhi_rgns_shp a shapefile of the BHI regions, as a sf (simple features) object
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment yearr
#'
#' @return bhi-regions sf obj joined with goal scores

make_rgn_sf <- function(bhi_rgns_shp, scores_lst, goal_code = "Index", dim = "score", year = assess_year){
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  mapping_data <- left_join(
    rename(regions_df, Name = region_name),
    scores_lst[[goal_code]][[dim]][[as.character(year)]],
    by = "region_id"
  )
  ## join with spatial information from subbasin shapfile
  ## spatialdataframes with sp package, rather than sf...
  bhi_rgns_shp_tab <- bhi_rgns_shp@data %>% 
    dplyr::mutate(Name = sprintf("%s, %s", Subbasin, rgn_nam)) %>%
    dplyr::left_join(mapping_data, by = "Name")
  bhi_rgns_shp@data <- bhi_rgns_shp_tab
  
  return(bhi_rgns_shp)
}
