

## Project Overview

Winter places significant pressure on primary and secondary care in the UK. ​General practice characteristics vary across practices and may impact hospital admissions​. This is particularly important for ACSCs (Ambulatory Care Sensitive Conditions e.g. Diabetes, Asthma etc) as the need for secondary care use can be prevented for these conditions by effective primary care​. Understanding the impact of general practice characteristics is important for improving resource allocation and planning​.

**Study protocol**: Zou M, Dawadi S, Pettigrew LM, et al. The relationship between general practice characteristics, case-mix, and secondary care attendances/admissions before and after the COVID-19 pandemic: Protocol for an OpenSAFELY cohort study. Wellcome Open Research 2025, 10:396. [doi.org/10.12688/wellcomeopenres.24356.1](https://doi.org/10.12688/wellcomeopenres.24356.1)

**Study leads**: Zoe Mengxuan Zou, Rachel Denholm; University of Bristol 

**Contributors**: Shrinkhala Dawadi, Ruth E Costello, Luisa M Pettigrew, Rosalind M Eggo, Emily Herrett, Venexia Walker, Marwa Al Arab, Michael Marks, Jonathan Sterne, Alex Walker, Jaidip Gill, John Macleod, Johnny Filipe, Heather Mah, Sebastian Bacon, Matt Curtis, Amir Mehrkar, Laurie Tomlinson, Ben Goldacre, Rohini Mathur, Edwin van Leeuwen 

**Dashboard author**: Nagat Guled 
**Dashboard reviewers**: Zoe Mengxuan Zou, Marwa Al Arab 

OpenSAFELY is a secure, open-source software platform that supports the reproducibility of electronic health record (EHR) research. The OpenSAFELY-TPP dataset was used to access linked EHR data, covering approximately 2,600 general practices (about 40% of all practices in England) and 26 million registered patients in England. 

The purpose of the dashboard is to communicate the results of this study to clinicians and other stakeholders. The results form a large dataset containing eight outcomes, 31 practice-level chanracteristics and multiple model types. Therefore, an interactive dashboard is essential in allowing users to visualise the findings that are useful to them and easily interpret figures.

## Dashboard code structure

![Code diagram](images/code_diagram.png)

## How to use the code

To get started with Shiny the ![Mastering Shiny](https://mastering-shiny.org/) book and the ![Shiny for R Gallery](https://shiny.posit.co/r/gallery/) are great resources.

**global.R**: This is the main file of the code and should be kept short. Use this file to load in your dataset and initilise any variables. Replace labels.R with the variables in your own dataset mapped to your desired label names for the plots.

**ui.R**: This file defines the layout of the app. Load your own stylesheet, and replace the title of the app and tab names. 

**maketab_module.R**: This file is a function called in ui.R. Change the widths of page elements as desired. 

**filters_module.R**: This is called in maketab_module.R. It renders the filter panel on each page. Replace input titles and use your lists in labels.R as choices.

**makefooter_module.R**: This file is called in ui.R and renders a footer with text and a scrolling logos animation. Change acknowledgement text to describe your own project. Create a **logo.R** file with a list of your own logos and reuse **makelogos_module.R** to render them.

**server.R**: This is the third of the three main files. In general, this file processes input from ui.R and generates output. In the case of this dashboard it uses the patchwork library to define the plot layout.

**makeplot_module.R**: This file contains the data parsing and visualising logic. Replace the column names in this dataset with the column names in your own. Replace the interpretation sentences with ones that apply to your figures. This script adds an "exposure type" column to the dataset. Replace the variables (Practice characteristics and Patient case-mix) to render a graph with dynamic facets.

**makeylabels_module.R**: This is called in makeplot_module.R and makes the heading y axis labels bold. Replace the vectors as required.



