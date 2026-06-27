#' Extract ROI-level timeseries from a BOLD image
#'
#' Applies a parcellation atlas to a preprocessed BOLD image, returning
#' mean timeseries per ROI. Works with any `boldR_atlas` object — built-in
#' or custom — as long as the atlas is in the same template space as the BOLD.
#'
#' @param bold A `boldR_bold` object from [boldR::prepare_bold()].
#' @param atlas A `boldR_atlas` object from [boldR::load_atlas()].
#' @param summary_fn Function. Applied across voxels within each ROI at each
#'   timepoint. Default `mean`. Common alternatives: `median`.
#' @param min_voxels Integer. Minimum number of in-mask voxels an ROI must
#'   contain to be included in the output. ROIs below this threshold are
#'   returned with `NA` timeseries and a warning. Default `10L`.
#'
#' @return A list of class `boldR_parcellated` with components:
#' \describe{
#'   \item{timeseries}{Numeric matrix, timepoints × ROIs. Column names are ROI
#'     labels from the atlas.}
#'   \item{roi_voxel_counts}{Integer vector. Number of in-mask voxels per ROI.}
#'   \item{atlas}{The `boldR_atlas` object used.}
#'   \item{bold}{The `boldR_bold` object used.}
#'   \item{n_rois}{Integer. Number of ROIs in output.}
#'   \item{n_timepoints}{Integer. Number of timepoints.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fprep  <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
#' bold   <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
#' atlas  <- load_atlas("schaefer100_7n")
#' parcel <- parcellate(bold, atlas)
#' dim(parcel$timeseries)  # timepoints × 100
#' }
parcellate <- function(bold,
                       atlas,
                       summary_fn = mean,
                       min_voxels = 10L) {
  if (!inherits(bold, "boldR_bold")) {
    cli::cli_abort("{.arg bold} must be a {.cls boldR_bold} object.")
  }
  if (!inherits(atlas, "boldR_atlas")) {
    cli::cli_abort("{.arg atlas} must be a {.cls boldR_atlas} object.")
  }

  cli::cli_alert_info("Loading BOLD image...")
  bold_img <- RNifti::readNifti(bold$fmriprep$bold)

  cli::cli_alert_info("Loading atlas image...")
  atlas_img <- RNifti::readNifti(atlas$nifti_path)

  # Validate spatial dimensions
  bold_dims  <- dim(bold_img)[1:3]
  atlas_dims <- dim(atlas_img)[1:3]
  if (!identical(bold_dims, atlas_dims)) {
    cli::cli_abort(
      "Spatial dimensions of BOLD ({paste(bold_dims, collapse='x')}) and
       atlas ({paste(atlas_dims, collapse='x')}) do not match.
       Resample the atlas to match the BOLD resolution."
    )
  }

  # Load brain mask
  mask_img  <- RNifti::readNifti(bold$fmriprep$bold_mask)
  mask_flat <- as.logical(as.array(mask_img))

  # Convert to matrix: voxels × timepoints (drop first N volumes)
  start_vol <- bold$drop_volumes + 1L
  n_t       <- bold$n_timepoints
  bold_arr  <- as.array(bold_img)
  bold_mat  <- matrix(bold_arr[,,, start_vol:(start_vol + n_t - 1L)],
                      nrow = prod(bold_dims), ncol = n_t)

  atlas_flat <- as.integer(as.array(atlas_img))

  # Extract timeseries per ROI
  n_rois <- atlas$n_rois
  ts_mat <- matrix(NA_real_, nrow = n_t, ncol = n_rois)
  colnames(ts_mat) <- atlas$labels
  vox_counts <- integer(n_rois)

  for (i in seq_len(n_rois)) {
    roi_idx   <- atlas_flat == atlas$indices[i] & mask_flat
    n_vox     <- sum(roi_idx)
    vox_counts[i] <- n_vox

    if (n_vox < min_voxels) {
      cli::cli_alert_warning(
        "ROI {atlas$labels[i]} has only {n_vox} in-mask voxels \\
         (< {min_voxels}); timeseries set to NA."
      )
      next
    }
    ts_mat[, i] <- apply(bold_mat[roi_idx, , drop = FALSE], 2, summary_fn)
  }

  cli::cli_alert_success(
    "Parcellation complete: {n_rois} ROIs × {n_t} timepoints."
  )

  structure(
    list(
      timeseries      = ts_mat,
      roi_voxel_counts = vox_counts,
      atlas           = atlas,
      bold            = bold,
      n_rois          = n_rois,
      n_timepoints    = n_t
    ),
    class = "boldR_parcellated"
  )
}

#' @export
print.boldR_parcellated <- function(x, ...) {
  cli::cli_h1("boldR parcellated BOLD")
  cli::cli_inform(c(
    "i" = "Subject:    {x$bold$fmriprep$subject}",
    "i" = "Atlas:      {x$atlas$name}",
    "i" = "ROIs:       {x$n_rois}",
    "i" = "Timepoints: {x$n_timepoints}"
  ))
  invisible(x)
}
