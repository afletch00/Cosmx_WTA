FROM rocker/rstudio:4.3.1

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libhdf5-dev \
    libgsl-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libglpk-dev \
    build-essential \
    libreadline-dev \
    gfortran \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install CRAN packages first
RUN R -e "install.packages(c('tidyverse', 'future', 'remotes'), repos='https://cloud.r-project.org')"

# Install BiocManager separately first
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"

# THEN install Bioconductor packages
#RUN R -e "BiocManager::install('SingleCellExperiment', ask = FALSE)"
#RUN R -e "BiocManager::install('glmGamPoi', ask = FALSE)"
#RUN R -e "BiocManager::install('EnhancedVolcano', ask = FALSE)"

# Optionally install Seurat last (avoids dependency conflicts)
RUN R -e "install.packages('Seurat', repos='https://cloud.r-project.org')"