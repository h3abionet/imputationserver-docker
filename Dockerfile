FROM genepi/cloudgene:v2.3.3

MAINTAINER Sebastian Schoenherr <sebastian.schoenherr@i-med.ac.at>, Lukas Forer <lukas.forer@i-med.ac.at>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Install dependencies for R packages
RUN apt update && \
apt -y install \
libxml2-dev \
libcurl4-openssl-dev && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    echo "conda activate base" >> ~/.bashrc

# Install R Packages
RUN conda update conda && \
    conda clean --all --yes && \
    conda install -y -c r r-rcolorbrewer r-knitr

RUN conda update conda && \
    conda clean --all --yes && \
    conda install -y -c bioconda bioconductor-geneplotter

RUN conda update conda && \
    conda clean --all --yes && \
    conda install -y nextflow

# RUN R -e "install.packages('RColorBrewer', repos = 'http://cran.rstudio.com' )"

# RUN R -e "source('https://bioconductor.org/biocLite.R' )" -e 'biocLite("geneplotter")'

# Add imputationserver specific pages
ADD pages /opt/cloudgene/sample/pages

# Add apps.yaml file with imputationserver and hapmap2
ADD apps.yaml /opt/cloudgene/apps.yaml

# Imputation Server Branding
ENV CLOUDGENE_SERVICE_NAME="H3Africa Imputation Server"
ENV CLOUDGENE_HELP_PAGE="http://imputationserver.readthedocs.io"
ENV CLOUDGENE_REPOSITORY="/opt/cloudgene/apps.yaml"

# run startup script to start Hadoop and Cloudgene
CMD ["/usr/bin/startup"]
