FROM rocker/rstudio

RUN apt update && apt install -y \
    openssh-client libxt-dev\
    # Python
    python3 python3-pip

# R Packages
RUN R -e "install.packages(c('languageserver', 'renv'))"

# Rstudio Global Options
COPY --chown=rstudio:rstudio .config/rstudio/rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json

# DVC Path
ENV PATH $PATH:~/.pip/bin