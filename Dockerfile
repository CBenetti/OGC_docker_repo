FROM debian:bookworm

# Install basic functionalities
RUN apt update  &&  apt install -y aptitude && apt-get install -y --fix-missing vim nano openssl sudo r-base build-essential git ca-certificates fontconfig gcc gettext hicolor-icon-theme libharfbuzz-dev libfribidi-dev htop python3 lz4 pandoc pkg-config wget zstd libcurl4-openssl-dev libxml2-dev libssl-dev zlib1g-dev libbz2-dev libsqlite3-dev libreadline-dev libffi-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev python3 python3-pip libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libgit2-dev libnlopt-dev cmake libcairo2-dev libhdf5-dev libgmp-dev libgmp3-dev libgmpxx4ldbl libpoppler-cpp-dev libfftw3-bin libfftw3-dev libfftw3-double3 libfftw3-long3 libfftw3-single3 libmagick++-dev libv8-dev

# Install JAVA
RUN sudo apt install -y default-jdk

RUN java --version
# Fix certificate issues
RUN apt-get update && \
    apt-get install -y ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-arm64"
ENV PATH="$PATH:/usr/lib/jvm/java-17-openjdk-arm64/bin"
RUN sudo R CMD javareconf
#RUN echo "export PATH='$PATH:/usr/lib/jvm/java-17-openjdk-arm64/bin' >> ~/.bashrc
#RUN echo "export JAVA_HOME='/usr/lib/jvm/java-17-openjdk-arm64' >> ~/.bashrc

# Install httpgd and dependent packages.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libfontconfig1-dev \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && R -e "install.packages('httpgd')"
    
# Install R packages - For a complete list of packages and versioning consult the "installed_packages.txt" file in the "interactive" Dockerfile folder
RUN R -e "install.packages('rstan', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))"
RUN R -e "install.packages(c('BH', 'BiasedUrn', 'BiocManager', 'Cairo', 'CircStats', 'DAAG', 'DBI', 'DDRTree', 'DEoptimR','DGEobj', 'DGEobj.utils', 'DT', 'Deriv', 'FNN', 'Formula', 'GSA', 'GetoptLong', 'GlobalOptions', 'KMsurv', 'KernSmooth','MASS', 'MCMCpack', 'Matrix', 'MatrixModels', 'PMA', 'PreProcessing', 'R6', 'RANN', 'RColorBrewer', 'RCurl', 'ROCR', 'RSNNS','RSQLite', 'RSpectra', 'RUnit', 'Rcpp', 'RcppAnnoy', 'RcppArmadillo', 'RcppEigen', 'RcppHNSW', 'RcppML', 'RcppParallel', 'RcppProgress', 'RcppTOML', 'Rdpack', 'Rtsne', 'SparseM', 'StanHeaders', 'TDA', 'TDApplied', 'TDAstats', 'TFisher', 'TH.data', 'TTR', 'VGAM', 'XML', 'abind', 'antiword', 'ape', 'aplot', 'askpass', 'assertthat', 'backports', 'base64enc', 'bayestestR', 'beeswarm', 'benchmarkme', 'benchmarkmeData', 'bit', 'bit64', 'bitops', 'blob', 'bmp', 'boot', 'brew', 'brio', 'broom','bslib', 'caTools', 'cachem', 'callr', 'car', 'carData', 'cellranger', 'checkmate', 'circlize', 'class', 'cli', 'clipr', 'clue','cluster', 'coda', 'codetools', 'colorspace', 'combinat', 'commonmark', 'conflicted', 'corrplot', 'cowplot', 'cpp11', 'crayon', 'credentials', 'crosstalk', 'curl', 'data.table', 'data.tree', 'datawizard', 'dbplyr', 'deldir', 'desc', 'devtools', 'diffobj', 'digest', 'diptest', 'doParallel', 'doSNOW', 'docopt', 'dotCall64', 'downlit', 'downloader', 'dplyr', 'dqrng', 'dtplyr', 'dtw', 'dygraphs', 'ellipsis', 'evaluate', 'exactRankTests', 'extraDistr', 'fansi', 'farver', 'fastICA', 'fastmap', 'fastmatch', 'fields', 'filelock', 'fitdistrplus', 'flexmix', 'fontawesome', 'forcats', 'foreach', 'forecast', 'foreign', 'formatR', 'fpc', 'fracdiff', 'fs','futile.logger', 'futile.options', 'future', 'future.apply', 'gapminder', 'gargle', 'generics', 'gert', 'ggbeeswarm', 'ggforce', 'ggfun', 'ggnewscale', 'ggplot2', 'ggplotify', 'ggprism', 'ggpubr', 'ggraph', 'ggrastr', 'ggrepel', 'ggridges', 'ggsci', 'ggsignif', 'ggtext', 'gh', 'gitcreds', 'globals', 'glue', 'gmp', 'goftest', 'googledrive', 'googlesheets4', 'gplots', 'graphlayouts', 'gridExtra','gridGraphics', 'gridtext', 'gtable', 'gtools', 'haven', 'hdf5r', 'here', 'highr', 'hms', 'htmlTable', 'htmltools', 'htmlwidgets','httpuv', 'httr', 'httr2', 'ica', 'ids', 'igraph', 'ineq', 'ini', 'inline', 'insight', 'interp', 'irlba', 'irr', 'isoband', 'iterators', 'janitor', 'jpeg', 'jquerylib', 'jsonlite', 'kernlab', 'km.ci', 'knitr', 'ks', 'labeling', 'lambda.r', 'later', 'lattice','latticeExtra', 'lazyeval', 'leiden', 'leidenbase', 'lifecycle', 'listenv', 'lme4', 'lmtest', 'locfit', 'loo', 'lpSolve', 'lubridate','magick', 'magrittr', 'mapplots', 'maps', 'markdown', 'mathjaxr', 'matrixStats', 'maxstat', 'mclust', 'mcmc', 'memoise', 'metap','mgcv', 'mime', 'miniUI', 'minqa', 'misc3d', 'mixtools', 'mltools', 'mnormt', 'modelr', 'modeltools', 'multcomp', 'multicool', 'munsell', 'mutoss', 'mvtnorm', 'ndjson', 'neuralnet', 'nlme', 'nloptr', 'nnet', 'nnls', 'nor1mix', 'numDeriv', 'openssl', 'openxlsx','pROC', 'paletteer', 'parallelly', 'patchwork', 'pbapply', 'pbkrtest', 'pdftools', 'performance', 'pheatmap', 'pillar', 'pkgbuild', 'pkgconfig', 'pkgdown', 'pkgload', 'plogr', 'plot3D', 'plotly', 'plotrix', 'plyr', 'png', 'polyclip', 'polynom', 'prabclus', 'pracma','praise', 'prettyunits', 'prismatic', 'processx', 'profvis', 'progress', 'progressr', 'promises', 'prophet', 'proxy', 'ps', 'psych', 'purrr', 'qlcMatrix', 'qpdf', 'qqconf', 'quadprog', 'quantmod', 'quantreg', 'rJava', 'ragg', 'randomForest', 'rappdirs', 'rbibutils', 'rcmdcheck', 'rdist', 'readODS', 'readbitmap', 'readr', 'readtext', 'readxl', 'rematch', 'rematch2', 'remotes', 'reprex', 'reshape2', 'restfulr', 'reticulate', 'rio', 'rjson', 'rlang', 'rmarkdown', 'robustbase', 'roxygen2', 'rpart', 'rprojroot','rstantools','rstatix', 'rstudioapi', 'rsvd', 'rversions', 'rvest', 'samr', 'sandwich', 'sass', 'scCustomize', 'scales', 'scattermore', 'scatterpie', 'scatterplot3d', 'sctransform', 'segmented', 'selectr', 'sessioninfo', 'shadowtext', 'shape', 'shiny', 'shinyFiles','sitmo', 'slam', 'sm', 'sn', 'snakecase', 'snow', 'sourcetools', 'sp', 'spam', 'sparsesvd', 'spatial', 'spatstat.data', 'spatstat.explore', 'spatstat.geom', 'spatstat.random', 'spatstat.sparse', 'spatstat.utils', 'statmod', 'streamR', 'stringi', 'stringr', 'striprtf', 'survMisc', 'survival', 'survivalROC', 'survminer', 'sys', 'systemfonts', 'tensor', 'testthat', 'textshaping', 'tibble', 'tidygraph', 'tidyr', 'tidyselect', 'tidytree', 'tidyverse', 'tiff', 'timeDate', 'timechange', 'tinytex', 'tseries', 'tsne','tweenr', 'tzdb', 'umap', 'urca', 'urlchecker', 'usethis', 'utf8', 'uuid', 'uwot', 'vctrs', 'verification', 'vioplot', 'vipor', 'viridis', 'viridisLite', 'vroom', 'waldo', 'waterfall', 'whisker', 'withr', 'writexl', 'xfun', 'xlsx', 'xlsxjars', 'xml2', 'xopen','xtable', 'xts', 'yaml', 'yulab.utils', 'zip', 'zoo'),dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ClusterR')"
RUN R -e "BiocManager::install(c('Rhdf5lib', 'SingleCellExperiment', 'beachmat', 'cqn','impute', 'org.Hs.eg.db', 'preprocessCore', 'topconfects', 'AnnotationDbi', 'AnnotationFilter', 'AnnotationHub','Biobase', 'BiocFileCache', 'BiocGenerics', 'BiocIO', 'BiocParallel', 'BiocVersion', 'Biostrings', 'ComplexHeatmap', 'DESeq2', 'DelayedArray', 'GenomeInfoDb', 'GenomeInfoDbData', 'GenomicAlignments', 'GenomicFeatures', 'GenomicRanges', 'IRanges', 'KEGGREST', 'MatrixGenerics', 'ProtGenerics', 'Rhtslib', 'Rsamtools', 'S4Vectors', 'SummarizedExperiment', 'XVector', 'biomaRt', 'edgeR','ensembldb', 'fgsea', 'interactiveDisplayBase', 'limma', 'rtracklayer', 'zlibbioc', 'BiocNeighbors', 'BiocSingular', 'DelayedMatrixStats', 'ExperimentHub', 'GSEABase', 'GSVA', 'HDF5Array', 'HDO.db', 'HSMMSingleCell', 'Mulcom', 'NOISeq', 'RBGL', 'ScaledMatrix', 'SingleR', 'affy', 'affyio', 'annotate', 'biocViews', 'celldex', 'geneplotter', 'ggtree', 'graph', 'graphite','monocle', 'multiGSEA', 'multtest', 'qvalue', 'rhdf5', 'rhdf5filters', 'scater', 'scuttle', 'sparseMatrixStats', 'treeio', 'EnsDb.Hsapiens.v79', 'GOexpress', 'scRNAseq'))" 
RUN R -e "devtools::install_github('GfellerLab/EPIC',build_vignettes=TRUE)"
RUN R -e "devtools::install_github('Lothelab/CMScaller')" 
RUN R -e "devtools::install_github('dviraran/xCell')"
RUN R -e "devtools::install_github('immunogenomics/presto')"
RUN R -e "remotes::install_version('Seurat', version = '4.3.0')"
RUN R -e "remotes::install_github('mojaveazure/seurat-disk')"
RUN R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')"
RUN R -e "devtools::install_github('paultpearson/TDAmapper')"

##After installation, the following packages must be manually installed. They require no dependency but for some reason are incompatible with Dockerfile installation
#R -e "install.packages('FARDEEP')"
#R -e "BiocManager::install(c('samr','GO.db','mbkmeans','goTools','goseq','enrichplot'))"
