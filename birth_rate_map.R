rm(list=ls())

## Set working directory
setwd("~/Desktop/project/birth_rate_map")

## Import the data
library(readxl)
birth <- read_xlsx("~/seoul_birth_rate_2022.xlsx")

## Import shape data: use st_read()
## https://www.vworld.kr/dtmk/dtmk_ntads_s002.do?dsId=30604
library(sf)
grid<-st_read("./LARD_ADM_SECT_SGG_서울/LARD_ADM_SECT_SGG_11_202402.shp", options="ENCODING=EUC-KR")
plot(grid[,'ADM_SECT_C'])

## To pull out the district code data from grid data, I exported the grid data into excel file
## From this exported data, I made district_code data
library(writexl)
write_xlsx(grid, path="~/Downloads/grid.xlsx")

### Merge district code data into birth data
district_code <- read_xlsx("~/Desktop/project/district_code.xlsx")

district_code <- district_code %>% mutate(SGG_NM = ifelse(SGG_NM == "서울시도봉구", "도봉구", SGG_NM))
district_code <- district_code %>% mutate(SGG_NM = ifelse(SGG_NM == "서울시노원구", "노원구", SGG_NM))

# change the variable used for ID names (for matching)
library(dplyr)
birth<-rename(birth, SGG_NM=시군구별)
colnames(birth)

birth<-rename(birth, total_birth_rate=합계출산율)

birth <- left_join(birth, district_code, by="SGG_NM")

grid <- left_join(grid, birth, by="ADM_SECT_C")

## Create the choropleth map
## source: Book "공공데이터로 배우는 R데이터 분석 with 샤이니 p. 86"

library(ggplot2)

grid %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid , aes(geometry = geometry)) +
  scale_fill_gradient(low="white", high="blue")

## NOTE: Maybe I get the error message "tat_sf()` requires the following missing aesthetics: geometry"
## This occurs because R does not recognize geometry when it's not in the last column.
## In case this happens, I added geometry = geometry in geon_sf()

## add label: SGG_NM.x (korean)
grid %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid , aes(geometry = geometry)) +
  geom_sf_text(data=grid, aes(label = SGG_NM.x, geometry = geometry), colour = "white") +
  scale_fill_gradient(low="white", high="blue")

## add label: SGG_NM.x 
grid %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid, aes(geometry = geometry)) +
  geom_sf_text(data=grid, aes(label = COL_ADM_SE, geometry = geometry), colour = "white") +
  scale_fill_gradient(low="white", high="blue")

## add tooltip on a map
## to show "district name: birth rate", I created the 'text' object as below
install.packages("plotly")

## since above code did not work, I manually downloaded the package from the web into download folder, then load it using below command
install.packages("~/Downloads/plotly_4.10.4.tar.gz", repos = NULL, type = "source")

library(plotly)


grid$TEXT<-paste0(grid$SGG_NM.y, ": ", grid$total_birth_rate)

p1<-grid %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid , aes(geometry = geometry, text=TEXT)) +
  scale_fill_gradient(low="white", high="blue")

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")

## useful source about labeling in map: https://tmieno2.github.io/R-as-GIS-for-Economists/geom-sf.html

