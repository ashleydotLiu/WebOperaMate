#########################
##     WebOperaMate    ##
#########################

# Introduction
WebOperaMate is a shiny-based web application for analyzing protein abundance and localization changes based on genome-wide screening by [PerkinElmer's Opera High Content Screening System](http://www.perkinelmer.com/pages/020/cellularimaging/products/opera.xhtml).
 The Opera system advances the state-of-the-art confocal microplate imaging solution by its higher data quality, ultra higher speed and high throughput ability. Its compatible tool [Columbus Image Data Storage and Analysis System](http://www.perkinelmer.com/pages/020/cellularimaging/products/columbus.xhtml) interpretes the Opera images to protein intensity data, but lacks further processing and analysis tool to uncover the  underlying biological meaning.
Previous work has deposited an R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html) in Bioconductor to process and analyze the protein intensity data. The WebOperaMate further achieves the online analysis, which runs on any modern web browser and requires no programming. Hence, it decreases the accessing requirement, and is more user friendly to biologists.

# Online version
The online version is available at [https://github.com/ashleydotLiu/WebOperaMate](https://github.com/ashleydotLiu/WebOperaMate). Refer to Installation for local installing details.

# Tutorial
## Dependencies
The depending packages include shiny, shinydashboard, shinyapps, markdown from CRAN and OperaMate from Bioconductor.
## Get started
Run the code in app.R in an interactive R session.

## Structure 
- *Programming mode(Automatic Analysis)* : run all steps automatically without mannually interact with website server.
- *Interactive mode* : run steps one by one for more customized visualizations and parameters. Execute each step by pressing the corresponding job submitting botton (details are available in each step). Then move to the next step for additional functions.
## Functionality
* **Automatic Analysis**: run all steps automatically.
* **Data Upload** : Upload your reports generated from Columbus system as a compressed .zip file. The supporting format of the reports are Matrix and Table specified in the Columbus system. See the tutorial on data upload page for more details.
* **Data Import** : Data from different plates are merged together, with the rows and columns are the well and plate ID, respectively. The raw data are visualized by heatmap and boxplot.
* **Normalization** : Batch effect are removed by this step.
* **Quality control** : Different quality control methods provided to examine or exclude the abnormal cases.
* **Hit detection** : Detect hit candidates based on the data.
* **Hit function** : Predict the enriched GO categories or pathways based on R package gProfileR.

# Acknowledgements
We thank Li Mao and his advisor Lin Li for providing the original screening data generated by the Columbus system. The
example data in the package are synthesis data generated based on their providing data.


