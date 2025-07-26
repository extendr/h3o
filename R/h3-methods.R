#' @export
unique.H3 <- function(x, ...) {
  h3_strs <- h3_to_strings(x)
  x[match(unique(h3_strs), h3_strs)]
}

#' @export
format.H3 <- function(x, ...) format(h3_to_strings(x), ...)

#' @export
`[[.H3` <- function(x, i, ...) {
  if (length(i) > 1) {
    stop("subscript out of bounds", call. = FALSE)
  }
  structure(
    .subset(x, i),
    class = c("H3", "vctrs_vctr", "list")
  )
}

#' @export
#' @rdname H3
#' @param ... unused.
as.character.H3 <- function(x, ...) h3_to_strings(x)

# export in zzz.R
st_as_sfc.H3 <- function(x) {
  is_missing <- is.na(x)
  res <- vector(mode = "list", length(x))
  res[!is_missing] <- h3_boundaries_(x[!is_missing])

  for (i in which(is_missing)) {
    res[[i]] <- structure(list(), class = c("XY", "POLYGON", "sfg"))
  }

  sf::st_sfc(res, crs = 4326)
}


#' @export
plot.H3 <- function(x, ...) {
  rlang::check_installed("sf", "for conversion to `sfc` objects")

  plot(sf::st_as_sfc(x), ...)
}
