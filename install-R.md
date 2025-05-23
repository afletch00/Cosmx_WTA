# Install R, RStudio, and the Seurat R package

### IMPORTANT: This may take over an hour. You MUST do this before the workshop

Send email to af206@duke.edu if you have problems.

Please let me know if you find errors in these instructions.

#### 1 If not already installed, install R from https://cloud.r-project.org/

Select Download R for macOS or Windows (or Linux) depending on your computer's operating system.

#### 2 If not already installed, install RStudio from https://posit.co/download/rstudio-desktop/

Select choice "2: Install RStudio", assuming you already have R installed.

#### 3 In RStudio, in the console window, copy and paste the following R commands:

```r
install.packages(c("tidyverse", "Seurat", "future", "BiocManager", "patchwork", "openxlsx"), 
repos='https://cran.rstudio.com/')
```
```r
BiocManager::install(c("EnhancedVolcano"))
```
