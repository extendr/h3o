test_cells <- function() {
  h3_from_xy(
    c(-77.0365, 2.2945, 139.6917),
    c(38.8977, 48.8584, 35.6895),
    5
  )
}

nc_geometry <- function() {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  sf::st_geometry(sf::st_transform(nc, 4326))
}
