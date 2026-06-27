#' Read fMRIPrep BIDS derivatives for a participant
#'
#' Reads preprocessed fMRI outputs from an
#' [fMRIPrep](https://fmriprep.org) BIDS derivatives directory for a single
#' participant and session, returning a structured `boldR_fmriprep` object
#' containing paths to the BOLD, T1w, T2w, and segmentation files.
#'
#' @param derivatives_dir Character. Path to the fMRIPrep derivatives root
#'   (e.g. `"sub-01/func/"`... or the top-level `derivatives/fmriprep/`).
#' @param subject Character. Subject label without the `sub-` prefix
#'   (e.g. `"01"`).
#' @param session Character or `NULL`. Session label without the `ses-` prefix.
#'   If `NULL` (default), assumes a single-session dataset.
#' @param task Character or `NULL`. Task label (e.g. `"rest"`). If `NULL`,
#'   the first task found is used.
#' @param space Character. Template space for the BOLD and mask files.
#'   Default `"MNI152NLin2009cAsym"`.
#' @param resolution Character or `NULL`. Resolution label (e.g. `"2"`).
#'   If `NULL`, resolution is not filtered.
#'
#' @return A list of class `boldR_fmriprep` with components:
#' \describe{
#'   \item{bold}{Character. Path to the BOLD NIfTI file.}
#'   \item{bold_mask}{Character. Path to the brain mask NIfTI file.}
#'   \item{t1w}{Character. Path to the T1w NIfTI file in template space.}
#'   \item{t2w}{Character or `NA`. Path to the T2w NIfTI file if available.}
#'   \item{dseg}{Character. Path to the discrete segmentation NIfTI file.}
#'   \item{confounds}{Character. Path to the confounds TSV file.}
#'   \item{subject}{Character. Subject label.}
#'   \item{session}{Character or `NA`. Session label.}
#'   \item{task}{Character. Task label.}
#'   \item{space}{Character. Template space.}
#'   \item{derivatives_dir}{Character. Resolved path to the derivatives root.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fprep <- read_fmriprep(
#'   derivatives_dir = "data/derivatives/fmriprep",
#'   subject         = "01",
#'   task            = "rest"
#' )
#' fprep
#' }
read_fmriprep <- function(derivatives_dir,
                          subject,
                          session    = NULL,
                          task       = NULL,
                          space      = "MNI152NLin2009cAsym",
                          resolution = NULL) {
  if (!dir.exists(derivatives_dir)) {
    cli::cli_abort("Derivatives directory not found: {.path {derivatives_dir}}")
  }

  sub_label <- paste0("sub-", subject)
  ses_label <- if (!is.null(session)) paste0("ses-", session) else NULL

  func_dir <- file.path(derivatives_dir, sub_label,
                        if (!is.null(ses_label)) ses_label else NULL,
                        "func")
  anat_dir <- file.path(derivatives_dir, sub_label,
                        if (!is.null(ses_label)) ses_label else NULL,
                        "anat")

  if (!dir.exists(func_dir)) {
    cli::cli_abort("func/ directory not found: {.path {func_dir}}")
  }

  # ── Discover task label ────────────────────────────────────────────────────
  bold_files <- list.files(func_dir, pattern = "\\.nii(\\.gz)?$",
                           full.names = TRUE)
  bold_files <- bold_files[grepl("_bold\\.nii", bold_files)]
  bold_files <- bold_files[grepl(paste0("space-", space), bold_files)]

  if (!is.null(resolution)) {
    bold_files <- bold_files[grepl(paste0("res-", resolution), bold_files)]
  }

  if (!is.null(task)) {
    bold_files <- bold_files[grepl(paste0("task-", task), bold_files)]
  }

  if (length(bold_files) == 0) {
    cli::cli_abort(
      "No BOLD file found for subject {subject} in space {space}."
    )
  }

  bold_path <- bold_files[[1L]]

  # Infer task label from filename
  task_detected <- regmatches(
    bold_path, regexpr("(?<=task-)[^_]+", bold_path, perl = TRUE)
  )

  # ── Companion files ────────────────────────────────────────────────────────
  base_pattern <- sub("_bold\\.nii.*", "", basename(bold_path))

  bold_mask <- list.files(func_dir,
                          pattern = paste0(base_pattern, "_brain_mask"),
                          full.names = TRUE)
  bold_mask <- if (length(bold_mask)) bold_mask[[1L]] else NA_character_

  confounds <- list.files(func_dir,
                          pattern = paste0(base_pattern,
                                           "_desc-confounds_timeseries.tsv"),
                          full.names = TRUE)
  confounds <- if (length(confounds)) confounds[[1L]] else NA_character_

  # ── Anatomical files ───────────────────────────────────────────────────────
  t1w <- list.files(anat_dir,
                    pattern = paste0(sub_label, ".*space-", space,
                                     ".*_T1w\\.nii"),
                    full.names = TRUE)
  t1w <- if (length(t1w)) t1w[[1L]] else NA_character_

  t2w <- list.files(anat_dir,
                    pattern = paste0(sub_label, ".*space-", space,
                                     ".*_T2w\\.nii"),
                    full.names = TRUE)
  t2w <- if (length(t2w)) t2w[[1L]] else NA_character_

  dseg <- list.files(anat_dir,
                     pattern = paste0(sub_label, ".*space-", space,
                                      ".*_dseg\\.nii"),
                     full.names = TRUE)
  dseg <- if (length(dseg)) dseg[[1L]] else NA_character_

  structure(
    list(
      bold            = normalizePath(bold_path, mustWork = FALSE),
      bold_mask       = normalizePath(bold_mask, mustWork = FALSE),
      t1w             = normalizePath(t1w,       mustWork = FALSE),
      t2w             = normalizePath(t2w,       mustWork = FALSE),
      dseg            = normalizePath(dseg,      mustWork = FALSE),
      confounds       = normalizePath(confounds, mustWork = FALSE),
      subject         = subject,
      session         = session %||% NA_character_,
      task            = task_detected,
      space           = space,
      derivatives_dir = normalizePath(derivatives_dir)
    ),
    class = "boldR_fmriprep"
  )
}

#' @export
print.boldR_fmriprep <- function(x, ...) {
  cli::cli_h1("boldR fMRIPrep derivatives")
  cli::cli_inform(c(
    "i" = "Subject:  {x$subject}",
    "i" = "Session:  {x$session}",
    "i" = "Task:     {x$task}",
    "i" = "Space:    {x$space}",
    "i" = "BOLD:     {.path {x$bold}}",
    "i" = "T1w:      {.path {x$t1w}}",
    "i" = "dseg:     {.path {x$dseg}}",
    "i" = "Confounds:{.path {x$confounds}}"
  ))
  invisible(x)
}
