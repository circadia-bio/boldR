#' List available built-in atlases
#'
#' Returns a data frame describing the atlases bundled with `boldR`.
#' Custom atlases can be loaded via [boldR::load_atlas()].
#'
#' @return A tibble with columns `name`, `n_rois`, `space`, and `description`.
#'
#' @export
#'
#' @examples
#' list_atlases()
list_atlases <- function() {
  tibble::tribble(
    ~name,            ~n_rois, ~space,                    ~description,
    "schaefer100_7n",     100, "MNI152NLin2009cAsym",     "Schaefer 2018, 100 parcels, 7 networks",
    "schaefer200_7n",     200, "MNI152NLin2009cAsym",     "Schaefer 2018, 200 parcels, 7 networks",
    "aal116",             116, "MNI152NLin6Asym",         "AAL 116 regions (Tzourio-Mazoyer 2002)",
    "destrieux148",       148, "MNI152NLin2009cAsym",     "Destrieux 2010, 148 cortical parcels"
  )
}

#' Load a parcellation atlas
#'
#' Loads a `boldR_atlas` object either from the bundled atlas library or from
#' a custom NIfTI label map. The `boldR_atlas` schema is the extension point
#' for user-defined parcellations.
#'
#' @param atlas Character. Name of a built-in atlas (see [boldR::list_atlases()]) or
#'   a path to a custom NIfTI label image.
#' @param labels Character vector or `NULL`. ROI labels, one per integer value
#'   in the atlas image (excluding 0). If `NULL` and `atlas` is a built-in,
#'   labels are loaded automatically. Required for custom NIfTI inputs.
#' @param space Character or `NULL`. Template space of the atlas. Inferred
#'   for built-ins; should be specified for custom inputs.
#'
#' @return A list of class `boldR_atlas` with components:
#' \describe{
#'   \item{name}{Character. Atlas name or file path.}
#'   \item{nifti_path}{Character. Path to the atlas NIfTI label image.}
#'   \item{labels}{Character vector. ROI label for each integer index.}
#'   \item{indices}{Integer vector. Non-zero integer values in the atlas.}
#'   \item{n_rois}{Integer. Number of ROIs.}
#'   \item{space}{Character. Template space.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' atlas <- load_atlas("schaefer100_7n")
#' atlas
#'
#' # Custom atlas
#' atlas <- load_atlas(
#'   atlas  = "my_parcellation.nii.gz",
#'   labels = paste0("ROI_", 1:80),
#'   space  = "MNI152NLin2009cAsym"
#' )
#' }
load_atlas <- function(atlas, labels = NULL, space = NULL) {
  built_ins <- list_atlases()

  if (atlas %in% built_ins$name) {
    nifti_path <- system.file("atlases", paste0(atlas, ".nii.gz"),
                              package = "boldR")
    if (!nzchar(nifti_path)) {
      cli::cli_abort(
        "Built-in atlas {.val {atlas}} is registered but its NIfTI file is
         not yet bundled. Install from GitHub for the latest data files."
      )
    }
    meta     <- built_ins[built_ins$name == atlas, ]
    space    <- meta$space
    lbl_path <- system.file("atlases", paste0(atlas, "_labels.csv"),
                             package = "boldR")
    labels   <- if (nzchar(lbl_path)) {
      utils::read.csv(lbl_path, stringsAsFactors = FALSE)$label
    } else {
      paste0("ROI_", seq_len(meta$n_rois))
    }
  } else {
    # Custom NIfTI path
    if (!file.exists(atlas)) {
      cli::cli_abort("Atlas file not found: {.path {atlas}}")
    }
    nifti_path <- normalizePath(atlas)
    if (is.null(labels)) {
      cli::cli_abort(
        "{.arg labels} must be supplied for a custom atlas NIfTI."
      )
    }
    if (is.null(space)) {
      cli::cli_alert_warning(
        "{.arg space} not specified for custom atlas; set to {.val unknown}."
      )
      space <- "unknown"
    }
  }

  # Read integer indices from NIfTI
  img     <- RNifti::readNifti(nifti_path)
  indices <- sort(unique(as.integer(img[img != 0L])))

  if (length(labels) != length(indices)) {
    cli::cli_abort(
      "Length of {.arg labels} ({length(labels)}) does not match number of \\
       non-zero ROIs in atlas ({length(indices)})."
    )
  }

  structure(
    list(
      name       = atlas,
      nifti_path = nifti_path,
      labels     = labels,
      indices    = indices,
      n_rois     = length(indices),
      space      = space
    ),
    class = "boldR_atlas"
  )
}

#' @export
print.boldR_atlas <- function(x, ...) {
  cli::cli_h1("boldR atlas: {x$name}")
  cli::cli_inform(c(
    "i" = "ROIs:  {x$n_rois}",
    "i" = "Space: {x$space}",
    "i" = "File:  {.path {x$nifti_path}}"
  ))
  invisible(x)
}
