rm(list=ls())

## prepare data
## shape file: https://www.vworld.kr/dtmk/dtmk_ntads_s002.do?dsId=30604
## birth rate: kosis<시군구/합계출산율, 모의 연령별 출산율

## Set working directory (in my Github repository)
setwd("/Users/sunyoungpyo/sunyoung")
getwd()

## Load the birth rate data
library(readxl)
national_birth <- read_excel("national_birth_rate_2022.xlsx", 
                             col_types = c("text", "numeric", "text"))

## clean data
library(stringr)

# remove white spaces
national_birth$시군구별 <- str_trim(national_birth$시군구별, "left")

# identify row numbers for each new 광역시
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


# starting row number of a given municipality - starting row number of a next municipality s is the number of observations for each 광역시
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
