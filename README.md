# EXIFr : Natively read EXIF tags from R

[![DOI](https://zenodo.org/badge/19481/cmartin/EXIFr.svg)](https://zenodo.org/badge/latestdoi/19481/cmartin/EXIFr) [![Build Status](https://travis-ci.org/cmartin/EXIFr.svg)](https://travis-ci.org/cmartin/EXIFr) [![Coverage Status](https://coveralls.io/repos/cmartin/EXIFr/badge.svg?branch=master&service=github)](https://coveralls.io/github/cmartin/EXIFr?branch=master)

This package natively reads EXIF tags from digital images. It does not rely on any external libraries or binary executables.

All of the "baseline" TIFF tags, plus those in the EXIF and GPS tag sets. See: [https://www.awaresystems.be/imaging/tiff/tifftags.html](https://www.awaresystems.be/imaging/tiff/tifftags.html)

All values are returned as stored in the image file, which in some cases means the value is stored as a fraction or "RATIONAL" data type. For example ExposureTime is **"1/3200"** and not **0.0003125**. Likewise with the degree, minute and second components of GPSLatitude and GPSLongitude.

N.B. A utility function is provided to convert from the rational format `rational_to_numeric("1/3200")`

## To install : 

```r
devtools::install_github("brownag/EXIFr")
```

## To try the code with one of the example images : 

```r
library(EXIFr)

# To list all tags : 
image_path = system.file("extdata", "preview.jpg", package = "EXIFr")
read_exif_tags(image_path)
```

```
Make            : Canon 
Model           : Canon EOS DIGITAL REBEL XS 
DateTime        : 2013:07:09 10:23:47 
ExposureTime    : 1/3200 
ISOSpeedRatings : 800 
ApertureValue   : 43/8 
FocalLength     : 18/1 
PixelXDimension : 100 
PixelYDimension : 67 
```

```r
# To view the value of a specific tag
read_exif_tags(image_path)[["ApertureValue"]]
```

```
[1] "43/8"
```

```r
# or
rational_to_numeric(read_exif_tags(image_path)[["ApertureValue"]])
```

```
[1] 5.375
```

## If you need help with the EXIF format
The following resources were particularly useful :

* http://www.exiv2.org/Exif2-2.PDF
* http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/
* http://www.media.mit.edu/pia/Research/deepview/exif.html

## Problems : 
Please report any bugs to the [GitHub issue tracker](https://github.com/cmartin/EXIFr/issues) and write any questions to <charles.martin1@uqtr.ca>

Issues pertaining to the recent modifications in brownag/EXIFr can contact andrew.g.brown@usda.gov

## Citation
If this code is useful to you, please cite as : 

```
Charles A. Martin (2015). EXIFr: Natively read EXIF tags from R. R package version 0.0.0.9004. https://github.com/cmartin/EXIFr. DOI:10.5281/zenodo.34691
```
