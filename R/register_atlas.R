#' Register a custom brain atlas
#'
#' Validates and registers a NIfTI label map and optional metadata table as a
#' `boldR_atlas` object. The schema is intentionally minimal: any parcellation
#' that provides a 3D integer label image and a label-to-name mapping can be
#' registered and passed to [boldR::parcellate()]. Bundled atlas helpers (Schaefer,
#' AAL, Glasser) use this same interface.
#'
#' @param labels_img A `niftiImage` (3D integer) or a file path to a NIfTI
#'   label map. Voxels containing `0` are treated as background.
#' @param metadata A data frame with at minimum two columns:
#'   \describe{
#'     \item{`label`}{Integer. The integer value in `labels_img`.}
#'     \item{`name`}{Character. Human-readable ROI name.}
#'   }
#'   Additional columns (hemisphere, network, x/y/z centroid, colour, etc.)
#'   are stored and carried through to output.
#' @param name Character. A short identifier for this atlas
#'   (e.g. `"Schaefer200"`, `"AAL3"`, `"custom"`).
#' @param space Character. The standard space this atlas is defined in.
#'   Default `"MNI152NLin2009cAsym"`. Must match the space used in
#'   [boldR::read_fmriprep()] / [boldR::parcellate()].
#'
#' @return A list of class `boldR_atlas` with components:
#' \describe{
#'   \item{labels_img}{`niftiImage`. The 3D integer label map.}
#'   \item{metadata}{Data frame. ROI metadata.}
#'   \item{name}{Character. Atlas identifier.}
#'   \item{space}{Character. Standard space.}
#'   \item{n_rois}{Integer. Number of unique non-zero labels.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' atlas <- register_atlas(
#'   labels_img = "atlases/Schaefer2018_200Parcels_7Networks_MNI.nii.gz",
#'   metadata   = read.csv("atlases/Schaefer2018_200Parcels_labels.csv"),
#'   name       = "Schaefer200",
#'   space      = "MNI152NLin2009cAsym"
#' )
#' atlas
#' }
register_atlas <- function(labels_img,
                            metadata,
                            name  = "custom",
                            space = "MNI152NLin2009cAsym") {

  # -- Load NIfTI if path given -----------------------------------------------
  if (is.character(labels_img)) {
    if (!file.exists(labels_img)) {
      cli::cli_abort("Atlas label file not found: {.path {labels_img}}")
    }
    labels_img <- RNifti::readNifti(labels_img)
  }

  if (!inherits(labels_img, "niftiImage")) {
    cli::cli_abort("{.arg labels_img} must be a {.cls niftiImage} or a file path.")
  }

  if (length(dim(labels_img)) != 3) {
    cli::cli_abort("Atlas label image must be 3D (got {length(dim(labels_img))}D).")
  }

  # -- Validate metadata -------------------------------------------------------
  required_cols <- c("label", "name")
  missing_cols  <- setdiff(required_cols, colnames(metadata))
  if (length(missing_cols) > 0) {
    cli::cli_abort(c(
      "{.arg metadata} is missing required columns.",
      "x" = "Missing: {.val {missing_cols}}"
    ))
  }

  unique_labels <- sort(unique(as.integer(as.array(labels_img))))
  unique_labels <- unique_labels[unique_labels != 0L]
  n_rois        <- length(unique_labels)

  meta_labels  <- sort(unique(as.integer(metadata[["label"]])))
  missing_meta <- setdiff(unique_labels, meta_labels)
  if (length(missing_meta) > 0) {
    cli::cli_warn(c(
      "{length(missing_meta)} label{?s} in the image have no metadata entry.",
      "i" = "Missing label{?s}: {.val {head(missing_meta, 10)}}"
    ))
  }

  cli::cli_alert_success(
    "Registered atlas {.val {name}}: {n_rois} ROI{?s} ({space})."
  )

  structure(
    list(
      labels_img = labels_img,
      metadata   = metadata,
      name       = name,
      space      = space,
      n_rois     = n_rois
    ),
    class = "boldR_atlas"
  )
}

#' @export
print.boldR_atlas <- function(x, ...) {
  cli::cli_h1("boldR atlas")
  cli::cli_inform(c(
    "i" = "Name:   {.val {x$name}}",
    "i" = "Space:  {.val {x$space}}",
    "i" = "ROIs:   {x$n_rois}",
    "i" = "Columns in metadata: {.val {colnames(x$metadata)}}"
  ))
  invisible(x)
}
