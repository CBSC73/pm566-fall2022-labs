Lab 03
================
CB
`r Sys.Date()`

`{r setup, include=FALSE} knitr::opts_chunk$set(echo = TRUE)`

## R Markdown

\##Read in the data

``` {r}
if (!file.exists("met_all.gz")) {
download.file("https://raw.githubusercontent.com/USCbiostats/data-science-data/master/02_met/met_all.gz", "met_all.gz", method="libcurl", timeout = 60)
}
met <- data.table::fread("met_all.gz")
```

\##Step 2 . Check the dimensions, headeres, footers. How many columns,
rows are there?

``` {r}
dim(met)
head(met)
tail(met)
```

## Step 3 Take a look at the variables

``` {r}
str(met)
```

\##Step 4 Closer look at key variables

``` {r}
table(met$year)
```

``` {r}
table(met$day)
```

``` {r}
table(met$hour)
```

``` {r}
summary(met$temp)
```

``` {r}
summary(met$elev)
```

``` {r}
summary(met$wind.sp)
```

# Replace missing values with “NA”

``` {r}
met[met$elev==9999.0] <- NA
summary(met$elev)
```

# Remove likely error minimum temperatures

``` {r}
met <- met[temp>-40]
met2 <- met[order(temp)]
head(met2)
```

``` {r}
met <- met[temp>-15]
met2 <- met[order(temp)]
head(met2)
```

The weather station with the highest elevation is at
`r max(met$elev, na.rm=TRUE)` meters

\#Setp 6 Calculate Summary statistics

``` {r}
elev <- met[elev==max(elev)]
summary(elev)
```

\#Correlations

``` {r}
cor(elev$temp, elev$wind.sp, use="complete")
```

``` {r}
cor(elev$temp, elev$hour, use="complete")
```

``` {r}
cor(elev$wind.sp, elev$day, use="complete")
```

``` {r}
cor(elev$wind.sp, elev$hour, use="complete")
```

``` {r}
cor(elev$temp, elev$day, use="complete")
```

\#Step 7 Exploratory Graphs

``` {r}
hist(met$elev, breaks=100)
```

``` {r}
hist(met$temp)
hist(met$wind.sp)
```

``` {r}
library(leaflet)
```

``` {r}
elev<-met[elev==max(elev)]
```

``` {r}
leaflet(elev) %>%
  addProviderTiles('OpenStreetMap') %>% 
  addCircles(lat=~lat,lng=~lon, opacity=1, fillOpacity=1, radius=100)
```

``` {r}
library(lubridate)
elev$date <- with(elev, ymd_h(paste(year, month, day, hour, sep= ' ')))
summary(elev$date)

elev <- elev[order(date)]
head(elev)

plot(elev$date, elev$temp, type='l')
plot(elev$date, elev$wind.sp, type='l')
```

This is an R Markdown document. Markdown is a simple formatting syntax
for authoring HTML, PDF, and MS Word documents. For more details on
using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that
includes both content as well as the output of any embedded R code
chunks within the document. You can embed an R code chunk like this:

`{r cars} summary(cars)`

## Including Plots

You can also embed plots, for example:

`{r pressure, echo=FALSE} plot(pressure)`

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
