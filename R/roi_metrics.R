#' Compute summary metrics per ROI
#'
#' Returns a tibble of per-ROI summary statistics from the parcellated
#' timeseries: mean signal, standard deviation, and temporal SNR.
#'
#' @param parcellated A `boldR_parcellated` object from [boldR::parcellate()].
#'
#' @return A tibble with columns `roi`, `mean`, `sd`, `tsnr`, `n_voxels`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' parcel  <- parcellate(bold, atlas)
#' metrics <- compute_roi_metrics(parcel)
#' metrics
#' }
compute_roi_metrics <- function(parcellated) {
  if (!inherits(parcellated, "boldR_parcellated")) {
    cli::cli_abort(
      "{.arg parcellated} must be a {.cls boldR_parcellated} object."
    )
  }

  ts       <- parcellated$timeseries
  roi_mean <- apply(ts, 2, mean,      na.rm = TRUE)
  roi_sd   <- apply(ts, 2, stats::sd, na.rm = TRUE)

  tibble::tibble(
    roi      = parcellated$atlas$labels,
    mean     = roi_mean,
    sd       = roi_sd,
    tsnr     = roi_mean / roi_sd,
    n_voxels = parcellated$roi_voxel_counts
  )
}
