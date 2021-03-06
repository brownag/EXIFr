context("Supported tags listing")

expect_true("ApertureValue" %in% supported_tags())

# AGB: ShutterSpeedValue is a legitimate tag to support, and has been included
#expect_false("ShutterSpeedValue" %in% supported_tags())

context("Basic EXIF extraction")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["Make"]],
  equals("Canon")
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["Make"]],
  equals("Wingscapes")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["DateTime"]],
  equals("2013:07:09 10:23:47")
)

context("Tags from the sub-IFD section")

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ExposureTime"]],
  equals("1/3200")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ApertureValue"]],
  equals("43/8")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["FocalLength"]],
  equals("18/1")
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["ISOSpeedRatings"]],
  equals(800)
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["PixelYDimension"]],
  equals(67)
)

expect_that(
  read_exif_tags(system.file("extdata", "preview.jpg", package = "EXIFr"))[["PixelXDimension"]],
  equals(100)
)

expect_that(
  read_exif_tags(system.file("extdata", "WSCT0151.JPG", package = "EXIFr"))[["ApertureValue"]],
  equals("3/1")
)

context("Utility functions")

expect_that(
  rational_to_numeric("3/1"),
  equals(3)
)

expect_that(
  rational_to_numeric("252606/100000"),
  equals(2.52606)
)

expect_that(
  rationalDMS_to_decimal(c("120/1 17/1 1571/50","120/1 17/1 1571/50")),
  equals(c(120.292061111111, 120.292061111111))
)