FROM jupyter/datascience-notebook:r-3.6.3
MAINTAINER Edwin Juarez <ejuarez@ucsd.edu>

ENV LANG=C LC_ALL=C
USER root

# I preffer to have all the code here rather than in an Rscript file:
# Remember that you don't need the ; after the if statement.
RUN Rscript -e 'library("devtools");\
install.packages("getopt", repos = "https://cloud.r-project.org/");\
install.packages("optparse", repos = "https://cloud.r-project.org/");\
install_version("foreign", version = "0.8-76", repos = "https://cloud.r-project.org/");\
install.packages("Hmisc", repos = "https://cloud.r-project.org/");\
if (!requireNamespace("BiocManager", quietly = TRUE))\
    install.packages("BiocManager", repos = "https://cloud.r-project.org/");\
BiocManager::install("DESeq2");\
library("getopt");\
library("optparse");\
library("DESeq2");\
sessionInfo()'

# build using this:
# docker build -t genepattern/deseq2:1.0 .
