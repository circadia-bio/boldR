test_that("read_fmriprep errors on missing directory", {
  expect_error(
    read_fmriprep("/nonexistent/path", subject = "01"),
    regexp = "not found",
    ignore.case = TRUE
  )
})
