# Internal utilities for boldR
# Not exported. Do not edit the NAMESPACE for these.

# Null-coalescing operator
`%||%` <- function(x, y) if (!is.null(x)) x else y

# Self-contained theme for boldR plots (no circadia dependency)
.bold_theme <- function(base_size = 14) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) return(NULL)
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid       = ggplot2::element_blank(),
      axis.line.x      = ggplot2::element_line(colour = "#1B1035"),
      axis.line.y      = ggplot2::element_line(colour = "#1B1035"),
      text             = ggplot2::element_text(colour = "#1B1035"),
      plot.background  = ggplot2::element_rect(fill = "white", colour = NA)
    )
}

# Activation-inspired palette for boldR plots
.bold_palette <- c(
  indigo  = "#1B1035",
  rose    = "#C23661",
  steel   = "#3D6FA8",
  amber   = "#E8803E",
  cloud   = "#F2EEF9",
  mist    = "#E8E4F0",
  teal    = "#4A9BBF",
  cream   = "#FFF8F0"
)
