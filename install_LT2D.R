pkgs <- c("devtools", "foreach","doParallel","mvtnorm", "goftest")
options(warn = -1)
for (i in pkgs){
  if (!require(i, quietly = TRUE, character.only = TRUE)){
    install.packages(i)
  }
}
devtools::install_github("calliste-fagard-jenkin/LT2D-work/LT2D",build = TRUE)

