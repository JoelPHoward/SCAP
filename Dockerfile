# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny-verse:4.1.0

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libtiff-dev \
    libjpeg-dev \
    libudunits2-dev \
    libgdal-dev \
    gcc \
    llvm \
    git \
    tcl8.6-dev \ 
    tk8.6-dev \
    python-dev \
    python3 \
    python3-dev\
    python3-dbg \
    python3-pip \
    python3-venv \
    python3-wheel \
    python3-setuptools \
    python3-llvmlite

RUN chmod a+rX -R /root/
    
# clone SCAP repo
COPY . ./SCAP

WORKDIR "/SCAP"

RUN python3 -m venv ./renv/python/virtualenvs/renv-python-3.8.5 && \
    ./renv/python/virtualenvs/renv-python-3.8.5/bin/pip3 install --upgrade pip && \
    ./renv/python/virtualenvs/renv-python-3.8.5/bin/pip3 install wheel setuptools && \
    ./renv/python/virtualenvs/renv-python-3.8.5/bin/pip3 install -r requirements.txt 

RUN R -e 'renv::use_python(python = "./renv/python/virtualenvs/renv-python-3.8.5/bin/python3")' && \
    R -e 'renv::restore()'

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/SCAP/R', host = '0.0.0.0', port = 3838)"]
