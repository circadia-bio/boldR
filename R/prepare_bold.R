#' Validate and prepare a fMRIPrep object for analysis
#'
#' Checks file existence, reads NIfTI headers to confirm dimensionality and
#' TR, and returns an annotated `boldR_bold` object ready for downstream
#' analysis functions.
#'
#' @param fmriprep A `boldR_fmriprep` object from [read_fmriprep()].
#' @param tr Numeric or `NULL`. Repetition time in seconds. If `NULL`
#'   (default), extracted from the BOLD NIfTI header.
#' @param drop_volumes Integer. Number of initial volumes to discard (dummy
#'   scans). Default `0`.
#'
#' @return A list of class `boldR_bold` with components:
#' \describe{
#'   \item{fmriprep}{The input `boldR_fmriprep` object.}
#'   \item{dims}{Integer vector. BOLD array dimensions `[x, y, z, t]`.}
#'   \item{tr}{Numeric. Repetition time in seconds.}
#'   \item{n_voxels}{Integer. Total in-mask voxels.}
#'   \item{n_timepoints}{Integer. Number of volumes after dummy-scan removal.}
#'   \item{drop_volumes}{Integer. Volumes dropped.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fprep <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
#' bold  <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
#' bold
#' }
prepare_bold <- function(fmriprep, tr = NULL, drop_volumes = 0L) {
  if (!inherits(fmriprep, "boldR_fmriprep")) {
    cli::cli_abort(
      "{.arg fmriprep} must be a {.cls boldR_fmriprep} object from
       {.fn read_fmriprep}."
    )
  }

  for (field in c("bold", "bold_mask", "dseg")) {
    path <- fmriprep[[field]]
    if (is.na(path) || !file.exists(path)) {
      cli::cli_abort("Required file missing: {.field {field}} = {.path {path}}")
    }
  }

  cli::cli_alert_info("Reading BOLD header...")
  hdr <- RNifti::niftiHeader(fmriprep$bold)
  dims <- hdr$dim[2:5]  # [x, y, z, t]

  if (is.null(tr)) {
    tr <- hdr$pixdim[5]
    if (tr <= 0) {
      cli::cli_abort(
        "TR could not be determined from NIfTI header (pixdim[5] = {tr}).
         Supply {.arg tr} explicitly."
      )
    }
    cli::cli_alert_info("TR detected from header: {tr}s")
  }

  n_timepoints <- dims[4L] - as.integer(drop_volumes)
  if (n_timepoints < 1L) {
    cli::cli_abort(
      "{.arg drop_volumes} ({drop_volumes}) exceeds total volumes ({dims[4L]})."
    )
  }

  cli::cli_alert_success(
    "BOLD prepared: {dims[1]}×{dims[2]}×{dims[3]} voxels, \\
     {n_timepoints} timepoints, TR = {tr}s."
  )

  structure(
    list(
      fmriprep    = fmriprep,
      dims        = dims,
      tr          = tr,
      n_voxels    = NA_integer_,   # populated after mask application
      n_timepoints = n_timepoints,
      drop_volumes = as.integer(drop_volumes)
    ),
    class = "boldR_bold"
  )
}

#' @export
print.boldR_bold <- function(x, ...) {
  cli::cli_h1("boldR BOLD object")
  cli::cli_inform(c(
    "i" = "Subject:     {x$fmriprep$subject}",
    "i" = "Dimensions:  {x$dims[1]}×{x$dims[2]}×{x$dims[3]}",
    "i" = "Timepoints:  {x$n_timepoints}  (dropped: {x$drop_volumes})",
    "i" = "TR:          {x$tr}s"
  ))
  invisible(x)
}
