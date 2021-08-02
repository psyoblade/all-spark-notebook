ARG BASE_CONTAINER=psyoblade/data-engineer-pyspark-notebook:1.0
FROM $BASE_CONTAINER

LABEL maintainer="Suhyuk Park <park.suhyuk@gmail.com>"

USER root

# RSpark config
ENV R_LIBS_USER "${SPARK_HOME}/R/lib"
RUN fix-permissions "${R_LIBS_USER}"

# R pre-requisites
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add essential packages
RUN apt-get update && apt-get install -y build-essential curl git gnupg2 nano apt-transport-https software-properties-common

USER $NB_UID

# R packages including IRKernel which gets installed globally.
RUN mamba install --quiet --yes \
    'r-base=4.1.0' \
    'r-ggplot2=3.3*' \
    'r-irkernel=1.2*' \
    'r-rcurl=1.98*' \
    'r-sparklyr=1.7*' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/release/incubator/toree/0.4.0-incubating/toree-pip/toree-0.4.0.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spylon-kernel
RUN mamba install --quiet --yes 'spylon-kernel=0.4*' && \
    mamba clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf "/home/${NB_USER}/.local" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install Python requirements
COPY pip/requirements.txt /home/jovyan/
RUN pip install -r /home/jovyan/requirements.txt

# Custom styling
RUN mkdir -p /home/jovyan/.jupyter/custom
COPY custom/custom.css /home/jovyan/.jupyter/custom/

# NB extensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user

# Add AWS S3 FileSystem
COPY hadoop/hdfs-site.xml /usr/local/spark/conf
COPY jupyter/jupyter_notebook_config.py /home/jovyan/.jupyter/

# Run the notebook
CMD ["/opt/conda/bin/jupyter", "lab", "--allow-root"]
