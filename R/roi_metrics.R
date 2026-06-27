#' Compute functional connectivity matrix
#'
#' Computes a ROI x ROI functional connectivity (FC) matrix from parcellated
#' BOLD timeseries using Pearson correlation. Returns both the full correlation
#' matrix and its Fisher z-transformed version.
#'
#' @param parcellated A `boldR_parcellated` object from [boldR::parcellate()].
#' @param method Character. Correlation method passed to `cor()`.
#'   Default `"pearson"`.
#' @param use Character. Handling of missing values, passed to `cor()`.
#'   Default `"pairwise.complete.obs"`.
#'
#' @return A list of class `boldR_fc` with components:
#' \describe{
#'   \item{r}{Numeric matrix. Pearson r correlation matrix (ROIs x ROIs).}
#'   \item{z}{Numeric matrix. Fisher z-transformed FC matrix.}
#'   \item{labels}{Character vector. ROI labels.}
#'   \item{n_rois}{Integer.}
#'   \item{parcellated}{The input `boldR_parcellated` object.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' parcel <- parcellate(bold, atlas)
#' fc     <- compute_fc(parcel)
#' dim(fc$r)  # 100 x 100 for Schaefer-100
#' }
compute_fc <- function(parcellated,
                       method = "pearson",
                       use    = "pairwise.complete.obs") {
  if (!inherits(parcellated, "boldR_parcellated")) {
    cli::cli_abort(
      "{.arg parcellated} must be a {.cls boldR_parcellated} object."
    )
  }

  ts <- parcellated$timeseries
  r  <- stats::cor(ts, method = method, use = use)
  z  <- atanh(r)
  diag(z) <- NA_real_

  structure(
    list(
      r           = r,
      z           = z,
      labels      = parcellated$atlas$labels,
      n_rois      = parcellated$n_rois,
      parcellated = parcellated
    ),
    class = "boldR_fc"
  )
}

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
  roi_mean <- apply(ts, 2, mean,       na.rm = TRUE)
  roi_sd   <- apply(ts, 2, stats::sd,  na.rm = TRUE)

  tibble::tibble(
    roi      = parcellated$atlas$labels,
    mean     = roi_mean,
    sd       = roi_sd,
    tsnr     = roi_mean / roi_sd,
    n_voxels = parcellated$roi_voxel_counts
  )
}
