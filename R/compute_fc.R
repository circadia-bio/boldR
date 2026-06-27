#' Compute functional connectivity from parcellated BOLD timeseries
#'
#' Estimates a ROI-to-ROI functional connectivity matrix from a parcellated
#' BOLD timeseries using Pearson correlation (default) or partial correlation.
#' Returns both the full symmetric matrix and a tidy long-format data frame.
#'
#' @param parcellated A `boldr_parcellated` object from [parcellate()].
#' @param method Character. Connectivity metric. One of:
#'   \describe{
#'     \item{`"pearson"`}{(Default) Pearson product-moment correlation.}
#'     \item{`"partial"`}{Partial correlation (requires `corpcor` in Suggests).}
#'   }
#' @param fisher_z Logical. Whether to apply Fisher r-to-z transformation
#'   before returning values. Default `TRUE`. Diagonal is set to `NA`.
#'
#' @return A list of class `boldr_fc` with components:
#' \describe{
#'   \item{matrix}{Numeric matrix (n_rois × n_rois). Symmetric FC matrix with
#'     `NA` on the diagonal.}
#'   \item{long}{Data frame (long format). Columns: `roi_i`, `roi_j`,
#'     `roi_name_i`, `roi_name_j`, `fc`.}
#'   \item{method}{Character. Connectivity method used.}
#'   \item{fisher_z}{Logical. Whether Fisher z was applied.}
#'   \item{atlas_name}{Character. Atlas identifier.}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' parc <- parcellate(cleaned, atlas)
#' fc   <- compute_fc(parc)
#' dim(fc$matrix)
#' head(fc$long)
#' }
compute_fc <- function(parcellated,
                       method   = c("pearson", "partial"),
                       fisher_z = TRUE) {
  method <- match.arg(method)

  if (!inherits(parcellated, "boldr_parcellated")) {
    cli::cli_abort("{.arg parcellated} must be a {.cls boldr_parcellated} object.")
  }

  ts_wide <- parcellated$timeseries_wide

  # ── Correlation matrix ────────────────────────────────────────────────────
  if (method == "pearson") {
    fc_mat <- stats::cor(ts_wide, use = "pairwise.complete.obs")
  } else {
    if (!requireNamespace("corpcor", quietly = TRUE)) {
      cli::cli_abort(c(
        "Partial correlation requires the {.pkg corpcor} package.",
        "i" = "Install it with: {.code install.packages('corpcor')}"
      ))
    }
    fc_mat <- corpcor::cor2pcor(stats::cor(ts_wide, use = "pairwise.complete.obs"))
    colnames(fc_mat) <- rownames(fc_mat) <- colnames(ts_wide)
  }

  # ── Fisher z ──────────────────────────────────────────────────────────────
  if (fisher_z) {
    fc_mat <- atanh(fc_mat)
    fc_mat[is.infinite(fc_mat)] <- NA_real_
  }
  diag(fc_mat) <- NA_real_

  # ── Long format ───────────────────────────────────────────────────────────
  roi_names <- colnames(fc_mat)
  n_rois    <- length(roi_names)
  idx       <- which(upper.tri(fc_mat), arr.ind = TRUE)

  fc_long <- tibble::tibble(
    roi_i      = idx[, 1],
    roi_j      = idx[, 2],
    roi_name_i = roi_names[idx[, 1]],
    roi_name_j = roi_names[idx[, 2]],
    fc         = fc_mat[idx]
  )

  cli::cli_alert_success(
    "FC matrix computed: {n_rois} ROI{?s}, method = {.val {method}}."
  )

  structure(
    list(
      matrix     = fc_mat,
      long       = fc_long,
      method     = method,
      fisher_z   = fisher_z,
      atlas_name = parcellated$atlas_name
    ),
    class = "boldr_fc"
  )
}

#' @export
print.boldr_fc <- function(x, ...) {
  cli::cli_h1("boldR functional connectivity")
  cli::cli_inform(c(
    "i" = "Atlas:    {.val {x$atlas_name}}",
    "i" = "ROIs:     {ncol(x$matrix)}",
    "i" = "Method:   {.val {x$method}}",
    "i" = "Fisher z: {x$fisher_z}"
  ))
  invisible(x)
}
