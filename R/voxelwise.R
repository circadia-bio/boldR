#' Compute voxelwise temporal SNR
#'
#' Calculates temporal signal-to-noise ratio (tSNR) for each voxel in the
#' BOLD image: mean signal divided by standard deviation across timepoints.
#' A standard quality metric for assessing fMRI data quality after
#' preprocessing.
#'
#' @param bold A `boldR_bold` object from [prepare_bold()].
#'
#' @return A list of class `boldR_tsnr` with components:
#' \describe{
#'   \item{tsnr}{Numeric array. tSNR map with same x/y/z dimensions as BOLD.}
#'   \item{mean_tsnr}{Numeric. Mean tSNR across in-mask voxels.}
#'   \item{median_tsnr}{Numeric. Median tSNR across in-mask voxels.}
#'   \item{bold}{The input `boldR_bold` object.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fprep <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
#' bold  <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
#' tsnr  <- compute_tsnr(bold)
#' tsnr$mean_tsnr
#' }
compute_tsnr <- function(bold) {
  if (!inherits(bold, "boldR_bold")) {
    cli::cli_abort("{.arg bold} must be a {.cls boldR_bold} object.")
  }

  cli::cli_alert_info("Loading BOLD image for tSNR computation...")
  bold_img  <- RNifti::readNifti(bold$fmriprep$bold)
  mask_img  <- RNifti::readNifti(bold$fmriprep$bold_mask)

  start_vol <- bold$drop_volumes + 1L
  n_t       <- bold$n_timepoints
  bold_arr  <- as.array(bold_img)[,,, start_vol:(start_vol + n_t - 1L)]
  mask_arr  <- as.logical(as.array(mask_img))

  # tSNR = mean(t) / sd(t) per voxel
  bold_mean <- apply(bold_arr, 1:3, mean)
  bold_sd   <- apply(bold_arr, 1:3, stats::sd)
  tsnr_map  <- bold_mean / bold_sd
  tsnr_map[bold_sd == 0 | !mask_arr] <- NA_real_

  in_mask_vals <- tsnr_map[mask_arr & !is.na(tsnr_map)]

  cli::cli_alert_success(
    "tSNR computed. Median = {round(stats::median(in_mask_vals), 1)}, \\
     Mean = {round(mean(in_mask_vals), 1)}."
  )

  structure(
    list(
      tsnr        = tsnr_map,
      mean_tsnr   = mean(in_mask_vals),
      median_tsnr = stats::median(in_mask_vals),
      bold        = bold
    ),
    class = "boldR_tsnr"
  )
}

#' @export
print.boldR_tsnr <- function(x, ...) {
  cli::cli_h1("boldR tSNR")
  cli::cli_inform(c(
    "i" = "Subject:     {x$bold$fmriprep$subject}",
    "i" = "Mean tSNR:   {round(x$mean_tsnr, 2)}",
    "i" = "Median tSNR: {round(x$median_tsnr, 2)}"
  ))
  invisible(x)
}
