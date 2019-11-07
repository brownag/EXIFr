# EXIFr : Natively read EXIF tags from R

[![DOI](https://zenodo.org/badge/19481/cmartin/EXIFr.svg)](https://zenodo.org/badge/latestdoi/19481/cmartin/EXIFr) [![Build Status](https://travis-ci.org/cmartin/EXIFr.svg)](https://travis-ci.org/cmartin/EXIFr) [![Coverage Status](https://coveralls.io/repos/cmartin/EXIFr/badge.svg?branch=master&service=github)](https://coveralls.io/github/cmartin/EXIFr?branch=master)

This package natively reads EXIF tags from digital images. It does not rely on any external libraries or binary executables. The primary purpose of this fork is to provide access to EXIF read functionality through the R environment on USDA workstations, where relying on compiled code and or Perl scripts is not viable.

In this fork, all of the "baseline" TIFF tags, plus those in the EXIF and GPS tag sets are available to be parsed. Any tags on the full list will be returned by `r EXIFr::read_exif_data()` 

All values are returned are as stored in the image file -- which  This is in contrast to standard behavior of the `exiftool` Perl module, for instance, which does much massaging of the result. 

In some cases means the value is stored as a fraction or "RATIONAL" data type. For example ExposureTime is **"1/3200"** and not **0.0003125**. Likewise with the degree, minute and second components of GPSLatitude and GPSLongitude. 

N.B. A utility function is provided to convert from the rational format `rational_to_numeric("1/3200")`

## To install this fork: 

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
Make                     : Canon 
Model                    : Canon EOS DIGITAL REBEL XS 
Orientation              : 1 
XResolution              : 72/1 
YResolution              : 72/1 
ResolutionUnit           : 2 
DateTime                 : 2013:07:09 10:23:47 
ExposureTime             : 1/3200 
FNumber                  : 63/10 
ExposureProgram          : 3 
ISOSpeedRatings          : 800 
DateTimeOriginal         : 2013:07:09 10:23:47 
DateTimeDigitized        : 2013:07:09 10:23:47 
ApertureValue            : 43/8 
MaxApertureValue         : 5466/1427 
MeteringMode             : 5 
Flash                    : 16 
FocalLength              : 18/1 
SubsecTime               :  
SubsecTimeOriginal       :  
SubsecTimeDigitized      :  
ColorSpace               : 1 
PixelXDimension          : 100 
PixelYDimension          : 67 
FocalPlaneXResolution    : 215379/67 
FocalPlaneYResolution    : 32247/10 
FocalPlaneResolutionUnit : 2 
CustomRendered           : 0 
ExposureMode             : 0 
WhiteBalance             : 0 
SceneCaptureType         : 0 
```

```r
# To view the value of a specific tag
read_exif_tags(image_path)[["ApertureValue"]]
```

```
[1] "43/8"
```

OR

```r
rational_to_numeric(read_exif_tags(image_path)[["ApertureValue"]])
```

```
[1] 5.375
```

Another convenience function is for dealing with the 3-part RATIONAL result for GPSLatitude and GPSLongitude. 

```
# where the input is read with, for instance, 
#  read_exif_tags(image_path)[["GPSLongitude"]]

# convert degrees, minutes, seconds to decimal degrees
rationalDMS_to_decimal("120/1 17/1 1571/50")
```

```
[1] 120.292061111111
```
## Problems : 
Please report any bugs or feature requests to the [GitHub issue tracker](https://github.com/brownag/EXIFr/issues).

Any questions about the original EXIFr package should be directed to to <charles.martin1@uqtr.ca>

Issues pertaining to maintenance of the fork  [@brownag/EXIFr](https://github.com/brownag/EXIFr/) can contact <andrew.g.brown@usda.gov>

## More information 

An extensive list of TIFF tags and information about parsing  can be found here:

* [https://www.awaresystems.be/imaging/tiff/tifftags.html](https://www.awaresystems.be/imaging/tiff/tifftags.html)

More helpful information about the TIFF / EXIF standards:

* [http://www.exiv2.org/Exif2-2.PDF](http://www.exiv2.org/Exif2-2.PDF)
* [http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/](http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/)
* [http://www.media.mit.edu/pia/Research/deepview/exif.html](http://www.media.mit.edu/pia/Research/deepview/exif.html)


## Citation
If this code is useful to you, please cite the original package, whose robust framework was expanded on in this fork: 

```
Charles A. Martin (2015). EXIFr: Natively read EXIF tags from R. R package version 0.0.0.9004. https://github.com/cmartin/EXIFr. DOI:10.5281/zenodo.34691
```
