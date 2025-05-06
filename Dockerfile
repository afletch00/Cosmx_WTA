FROM rocker/tidyverse

ENV DEBIAN_FRONTEND=noninteractive

# Fix SSL issues and install all system dependencies needed for CRAN + Bioconductor
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libhdf5-dev \
    libgsl-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libglpk-dev \
    libreadline-dev \
    gfortran \
    build-essential \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set a stable CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install CRAN packages
RUN Rscript -e "install.packages(c('Seurat', 'future', 'remotes', 'BiocManager', 'knitr'))"

# Install CRAN dependencies required by Bioc packages
RUN Rscript -e "install.packages(c('matrixStats', 'abind'))"

# Install Bioconductor packages
RUN Rscript -e "BiocManager::install(c('SingleCellExperiment', 'glmGamPoi', 'EnhancedVolcano', 'MatrixGenerics', 'S4Arrays', 'SparseArray'), ask = FALSE)"
