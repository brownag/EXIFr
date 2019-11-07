.read_ifd_at <- function(IFD_start, all_bytes, endian, TIFF_offset) {

  tag_list <- list()
  nb_dir_entries <- readBin(
    all_bytes[(IFD_start + 1):(IFD_start + 2)],
    "integer",
    size = 2,
    endian = endian
  )

  IFD_start <- IFD_start + 3

  for (i in 1:nb_dir_entries) {

    tag_number <- readBin(
      all_bytes[(IFD_start):(IFD_start + 1 )],
      "integer",
      size = 2,
      endian = endian,
      signed = FALSE
    ) # tag number

    tag_type <- readBin(
      all_bytes[(IFD_start + 2):(IFD_start + 3 )],
      "integer",
      size = 2,
      endian = endian
    )

    data_length <- readBin(
      all_bytes[(IFD_start + 4):(IFD_start + 7 )],
      "integer",
      size = 4,
      endian = endian
    )
    data_position <- readBin(
      all_bytes[(IFD_start + 8):(IFD_start + 11 )],
      "integer",
      size = 4,
      endian = endian
    )

    tag_name <- .tag_number_to_tag_name(tag_number)
    tag_value <- switch(tag_type,
      # 1 Byte
      paste(lapply(0:(data_length - 1), function(i) {
        readBin(all_bytes[TIFF_offset + data_position + i + 1],
        "raw",
        size = 1
      )}), collapse=" ")
    , # 2 ASCII
      readBin(
        all_bytes[(TIFF_offset + data_position + 1):
              (TIFF_offset + data_position + data_length)],
        "char",
        size = data_length
      )
    , # 3 Int 16 bit
    # For entries less than 4 bytes, read data directly
      readBin(
        all_bytes[(IFD_start + 8):
                    (IFD_start + 11)],
        "integer",
        endian = endian,
        size = 2
      )
    , # 4 Int 32 bit
      # For entries less than 4 bytes, read data directly
      readBin(
        all_bytes[(IFD_start + 8):
                    (IFD_start + 11)],
        "integer",
        endian = endian,
        size = 4
      )
    , # 5 Rational
      paste(unlist(lapply(0:(data_length - 1), function(i) {
        paste(
          readBin(
            all_bytes[(TIFF_offset + data_position + 1 + (i * 8)):
                        (TIFF_offset + data_position + 4 + (i * 8))],
            "integer",
            endian = endian,
            size = 4
          ),
          readBin(
            all_bytes[(TIFF_offset + data_position + 5 + (i * 8)):
                        (TIFF_offset + data_position + 8 + (i * 8))],
            "integer",
            endian = endian,
            size = 4
          ),
          sep = "/"
        )
      })), collapse=" ")
    )

    IFD_start <- IFD_start + 12

    # these are the pointers to EXIF and GPS IFDs
    if (tag_number %in% c(34665, 34853)) {
      #http://www.awaresystems.be/imaging/tiff/tifftags/subifds.html
      # Sub IFD offsets are relative to the TIFF header
      tag_list <- append(
        tag_list,
        .read_ifd_at(tag_value + TIFF_offset, all_bytes, endian, TIFF_offset)
      )
    } else {
      if (tag_name %in% supported_tags()) {
        tag_list[[tag_name]] <- tag_value
      }
    }

  }

  return (tag_list)

}


.find_raw_marker <- function(marker, all_bytes, start_offset=0) {

  reading_head <- start_offset + 1
  marker_length <- nchar(marker[1]) / 2 # Hope all markers have the same length
  repeat {
    slice <- readBin(
      all_bytes[reading_head:(reading_head + marker_length - 1)],
      "raw",
      n = marker_length
    )

    current_marker <- toupper(paste(slice,collapse = ""))
    if (current_marker %in% marker) {
      return(list(offset = reading_head - 1, marker = current_marker))
    } else {
      reading_head <- reading_head + 1
    }

    if (reading_head > length(all_bytes)) {
      break;
    }
  }
}

#' List EXIF tags currently supported by this package.
#' @description Currently supported tags include:
#' ApertureValue, Artist, BitsPerSample, BrightnessValue, CellLength,
#' CellWidth, CFAPattern, ColorMap, ColorSpace, ComponentsConfiguration,
#' CompressedBitsPerPixel, Compression, Contrast, Copyright, CustomRendered,
#' DateTime, DateTimeDigitized, DateTimeOriginal, DeviceSettingDescription,
#' DigitalZoomRatio, ExifVersion, ExposureBiasValue, ExposureIndex,
#' ExposureMode, ExposureProgram, ExposureTime, ExtraSamples, FileSource,
#' FillOrder, Flash, FlashEnergy, FlashpixVersion, FNumber, FocalLength,
#' FocalLengthIn35mmFilm, FocalPlaneResolutionUnit, FocalPlaneXResolution,
#' FocalPlaneYResolution, FreeByteCounts, FreeOffsets, GainControl,
#' GPSAltitude, GPSAltitudeRef, GPSAreaInformation, GPSDateStamp,
#' GPSDestBearing, GPSDestBearingRef, GPSDestDistance, GPSDestDistanceRef,
#' GPSDestLatitude, GPSDestLatitudeRef, GPSDestLongitude, GPSDestLongitudeRef,
#' GPSDifferential, GPSDOP, GPSImgDirection, GPSImgDirectionRef, GPSLatitude,
#' GPSLatitudeRef, GPSLongitude, GPSLongitudeRef, GPSMapDatum, GPSMeasureMode,
#' GPSProcessingMethod, GPSSatellites, GPSSpeed, GPSSpeedRef, GPSStatus,
#' GPSTimeStamp, GPSTrack, GPSTrackRef, GPSVersionID, GrayResponseCurve,
#' GrayResponseUnit, HostComputer, ImageDescription, ImageLength,
#' ImageUniqueID, ImageWidth, ISOSpeedRatings, LightSource, Make,
#' MakerNote, MaxApertureValue, MaxSampleValue, MeteringMode, MinSampleValue,
#' Model, NewSubfileType, OECF, OffsetTime, OffsetTimeDigitized,
#' OffsetTimeOriginal,  Orientation, PhotometricInterpretation,
#' PixelXDimension, PixelYDimension, PlanarConfiguration, RelatedSoundFile,
#' ResolutionUnit, RowsPerStrip, SamplesPerPixel, Saturation,
#' SceneCaptureType, SceneType, SensingMethod, Sharpness, ShutterSpeedValue,
#' Software, SpatialFrequencyResponse, SpectralSensitivity, StripByteCounts,
#' StripOffsets, SubfileType, SubjectArea, SubjectDistance,
#' SubjectDistanceRange, SubjectLocation, SubsecTime, SubsecTimeDigitized,
#' SubsecTimeOriginal, Threshholding, UserComment, WhiteBalance, XResolution,
#' YResolution.
#' @return A vector of EXIF tag names.
#' @author Charles Martin
#' @example /inst/examples/supported.Example.R
#' @export
supported_tags <- function() {
  unname(unlist(.supported_tags()))
}

.supported_tags <- function() {
  # code for constructing dput-ed hard-code list
  # z <- read.csv("data/base_TIFF_tags.csv", stringsAsFactors = F)
  # pairs[as.character(z$code)] <- as.character(z$name)
  # pairs <- pairs[names(unlist(pairs))[order(as.character(unlist(pairs)))]]

  pairs <- list(`37378` = "ApertureValue", `315` = "Artist", `258` = "BitsPerSample",
                `37379` = "BrightnessValue", `265` = "CellLength", `264` = "CellWidth",
                `41730` = "CFAPattern", `320` = "ColorMap", `40961` = "ColorSpace",
                `37121` = "ComponentsConfiguration", `37122` = "CompressedBitsPerPixel",
                `259` = "Compression", `41992` = "Contrast", `33432` = "Copyright",
                `41985` = "CustomRendered", `306` = "DateTime", `36868` = "DateTimeDigitized",
                `36867` = "DateTimeOriginal", `41995` = "DeviceSettingDescription",
                `41988` = "DigitalZoomRatio", `36864` = "ExifVersion", `37380` = "ExposureBiasValue",
                `41493` = "ExposureIndex", `41986` = "ExposureMode", `34850` = "ExposureProgram",
                `33434` = "ExposureTime", `338` = "ExtraSamples", `41728` = "FileSource",
                `266` = "FillOrder", `37385` = "Flash", `41483` = "FlashEnergy",
                `40960` = "FlashpixVersion", `33437` = "FNumber", `37386` = "FocalLength",
                `41989` = "FocalLengthIn35mmFilm", `41488` = "FocalPlaneResolutionUnit",
                `41486` = "FocalPlaneXResolution", `41487` = "FocalPlaneYResolution",
                `289` = "FreeByteCounts", `288` = "FreeOffsets", `41991` = "GainControl",
                `6` = "GPSAltitude", `5` = "GPSAltitudeRef", `28` = "GPSAreaInformation",
                `29` = "GPSDateStamp", `24` = "GPSDestBearing", `23` = "GPSDestBearingRef",
                `26` = "GPSDestDistance", `25` = "GPSDestDistanceRef", `20` = "GPSDestLatitude",
                `19` = "GPSDestLatitudeRef", `22` = "GPSDestLongitude", `21` = "GPSDestLongitudeRef",
                `30` = "GPSDifferential", `11` = "GPSDOP", `17` = "GPSImgDirection",
                `16` = "GPSImgDirectionRef", `2` = "GPSLatitude", `1` = "GPSLatitudeRef",
                `4` = "GPSLongitude", `3` = "GPSLongitudeRef", `18` = "GPSMapDatum",
                `10` = "GPSMeasureMode", `27` = "GPSProcessingMethod", `8` = "GPSSatellites",
                `13` = "GPSSpeed", `12` = "GPSSpeedRef", `9` = "GPSStatus",
                `7` = "GPSTimeStamp", `15` = "GPSTrack", `14` = "GPSTrackRef",
                `0` = "GPSVersionID", `291` = "GrayResponseCurve", `290` = "GrayResponseUnit",
                `316` = "HostComputer", `270` = "ImageDescription", `257` = "ImageLength",
                `42016` = "ImageUniqueID", `256` = "ImageWidth", `34855` = "ISOSpeedRatings",
                `37384` = "LightSource", `271` = "Make", `37500` = "MakerNote",
                `37381` = "MaxApertureValue", `281` = "MaxSampleValue", `37383` = "MeteringMode",
                `280` = "MinSampleValue", `272` = "Model", `254` = "NewSubfileType",
                `34856` = "OECF", `36880` = "OffsetTime", `36882` = "OffsetTimeDigitized",
                `36881` = "OffsetTimeOriginal", `274` = "Orientation", `262` = "PhotometricInterpretation",
                `40962` = "PixelXDimension", `40963` = "PixelYDimension",
                `284` = "PlanarConfiguration", `40964` = "RelatedSoundFile",
                `296` = "ResolutionUnit", `278` = "RowsPerStrip", `277` = "SamplesPerPixel",
                `41993` = "Saturation", `41990` = "SceneCaptureType", `41729` = "SceneType",
                `41495` = "SensingMethod", `41994` = "Sharpness", `37377` = "ShutterSpeedValue",
                `305` = "Software", `41484` = "SpatialFrequencyResponse",
                `34852` = "SpectralSensitivity", `279` = "StripByteCounts",
                `273` = "StripOffsets", `255` = "SubfileType", `37396` = "SubjectArea",
                `37382` = "SubjectDistance", `41996` = "SubjectDistanceRange",
                `41492` = "SubjectLocation", `37520` = "SubsecTime", `37522` = "SubsecTimeDigitized",
                `37521` = "SubsecTimeOriginal", `263` = "Threshholding",
                `37510` = "UserComment", `41987` = "WhiteBalance", `282` = "XResolution",
                `283` = "YResolution")
  pairs

}

.tag_number_to_tag_name <- function(tag_number){

  t <- as.character(tag_number)
  if (t %in% names(.supported_tags())) {
    .supported_tags()[[t]]
  } else {
    tag_number
  }

}

#' Extract EXIF tags from an image file.
#'
#' Values are returned directly from the file, without any formatting.
#' For example, the exposure time (ExposureTime), will be "1/3200".
#' This value can be converted afterwards with \code{\link{rational_to_numeric}}.
#'
#' @param file_path The path to the image.
#' @return A list-based S3 object of class exifData containing the tags and their values.
#' @example /inst/examples/readexif.Example.R
#' @export
#' @seealso \code{\link{rational_to_numeric}, \link{rationalDMS_to_numeric}}
read_exif_tags <- function(file_path) {
  con <- file(file_path, "rb")
  rm(file_path)
  all_bytes <- readBin(
    con, "raw",
    n = 128000, # All info should be in the first 128k (and probably 64k)
    size = 1
  )
  close(con);rm(con)

  # Find the APP1 marker
  res <- .find_raw_marker("FFE1", all_bytes)
  APP1_offset <- res$offset

  if (is.null(res)) {
    stop("APP1 marker not found, this image type is probably not supported.")
  }

  # Read the length of the APP1 marker (APP1_offset + 1 + length of FFE1 marker)
  readBin(
    all_bytes[(APP1_offset + 1 + 2):(APP1_offset + 2 + 2)],
    "integer",
    size = 2,
    signed = FALSE,
    endian = "big" # Data size(2 Bytes) has "Motorola" byte alig
  )

  # which is Exif in ASCII
  res <- .find_raw_marker(
    "45786966",
    all_bytes,
    start_offset = APP1_offset + 2 + 2
  )
  if (is.null(res)) {
    stop("EXIF marker not found.")
  }

  Exif_offset <- res$offset

  # Read for little of big endian = THIS IS THE BEGINNING OF THE TIFF HEADER
  res <- .find_raw_marker(
    c("4D4D","4949"),
    all_bytes,
    start_offset = Exif_offset
  )
  TIFF_offset <- res$offset
  if ( res$marker == "4D4D") {
    endian <- "big"
  } else {
    endian <- "little"
  }
  rm(res)

  # 002a or 2a00 depending on endianess
  readBin(all_bytes[(TIFF_offset + 3):(TIFF_offset + 4)],"raw",n = 2)

  IFD_offset <- readBin(
    all_bytes[(TIFF_offset + 5):(TIFF_offset + 5 + 3)],
    "integer",
    size = 4,
    endian = endian
  )

  structure(
    .read_ifd_at(TIFF_offset + IFD_offset, all_bytes, endian, TIFF_offset),
    class = "exifData"
  )

}


#' @export
print.exifData <- function(x,...) {
  for (name in names(x)) {
    cat(paste(
      stringr::str_pad(name, max(stringr::str_length(names(x))), side = "right", pad = " "),
      ":",
      x[[name]],"\r\n"
    ))
  }
}