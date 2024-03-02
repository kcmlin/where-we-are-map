#######################################
# Practice mapping using "maps" and "mapdata" packages
#
# Katherine Schaughency
# Created: 2 Mar 2024
# Updated: 2 Mar 2024
#######################################

# --------------------------------- #
# load packages

# for coding style and graphing
library(tidyverse)
library(ggplot2)

# for using lat/lon data in us maps
library(maps)
library(mapdata)

# for geocoding addresses
library(tidygeocoder)
library(dplyr)

# for labeling the map
library(ggrepel)

# --------------------------------- #
# Create a shell for us map (practice)

# get to know the function
?map_data

# use usa data
usa <- map_data("usa")

# understand usa data
head(usa)                        #preview 6 lines
str(usa)                         #see data structure
levels(as.factor(usa$group))     #see group category
levels(as.factor(usa$region))    #see region category
levels(as.factor(usa$subregion)) #see subregion category

# plot map shell

ggplot(data=usa, aes(x=long, y=lat, group=group)) + # set parameters
  geom_polygon(fill='lightblue') +                  # plot base map and fill color
  theme_bw()+                                       # black and white theme
  ggtitle('U.S. Map') +                             # add title
  coord_fixed(1.3)                                  # fixed the x:y map ratio to match us map


# --------------------------------- #
# Geocode addresses

# Read in name and addresses 
# Note: We can enter full addresses for geocoding. I use city, state, and zipcode as a demo.
sample_addresses <- tibble::tribble(~name,         ~addr,
                                    "AP",          "Social Circle, GA 30025",
                                    "BO",          "Alexandria, VA 22309",
                                    "CN",          "Bel Air, MD 21014",
                                    "DM",          "Nottingham, MD 21236",
                                    "EL",          "Westminster, MD 21158",
                                    "FK",          "Charlotte, NC 28273",
                                    "GJ",          "Fernley, NV 89408",
                                    "HI",          "Bel Air, MD 21015",
                                    "IH",          "Milford, OH 45150",
                                    "JG",          "Bel Air, MD 21014",
                                    "KF",          "Detroit, MI 48204",
                                    "LE",          "Wilmington, NC 28401",
                                    "MD",          "Atlanta, GA 30318",
                                    "NC",          "Houston, TX 77008",
                                    "OB",          "Chapel Hill, NC 27517",
                                    "PA",          "Powder Springs, GA 30127"
)

# geocode addresses
lat_long <- sample_addresses %>%
                geocode(addr, method = "osm", lat = latitude , long = longitude)


# --------------------------------- #
# Map geocoded addresses

ggplot()+
  
  ### create base map
  geom_polygon(data=usa,                          # read in us map
               aes(x=long, y=lat, group=group),   # set parameters
               fill="lightblue") +                # set us map color
#  borders("state", colour = "purple") +          # set state border color
  theme_bw() +                                    # black and white theme for the map border
  ggtitle("Where we are") +                       # add title
  coord_fixed(1.3) +                              # fixed the x:y map ratio to match us map
  xlab("Longitude") +
  ylab("Latitude") +

  ### add geocoded addresses as points
  geom_point(data=lat_long,                       # read in geocoded addresses
             aes(x=longitude, y=latitude),        # set parameters
             color="purple",                      # circle line color
             fill="lightgrey",                    # circle fill color 
             pch=21,                              # circle style
             size=5,                              # circle size
             alpha=I(0.7)) +                      # circle transparency 
  
  ### add labels next to points
  geom_text_repel(data=lat_long,                               # read in geocoded addresses
                  aes(x=longitude, y=latitude, label = name),  # set parameters
                  color="purple",                              # set text color
                  max.overlaps = 20)                           # show text with closely located points
