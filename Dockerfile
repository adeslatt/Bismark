# Dockerfile for Bismark
#
# https://github.com/FelixKrueger/Bismark

FROM python:3

MAINTAINER Anne Deslattes Mays, PhD adeslat@scitechcon.org

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

#########################
### install miniconda ###
#########################

ENV MINICONDA_VERSION py37_4.9.2
ENV CONDA_DIR /miniconda3

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O ~/miniconda.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

# make non-activate conda commands available
ENV PATH=$CONDA_DIR/bin:$PATH

# make conda activate command available from /bin/bash --login shells
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile

# make conda activate command available from /bin/bash --interative shells
RUN conda init bash

########################################
### build conda environment: Bismark ###
########################################

# conda install bismark
ENV APPNAME BISMARK
ENV APPS_HOME /apps
RUN mkdir $APPS_HOME
WORKDIR $APPS_HOME
RUN git clone https://github.com/FelixKrueger/Bismark.git
WORKDIR $APPS_HOME/$APPNAME

# Build BISMARK conda environment
ENV ENV_PREFIX /env/$APPNAME
RUN conda update --name base --channel defaults conda --yes && \
    conda update --name base --channel bioconda conda --yes && \
    conda install --channel bioconda bismark --yes && \
    conda clean --all --yes
