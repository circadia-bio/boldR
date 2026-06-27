#' Compute voxelwise temporal SNR
#'
#' Calculates temporal signal-to-noise ratio (tSNR) for every in-mask voxel
#' in a cleaned BOLD image. tSNR is defined as the ratio of the mean signal to
#' its temporal standard deviation across the timeseries. It is a standard
#' quality metric for fMRI acquisitions and preprocessing pipelines.
#'
#' @param bold A `boldr_bold` object returned by [prepare_bold()], or a 4D
#'   numeric array (x × y × z × timepoints).
#'
#' @return A list of class `boldr_tsnr` with components:
#' \describe{
#'   \item{tsnr}{3D numeric array (same x × y × z as input). Contains tSNR
#'     values for in-mask voxels and `NA` elsewhere.}
#'   \item{mean_tsnr}{Numeric. Mean tSNR across in-mask voxels.}
#'   \item{median_tsnr}{Numeric. Median tSNR across in-mask voxels.}
#'   \item{n_voxels}{Integer. Number of in-mask voxels.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' sub      <- read_fmriprep("data/derivatives/fmriprep", "01", task = "rest")
#' cleaned  <- prepare_bold(sub)
#' tsnr_out <- compute_tsnr(cleaned)
#' tsnr_out$mean_tsnr
#' }
compute_tsnr <- function(bold) {
  bold_arr <- if (inherits(bold, "boldr_bold")) bold$data else bold
  mask     <- if (inherits(bold, "boldr_bold")) bold$mask else
    apply(bold_arr, 1:3, mean) > 0

  if (length(dim(bold_arr)) != 4) {
    cli::cli_abort("{.arg bold} must be a 4D array.")
  }

  dims   <- dim(bold_arr)
  tsnr   <- array(NA_real_, dim = dims[1:3])

  mu  <- apply(bold_arr, 1:3, mean,  na.rm = TRUE)
  sig <- apply(bold_arr, 1:3, sd,    na.rm = TRUE)

  # Avoid division by zero
  tsnr[mask] <- ifelse(sig[mask] > 0, mu[mask] / sig[mask], NA_real_)

  in_mask_vals <- tsnr[mask & !is.na(tsnr)]

  cli::cli_alert_success(
    "tSNR computed: mean = {round(mean(in_mask_vals), 1)}, \\
     median = {round(stats::median(in_mask_vals), 1)}."
  )

  structure(
    list(
      tsnr        = tsnr,
      mean_tsnr   = mean(in_mask_vals),
      median_tsnr = stats::median(in_mask_vals),
      n_voxels    = length(in_mask_vals)
    ),
    class = "boldr_tsnr"
  )
}

#' @export
print.boldr_tsnr <- function(x, ...) {
  cli::cli_h1("boldR temporal SNR")
  cli::cli_inform(c(
    "i" = "In-mask voxels: {x$n_voxels}",
    "i" = "Mean tSNR:      {round(x$mean_tsnr,   1)}",
    "i" = "Median tSNR:    {round(x$median_tsnr, 1)}"
  ))
  invisible(x)
}
