# Libraries -----
library(Seurat)
library(tidyverse)
#BiocManager::install("glmGamPoi")
library(glmGamPoi)
library(ggplot2)
library(future)
library(EnhancedVolcano)
options(future.globals.maxSize = 8000 * 1024^2)

# reduction and cluster function
sct_so <- function(seuobj){
  
  seuobj <- SCTransform(seuobj, verbose = TRUE, clip.range = c(-10, 10),
                        assay = "RNA")
  #seuobj <- DefaultAssay(seuobj) <- "SCT"
  seuobj <- RunPCA(seuobj, verbose = FALSE)
  seuobj <- RunUMAP(seuobj, dims = 1:30, verbose = FALSE)
  #seuobj <- RunTSNE(seuobj, dims = 1:30, verbose = TRUE)
  seuobj <- FindNeighbors(seuobj, dims = 1:30, verbose = FALSE)
  seuobj <- FindClusters(seuobj, resolution = 0.7, algorithm = 4)
  
  return(seuobj)
  
}

# Colors
colors_22 <- c("skyblue2", "orangered3", "cyan3",  "#D78513FF","pink3", 
               "#1F77B4FF","magenta2", "green4", "mediumpurple4","navy",
               "tomato1", "azure3","slateblue1", "rosybrown1","#A47B51FF",
               "cadetblue", "#B04B7BFF", "#6B722AFF", "grey57", "royalblue1", 
               "darkorange3", "#C8BD8FFF")

Seurat::ImageDimPlot(object = so_panc, boundaries = "segmentation", molecules = c("COL1A1", "INS", "GCG"))

# add cell typing results from InSituType
so_panc@meta.data$types <- cell_meta[rownames(so_panc@meta.data), "cell_types"]
so_panc@meta.data$types[is.na(so_panc@meta.data$types)] <- "QC_dropped"

# zoom to single FOV
fox <- apply(so_panc@images$Pancreas$centroids@coords[so_panc@meta.data$fov %in% 52, ], 2, range)
zoom.crop <- Crop(so_panc[["Pancreas"]], x = fox[,"y"], y = fox[,"x"])
so_panc[["zoom1"]] <- zoom.crop
DefaultBoundary(so_panc[["zoom1"]]) <- "segmentation"

# zoom to 4 FOVs
fox4 <- apply(so_panc@images$Pancreas$centroids@coords[so_panc@meta.data$fov %in% c(51:54), ], 2, range)
zoom.crop4 <- Crop(so_panc[["Pancreas"]], x = fox4[,"y"], y = fox4[,"x"])
so_panc[["zoom4"]] <- zoom.crop4
DefaultBoundary(so_panc[["zoom4"]]) <- "segmentation"

# Visualize
ImageDimPlot(object = so_panc, fov = "zoom1", group.by = "types", axes = TRUE, cols = "glasbey")

ImageDimPlot(object = so_panc, fov = "zoom4", group.by = "types",
             cols = colors_35)

ImageDimPlot(so_panc, fov = "zoom1", cols = "polychrome", alpha = 0.3, 
             molecules = c("KRT19", "VIM", "PRSS1"), mols.size = 0.3, 
             nmols = 20000, border.color = "black", coord.fixed = FALSE)

# Molecules to plot

mols <- c("COL1A1", "MUC1", "GCG", "EPCAM", "PRSS1", "C1QA",
          "ACTA2", "CD3E", "INS", "CD163", "CD86")

ImageDimPlot(object = so_panc, fov = "zoom1", molecules = NULL, 
             cols = colors_22, 
             #mols.cols = colors_35, 
             group.by = "types", #mols.size = 1.5, nmols = 50000,
             mols.alpha = 0.7) # group by "types" for cells


molsD <- c("KRT19", "SOX9", "CFTR", "MUC1")
molsT <- c("CD3E", "CD8A", "CD4", "CD2")
molsMacs <- c("CD68", "CD163", "CD86", "CSF1R", "MARCO")
molsPSC <- c("FAP", "ACTA2", "COL1A1", "PDGFRA")

ImageDimPlot(object = so_panc, fov = "zoom4", molecules = molsPSC, 
             group.by = NA, mols.size = 1.7, nmols = 50000,
             dark.background = TRUE,
             cols = "white",
             border.color = "grey7",
             mols.alpha = 1) # group by "types" for cells

Idents(so_panc) <- "types"

# PLot specific molecules on specific cell types
ImageDimPlot(object = so_panc, fov = "zoom1", molecules = c("ADGRG1", "ADGRG6", "COL3A1"),
             mols.cols = c("orange","blue","","purple"), 
             cells = WhichCells(so_panc, 
                                #idents = c("Ductal")), 
                                idents = c("Acinar.1", "Acinar.2", "Ductal","Macrophage",
                                           "Active stellate", "Quiescent stellate")), 
             #group.by = NA, 
             mols.size = 1, nmols = "inf",
             dark.background = TRUE,
             #cols = colors_20,
             border.color = "grey7",
             na.value = "grey7",
             mols.alpha = 1) # group by "types" for cells

ImageDimPlot(so_panc, fov = "zoom1", cells = WhichCells(so_panc, 
            idents = c("Acinar.1", "Acinar.2", "Ductal","Macrophage")), 
             cols = colors_10, size = 0.6,
            molecules = c("MUC1", "SPINK1", "CD14"),
            alpha = 0.35, mols.size = 0.7, mols.cols = c("blue", "green", "yellow"))



ImageFeaturePlot(so_panc, fov = "zoom1", features = c("MUC5AC","MUC1"), max.cutoff = "q95")


sct_so <- function(seuobj){
  
  seuobj <- SCTransform(seuobj, verbose = TRUE, clip.range = c(-10, 10),
                        assay = "RNA")
  #seuobj <- DefaultAssay(seuobj) <- "SCT"
  seuobj <- RunPCA(seuobj, verbose = FALSE)
  seuobj <- RunUMAP(seuobj, dims = 1:30, verbose = FALSE)
  #seuobj <- RunTSNE(seuobj, dims = 1:30, verbose = TRUE)
  seuobj <- FindNeighbors(seuobj, dims = 1:30, verbose = FALSE)
  seuobj <- FindClusters(seuobj, resolution = 0.7, algorithm = 4)
  
  return(seuobj)
  
}
# We can visualize the Nanostring cells and annotations, projected onto the reference-defined UMAP. 

so_panc_sct <- sct_so(so_panc)

head(slot(object = so_panc_sct, name = "meta.data"))

Idents(so_panc_sct) <- "types"
DimPlot(so_panc_sct) + scale_color_manual(values = colors_22)

# We can also visualize gene expression markers a few different ways:

VlnPlot(so_panc_sct, features = c("VIM", "PRSS1"), assay = "SCT", layer = "counts", 
        pt.size = 0.1) + NoLegend()

FeaturePlot(so_panc_sct, features = c("KRT17", "VIM", "PRSS1"), max.cutoff = "q95")

# What is the difference between Acinar.1 and Acinar.2 cells?
acini_markers <-  FindMarkers(so_panc_sct, ident.1= "Acinar.1", ident.2="Acinar.2",
                              verbose = TRUE, assay = "SCT")

# Look at a volcano plot of the DEGs
fc <- 1
pval <- 0.05

degs <-  acini_markers %>%
  filter(abs(avg_log2FC) > fc) %>% 
  filter(p_val_adj <= pval) 

EnhancedVolcano(acini_markers,
                       lab = rownames(acini_markers),
                       selectLab = rownames(degs),
                       subtitle = bquote(italic("Acinar.2 <---> Acinar.1")),
                       x = 'avg_log2FC',
                       y = 'p_val_adj',
                       legendLabels = c("NS", paste0("Log2FC >", fc),  #expression(Log[2] ~ FC ~ fc),
                                 paste0("Adj. p-val <", pval), 
                                 paste0("Adj. p-val <", pval, " and Log2FC >", fc)),
                       subtitleLabSize = 15,
                       captionLabSize = 15,
                       pCutoff = pval,
                       FCcutoff = fc,
                       pointSize = 2.5,
                       labSize = 4,
                       axisLabSize = 14,
                       legendLabSize = 14, 
                       colAlpha = 0.35)
