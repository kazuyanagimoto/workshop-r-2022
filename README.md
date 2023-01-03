# My Docker Template for R

## Quick Start
1. Clone this repository
1. Make sure you have `~/.renv`, `~/.TinyTeX`, and `~/.pip` folders in your HOST machine
1. Open it in VSCode and add Remote-Containers Extension
1. From command pallete, choose "open folder in container"
1. Open `localhost:8787` in a browser
1. Create a project for this projet directory (by default, choose `/home/rstudio/work`)
1. RUN `renv::init()` in the R console
1. RUN `pip install -r requirements.txt --user` for DVC install (if you have never used this template)
1. Set up a [DVC](https://dvc.org/) environment
    1. Prepare a folder in Google Drive (and copy the folder code)
    1. Init DVC
        ```{bash}
        dvc init
        dvc remote add --default myremote gdrive://GDRIVE_FOLDER_CODE
        ```



## Data

| Data              | Organization | Links                                                                  |
|-------------------|--------------|------------------------------------------------------------------------|
| oecd/wage_gap.csv | OECD         | [Gender wage gap](https://data.oecd.org/earnwage/gender-wage-gap.htm ) |
| accident_bike/*   | Comunidad de Madrid | [Accidentes de tráfico de la Ciudad de Madrid](https://datos.madrid.es/portal/site/egob/menuitem.c05c1f754a33a9fbe4b2e4b284f1a5a0/?vgnextoid=7c2843010d9c3610VgnVCM2000001f4a900aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD&vgnextfmt=default)                                                                        |
|                   |              |                                                                        |