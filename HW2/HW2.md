Homework 2
================
CB
2022-09-29

## R Markdown

\#Load required libraries

``` r
library(data.table)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday, week,
    ##     yday, year

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     between, first, last

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyverse)
```

    ## ── Attaching packages
    ## ───────────────────────────────────────
    ## tidyverse 1.3.2 ──

    ## ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.8     ✔ stringr 1.4.1
    ## ✔ tidyr   1.2.0     ✔ forcats 0.5.2
    ## ✔ readr   2.1.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ lubridate::as.difftime() masks base::as.difftime()
    ## ✖ dplyr::between()         masks data.table::between()
    ## ✖ lubridate::date()        masks base::date()
    ## ✖ dplyr::filter()          masks stats::filter()
    ## ✖ dplyr::first()           masks data.table::first()
    ## ✖ lubridate::hour()        masks data.table::hour()
    ## ✖ lubridate::intersect()   masks base::intersect()
    ## ✖ lubridate::isoweek()     masks data.table::isoweek()
    ## ✖ dplyr::lag()             masks stats::lag()
    ## ✖ dplyr::last()            masks data.table::last()
    ## ✖ lubridate::mday()        masks data.table::mday()
    ## ✖ lubridate::minute()      masks data.table::minute()
    ## ✖ lubridate::month()       masks data.table::month()
    ## ✖ lubridate::quarter()     masks data.table::quarter()
    ## ✖ lubridate::second()      masks data.table::second()
    ## ✖ lubridate::setdiff()     masks base::setdiff()
    ## ✖ purrr::transpose()       masks data.table::transpose()
    ## ✖ lubridate::union()       masks base::union()
    ## ✖ lubridate::wday()        masks data.table::wday()
    ## ✖ lubridate::week()        masks data.table::week()
    ## ✖ lubridate::yday()        masks data.table::yday()
    ## ✖ lubridate::year()        masks data.table::year()

``` r
library(dtplyr)
```

\#Load in data from github

``` r
download.file("https://raw.githubusercontent.com/USCbiostats/data-science-data/master/01_chs/chs_individual.csv", "individual.gz", method="libcurl", timeout = 60)

individual <- data.table::fread("individual.gz")

download.file("https://raw.githubusercontent.com/USCbiostats/data-science-data/master/01_chs/chs_regional.csv", "regional.gz", method="libcurl", timeout = 60)

regional <- data.table::fread("regional.gz")
```

``` r
dim(individual)
```

    ## [1] 1200   23

``` r
head(individual)
```

    ##    sid  townname male race hispanic    agepft height weight      bmi asthma
    ## 1:   1 Lancaster    1    W        0 10.154689    123     54 16.22411      0
    ## 2:   2 Lancaster    1    W        0 10.461328    145     77 16.64685      0
    ## 3:   6 Lancaster    0    B        0 10.097194    145    143 30.91558      0
    ## 4:   7 Lancaster    0    O        0 10.746064    156     72 13.44809      0
    ## 5:   8 Lancaster    0    W        1  9.782341    132     61 15.91326      0
    ## 6:  10 Lancaster    1    O        1        NA     NA     NA       NA      0
    ##    active_asthma father_asthma mother_asthma wheeze hayfever allergy
    ## 1:             0             0             0      0        0       0
    ## 2:             0             0             0      1        0       0
    ## 3:             0             0             0      0        1       0
    ## 4:             0            NA             0      1        0       0
    ## 5:             0             1             0      1        1       1
    ## 6:             1             1             0      0        0       0
    ##    educ_parent smoke pets gasstove      fev      fvc     mmef
    ## 1:           3     0    1        1 1650.254 1800.005 2537.777
    ## 2:           5     0    1        0 2273.129 2721.111 2365.745
    ## 3:           2     0    0        1 2011.653 2257.244 1818.973
    ## 4:           2     1    1        1 1643.092 2060.526 1462.500
    ## 5:           3     0    1        0 1651.974 1996.382 1606.579
    ## 6:           1     0    1        1       NA       NA       NA

``` r
head(regional)
```

    ##         townname pm25_mass pm25_so4 pm25_no3 pm25_nh4 pm25_oc pm25_ec pm25_om
    ## 1:        Alpine      8.74     1.73     1.59     0.88    2.54    0.48    3.04
    ## 2: Lake Elsinore     12.35     1.90     2.98     1.36    3.64    0.62    4.36
    ## 3:  Lake Gregory      7.66     1.07     2.07     0.91    2.46    0.40    2.96
    ## 4:     Lancaster      8.50     0.91     1.87     0.78    4.43    0.55    5.32
    ## 5:        Lompoc      5.96     1.08     0.73     0.41    1.45    0.13    1.74
    ## 6:    Long Beach     19.12     3.23     6.22     2.57    5.21    1.36    6.25
    ##    pm10_oc pm10_ec pm10_tc formic acetic  hcl hno3 o3_max o3106 o3_24   no2
    ## 1:    3.25    0.49    3.75   1.03   2.49 0.41 1.98  65.82 55.05 41.23 12.18
    ## 2:    4.66    0.63    5.29   1.18   3.56 0.46 2.63  66.70 54.42 32.23 17.03
    ## 3:    3.16    0.41    3.57   0.66   2.36 0.28 2.28  84.44 67.01 57.76  7.62
    ## 4:    5.68    0.56    8.61   0.88   2.88 0.22 1.80  54.81 43.88 32.86 15.77
    ## 5:    1.86    0.14    1.99   0.34   0.75 0.33 0.43  43.85 37.74 28.37  4.60
    ## 6:    6.68    1.39    8.07   1.57   2.94 0.73 2.67  39.44 28.22 18.22 33.11
    ##     pm10 no_24hr pm2_5_fr iacid oacid total_acids       lon      lat
    ## 1: 24.73    2.48    10.28  2.39  3.52        5.50 -116.7664 32.83505
    ## 2: 34.25    7.07    14.53  3.09  4.74        7.37 -117.3273 33.66808
    ## 3: 20.05      NA     9.01  2.56  3.02        5.30 -117.2752 34.24290
    ## 4: 25.04   12.68       NA  2.02  3.76        5.56 -118.1542 34.68678
    ## 5: 18.40    2.05       NA  0.76  1.09        1.52 -120.4579 34.63915
    ## 6: 38.41   36.76    22.23  3.40  4.51        7.18 -118.1937 33.77005

``` r
#Trim down this dataset so it just has the info we are going to use (PM2.5 data and location for the leaflet)
regional_trim <- regional[, c("townname", "pm25_mass", "lon", "lat")]
regional_trim
```

    ##          townname pm25_mass       lon      lat
    ##  1:        Alpine      8.74 -116.7664 32.83505
    ##  2: Lake Elsinore     12.35 -117.3273 33.66808
    ##  3:  Lake Gregory      7.66 -117.2752 34.24290
    ##  4:     Lancaster      8.50 -118.1542 34.68678
    ##  5:        Lompoc      5.96 -120.4579 34.63915
    ##  6:    Long Beach     19.12 -118.1937 33.77005
    ##  7:     Mira Loma     29.97 -117.5159 33.98454
    ##  8:     Riverside     22.39 -117.3755 33.98060
    ##  9:     San Dimas     20.52 -117.8067 34.10668
    ## 10:    Atascadero      7.48 -120.6707 35.48942
    ## 11:   Santa Maria      7.19 -120.4357 34.95303
    ## 12:        Upland     22.46 -117.6484 34.09751

\#How many unique townnames are there?

``` r
unique(individual$townname)
```

    ##  [1] "Lancaster"     "San Dimas"     "Atascadero"    "Riverside"    
    ##  [5] "Mira Loma"     "Alpine"        "Lake Elsinore" "Lake Gregory" 
    ##  [9] "Long Beach"    "Santa Maria"   "Upland"        "Lompoc"

``` r
unique(regional_trim$townname)
```

    ##  [1] "Alpine"        "Lake Elsinore" "Lake Gregory"  "Lancaster"    
    ##  [5] "Lompoc"        "Long Beach"    "Mira Loma"     "Riverside"    
    ##  [9] "San Dimas"     "Atascadero"    "Santa Maria"   "Upland"

\#Check variables for merging. There are 12 unique townnames. This
matches with the 12 rows from the regional dataset. \#Merge data

``` r
hw2data <-merge(individual, regional_trim, by="townname" )
dim(hw2data)
```

    ## [1] 1200   26

\#\_This looks correct, there are 1200 rows and now the three additional
columns added in the regional (trimmed) dataset

``` r
head(hw2data)
```

    ##    townname sid male race hispanic    agepft height weight      bmi asthma
    ## 1:   Alpine 835    0    W        0 10.099932    143     69 15.33749      0
    ## 2:   Alpine 838    0    O        1  9.486653    133     62 15.93183      0
    ## 3:   Alpine 839    0    M        1 10.053388    142     86 19.38649      0
    ## 4:   Alpine 840    0    W        0  9.965777    146     78 16.63283      0
    ## 5:   Alpine 841    1    W        1 10.548939    150     78 15.75758      0
    ## 6:   Alpine 842    1    M        1  9.489391    139     65 15.29189      0
    ##    active_asthma father_asthma mother_asthma wheeze hayfever allergy
    ## 1:             0             0             0      0        0       1
    ## 2:             0             0             0      0        0       0
    ## 3:             0             0             1      1        1       1
    ## 4:             0             0             0      0        0       0
    ## 5:             0             0             0      0        0       0
    ## 6:             0             0             0      1        0       0
    ##    educ_parent smoke pets gasstove      fev      fvc     mmef pm25_mass
    ## 1:           3     0    1        0 2529.276 2826.316 3406.579      8.74
    ## 2:           4    NA    1        0 1737.793 1963.545 2133.110      8.74
    ## 3:           3     1    1        0 2121.711 2326.974 2835.197      8.74
    ## 4:          NA    NA    0       NA 2466.791 2638.221 3466.464      8.74
    ## 5:           5     0    1        0 2251.505 2594.649 2445.151      8.74
    ## 6:           1     1    1        0 2188.716 2423.934 2524.599      8.74
    ##          lon      lat
    ## 1: -116.7664 32.83505
    ## 2: -116.7664 32.83505
    ## 3: -116.7664 32.83505
    ## 4: -116.7664 32.83505
    ## 5: -116.7664 32.83505
    ## 6: -116.7664 32.83505

``` r
tail(hw2data)
```

    ##    townname  sid male race hispanic    agepft height weight      bmi asthma
    ## 1:   Upland 1866    0    O        1  9.806982    139     60 14.11559      0
    ## 2:   Upland 1867    0    M        1  9.618070    140     71 16.46568      0
    ## 3:   Upland 2031    1    W        0  9.798768    135     83 20.70084      0
    ## 4:   Upland 2032    1    W        0  9.549624    137     59 14.28855      0
    ## 5:   Upland 2033    0    M        0 10.121834    130     67 18.02044      0
    ## 6:   Upland 2053    0    W        0        NA     NA     NA       NA      0
    ##    active_asthma father_asthma mother_asthma wheeze hayfever allergy
    ## 1:             0            NA             0      0       NA      NA
    ## 2:             0             1             0      0        0       0
    ## 3:             0             0             0      1        0       1
    ## 4:             0             0             1      1        1       1
    ## 5:             1             0             0      1        1       0
    ## 6:             0             0             0      0        0       0
    ##    educ_parent smoke pets gasstove      fev      fvc     mmef pm25_mass
    ## 1:           3     0    1        0 1691.275 1928.859 1890.604     22.46
    ## 2:           3     0    1        0 1733.338 1993.040 2072.643     22.46
    ## 3:           3     0    1        1 2034.177 2505.535 1814.075     22.46
    ## 4:           3     0    1        1 2077.703 2275.338 2706.081     22.46
    ## 5:           3     0    1        1 1929.866 2122.148 2558.054     22.46
    ## 6:           3     0    1        0       NA       NA       NA     22.46
    ##          lon      lat
    ## 1: -117.6484 34.09751
    ## 2: -117.6484 34.09751
    ## 3: -117.6484 34.09751
    ## 4: -117.6484 34.09751
    ## 5: -117.6484 34.09751
    ## 6: -117.6484 34.09751
