if(!"devtools" %in% rownames(installed.packages())) {install.packages("devtools")}
devtools::install_github('david-borchers/LT2D')
library(LT2D) 
library(spatstat)
