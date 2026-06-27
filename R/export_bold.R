#' Export parcellated BOLD data for syncR
#'
#' Packages the output of [boldR::parcellate()] into a `boldR_export` object
#' suitable for ingestion by `syncR::sync()`. The export includes the ROI
#' timeseries matrix, functional connectivity matrix (if computed), ROI
#' metrics, and participant metadata.
#'
#' @param parcellated A `boldR_parcellated` object from [boldR::parcellate()].
#' @param fc A `boldR_fc` object from [boldR::compute_fc()], or `NULL` (default).
#' @param roi_metrics A tibble from [boldR::compute_roi_metrics()], or `NULL`
#'   (default). If `NULL`, metrics are computed automatically.
#' @param participant_id Character or `NULL`. Override the subject label for
#'   use in `syncR`. If `NULL`, taken from the `boldR_bold` object.
#'
#' @return A list of class `boldR_export` ready for `syncR::sync()`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' parcel <- parcellate(bold, atlas)
#' fc     <- compute_fc(parcel)
#' exp    <- export_bold(parcel, fc = fc)
#'
#' # Pass to syncR
#' syncR::sync(..., bold = exp)
#' }
export_bold <- function(parcellated,
                        fc             = NULL,
                        roi_metrics    = NULL,
                        participant_id = NULL) {
  if (!inherits(parcellated, "boldR_parcellated")) {
    cli::cli_abort(
      "{.arg parcellated} must be a {.cls boldR_parcellated} object."
    )
  }

  if (!is.null(fc) && !inherits(fc, "boldR_fc")) {
    cli::cli_abort("{.arg fc} must be a {.cls boldR_fc} object or NULL.")
  }

  if (is.null(roi_metrics)) {
    roi_metrics <- compute_roi_metrics(parcellated)
  }

  pid <- participant_id %||% parcellated$bold$fmriprep$subject

  cli::cli_alert_success(
    "BOLD export ready for syncR: participant {pid}, \\
     {parcellated$n_rois} ROIs."
  )

  structure(
    list(
      participant_id = pid,
      timeseries     = parcellated$timeseries,
      fc             = if (!is.null(fc)) fc$z else NULL,
      roi_metrics    = roi_metrics,
      atlas_name     = parcellated$atlas$name,
      roi_labels     = parcellated$atlas$labels,
      n_rois         = parcellated$n_rois,
      n_timepoints   = parcellated$n_timepoints,
      tr             = parcellated$bold$tr,
      task           = parcellated$bold$fmriprep$task,
      space          = parcellated$bold$fmriprep$space
    ),
    class = "boldR_export"
  )
}

#' @export
print.boldR_export <- function(x, ...) {
  cli::cli_h1("boldR export (syncR-ready)")
  cli::cli_inform(c(
    "i" = "Participant: {x$participant_id}",
    "i" = "Atlas:       {x$atlas_name}",
    "i" = "ROIs:        {x$n_rois}",
    "i" = "Timepoints:  {x$n_timepoints}",
    "i" = "TR:          {x$tr}s",
    "i" = "FC matrix:   {if (!is.null(x$fc)) 'yes' else 'no'}"
  ))
  invisible(x)
}
