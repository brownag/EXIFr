# EXIFr : Natively read EXIF tags from R

This package natively reads EXIF tags from digital (JPEG) images. It does not rely on any external libraries or binary executables. Values are returned as stored in the image file. EXIF read capability in _native_ R will be useful for minimizing external, non-R dependencies.

**NOTE:** `EXIFr` is NOT the same package as `exifr`, which can be found on CRAN. `exifr` relies on either [an external Perl library or compiled executable](https://www.sno.phy.queensu.ca/~phil/exiftool/).

The _primary purpose of this fork_ is to provide access to EXIF read functionality, especially for GPS tags, through the R environment. All of the "baseline" TIFF tags, plus those in the EXIF and GPS tag sets are available to be parsed. Any tags on the list found in the image will be returned by `EXIFr::read_exif_data()` 

For some tags, the value is stored as a fraction or `RATIONAL` data type. For example _ExposureTime_ is **"1/3200"** and not **0.0003125**. Likewise for the degree, minute and second components of _GPSLatitude_ and _GPSLongitude_ for georeferenced images. 

See the examples involving `rational_to_decimal()` and `rationalDMS_to_decimal()`, helper functions for dealing with the `RATIONAL` tag type below.

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

Another convenience function is for dealing with the 3-part `RATIONAL` result for _GPSLatitude_ or _GPSLongitude_. 

```
# read in sample georeferenced image input 
geo_image_path = system.file("extdata", "taiwan-jiufen.jpg", package = "EXIFr")
res <- read_exif_tags(geo_image_path)

# inspect EXIF result
latlng <- c(res[["GPSLatitude"]], res[["GPSLongitude"]])
print(latlng)

# convert rational Lat/Long degrees, minutes, seconds to decimal degrees
rationalDMS_to_decimal(latlng)
```

```
[1] "25/1 6/1 295339/10000"   "121/1 50/1 382141/10000"

[1]  25.1082 121.8439
```

## Problems : 
Please report any bugs or feature requests to the [GitHub issue tracker](https://github.com/brownag/EXIFr/issues).

Any questions about the original [EXIFr](https://github.com/cmartin/EXIFr/) package should be directed to to <charles.martin1@uqtr.ca>

Matters pertaining to maintenance of the @brownag [EXIFr](https://github.com/brownag/EXIFr/) fork can contact <andrew.g.brown@usda.gov> or through the issue tracker linked above.

## More information 

An extensive list of TIFF tags, parsing, and the the TIFF / EXIF standards can be found here:

* [https://www.awaresystems.be/imaging/tiff/tifftags.html](https://www.awaresystems.be/imaging/tiff/tifftags.html)
* [http://www.exiv2.org/Exif2-2.PDF](http://www.exiv2.org/Exif2-2.PDF)
* [http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/](http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/)
* [http://www.media.mit.edu/pia/Research/deepview/exif.html](http://www.media.mit.edu/pia/Research/deepview/exif.html)


## Citation
If this code is useful to you, please cite the original package, whose robust framework was expanded on in this fork: 

```
Charles A. Martin (2015). EXIFr: Natively read EXIF tags from R. R package version 0.0.0.9004. https://github.com/cmartin/EXIFr. DOI:10.5281/zenodo.34691
```
