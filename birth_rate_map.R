rm(list=ls())

## Prepare data
# 1) birth rate: kosis<시군구/합계출산율, 모의 연령별 출산율
# 2) shape file (option 1): http://www.gisdeveloper.co.kr/?p=2332
# 2) shape file (option 2): https://from-sunnyday.tistory.com/33
# I used the shape file from option 1 (downloaded from the website specifically from the section of "시군구")


## Set working directory
install.packages('rstudioapi')
library(rstudioapi)

curretn_wd<- dirname(rstudioapi::getActiveDocumentContext()$path)
curretn_wd

setwd("/Users/sunyoungpyo/sunyoung")
getwd()

## Load the birth rate data
library(readxl)
national_birth <- read_excel("national_birth_rate_2022.xlsx", 
                             col_types = c("text", "numeric"))

## Add "광역시" for each observation
a<-which(grepl("서울특별시", national_birth$시군구별)) # 1
b<-which(grepl("부산광역시", national_birth$시군구별)) # 27
c<-which(grepl("대구광역시", national_birth$시군구별)) # 44
d<-which(grepl("인천광역시", national_birth$시군구별)) # 53
e<-which(grepl("광주광역시", national_birth$시군구별)) # 65
f<-which(grepl("대전광역시", national_birth$시군구별)) # 71
g<-which(grepl("울산광역시", national_birth$시군구별)) # 77
h<-which(grepl("세종특별자치시", national_birth$시군구별)) # 83
i<-which(grepl("경기도", national_birth$시군구별)) # 85
j<-which(grepl("강원도", national_birth$시군구별)) # 143
k<-which(grepl("충청북도", national_birth$시군구별)) # 162
l<-which(grepl("충청남도", national_birth$시군구별)) # 182
m<-which(grepl("전라북도", national_birth$시군구별)) # 202
n<-which(grepl("전라남도", national_birth$시군구별)) # 219
o<-which(grepl("경상북도", national_birth$시군구별)) # 242
p<-which(grepl("경상남도", national_birth$시군구별)) # 268
q<-which(grepl("제주특별자치도", national_birth$시군구별)) # 297

# [(starting row number of a given municipality) - (starting row number of a next municipality)] is the number of observations for each 광역시
# I can add new variable "광역" and add the 광역시 이름 using below code
national_birth$광역 <- rep(c("서울특별시","부산광역시", "대구광역시", "인천광역시",
                           "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", 
                           "경기도", "강원도", "충청북도", "충청남도", "전라북도", 
                           "전라남도", "경상북도", "경상남도", "제주특별자치도"),
                         c(b-a, c-b, d-c, e-d, f-e, g-f, h-g, i-h, j-i, k-j, l-k, m-l, n-m, o-n, p-o, q-p, 302-q))

national_birth <- national_birth[-which(national_birth$시군구별=="서울특별시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="부산광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="대구광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="인천광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="광주광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="대전광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="울산광역시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="세종특별자치시"),]
national_birth <- national_birth[-which(national_birth$시군구별=="경기도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="강원도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="충청북도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="충청남도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="전라북도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="전라남도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="경상북도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="경상남도"),]
national_birth <- national_birth[-which(national_birth$시군구별=="제주특별자치도"),]

## Clean the birth rate data
library(stringr)

## Remove white spaces
national_birth$시군구별 <- str_trim(national_birth$시군구별, "left")

## Import shape data: use st_read()
library(sf)
grid<-st_read("./sig_20230729/sig.shp", options="ENCODING=EUC-KR")
names(grid)

plot(grid[SIG_CD]) # DO NOT RUN AS IT TAKES TOO LONG TIME

## To pull out the district code data from grid data, I transformed the grid (sf) data into data frame format
district_code <- data.frame(grid)
names(district_code)

library(dplyr)
district_code <- district_code %>% select(SIG_CD, SIG_ENG_NM, SIG_KOR_NM)

district_code <- district_code %>% 
  mutate(광역 = case_when(str_starts(SIG_CD, "1") ~ '서울특별시',
                        str_starts(SIG_CD, "26") ~ '부산광역시',
                        str_starts(SIG_CD, "27") ~ '대구광역시',
                        str_starts(SIG_CD, "28") ~ '인천광역시',
                        str_starts(SIG_CD, "30") ~ '대전광역시',
                        str_starts(SIG_CD, "31") ~ '울산광역시',
                        str_starts(SIG_CD, "29") ~ '광주광역시',
                        str_starts(SIG_CD, "36") ~ '세종시',
                        str_starts(SIG_CD, "41") ~ '경기도',
                        str_starts(SIG_CD, "43") ~ '충청북도',
                        str_starts(SIG_CD, "44") ~ '충청남도',
                        str_starts(SIG_CD, "45") ~ '전라북도',
                        str_starts(SIG_CD, "46") ~ '전라남도',
                        str_starts(SIG_CD, "47") ~ '경상북도',
                        str_starts(SIG_CD, "48") ~ '경상남도',
                        str_starts(SIG_CD, "50") ~ '제주도',
                        str_starts(SIG_CD, "51") ~ '강원도'))


## Change the variable used for ID names then merging the data
national_birth <- rename(national_birth, SIG_KOR_NM=시군구별)
national_birth <- rename(national_birth, total_birth_rate=합계출산율)
colnames(national_birth)

##############
## National ##
##############

national_birth <- left_join(national_birth, district_code, by=c("SIG_KOR_NM", "광역"))
national_birth <- national_birth %>% select(SIG_CD, total_birth_rate)

grid <- left_join(grid, national_birth, by="SIG_CD")
# There are missing values in grid file because of unmatched observations, which should be revised later
  

###########
## Seoul ##
###########

seoul_code <- district_code %>% 
  dplyr::filter(stringr::str_starts(SIG_CD, "1"))

seoul_birth <- left_join(national_birth, seoul_code, by=c("SIG_KOR_NM", "광역"))
seoul_birth<-seoul_birth[!is.na(seoul_birth$SIG_CD),]

seoul_birth <- seoul_birth %>% select(SIG_CD, total_birth_rate)

grid_seoul <- grid[!is.na(grid$total_birth_rate),]


## Create the choropleth map
## source: Book "공공데이터로 배우는 R데이터 분석 with 샤이니 p. 86"

library(ggplot2)

grid_seoul %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid_seoul , aes(geometry = geometry)) +
  scale_fill_gradient(low="white", high="blue")

## add tooltip on a map
## to show "district name: birth rate", I created the 'text' object as below
install.packages("plotly")

## since above code did not work, I manually downloaded the package from the web into download folder, then load it using below command
install.packages("~/Downloads/plotly_4.10.4.tar.gz", repos = NULL, type = "source")

library(plotly)

grid_seoul$TEXT<-paste0(grid_seoul$SIG_KOR_NM, ": ", grid_seoul$total_birth_rate)

p1<-grid_seoul %>% ggplot(aes(fill=total_birth_rate)) +
  geom_sf(data = grid_seoul , aes(geometry = geometry, text=TEXT)) +
  scale_fill_gradient(low="white", high="blue")

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white"), hoveron = "fills")

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white"))

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white", hoverinfo = "TEXT", hoveron = "fills"))

ggplotly(p1, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white", hoverinfo = "TEXT", hoveron = "points"))

## useful source about labeling in map: https://tmieno2.github.io/R-as-GIS-for-Economists/geom-sf.html


