# Introduction
WebOperaMate is a shiny-based web application for analyzing protein abundance and localization changes based on genome-wide screening by [PerkinElmer's Opera High Content Screening System](http://www.perkinelmer.com/pages/020/cellularimaging/products/opera.xhtml).
 The Opera system advances the state-of-the-art confocal microplate imaging solution by its higher data quality, ultra higher speed and high throughput ability. Its compatible tool [Columbus Image Data Storage and Analysis System](http://www.perkinelmer.com/pages/020/cellularimaging/products/columbus.xhtml) interpretes the Opera images to protein intensity data, but lacks further processing and analysis tool to uncover the  underlying biological meaning.
Previous work has deposited an R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html) in Bioconductor to process and analyze the protein intensity data. The WebOperaMate further achieves the online analysis, which runs on any modern web browser and requires no programming. Hence, it decreases the accessing requirement, and is more user friendly to biologists.

## Application
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

# Example Data
An example dataset is available at [http](https://github.com/ashleydotLiu/WebOperaMate/test.zip). You need to uncompress the zipball first.
* **Automatic analysis** : choose data in Programming mode. Upload Matrix.zip, genomap.csv and demoParam.txt to "Upload compressed file", "Upload well-gene specification file", "Upload configuration file" blocks, and press "Start analyzing" to process.
* **Step by step ** : choose data in interactive mode. Example images are provided in this step.

### Simple Try: only use the "Automatic Analysis" function on the sidebar. Download example data, uncompress it, and choose data in the programming mode folder.

# Documentaion and source code
For more information, refer to README file on the [Github page](https://github.com/ashleydotLiu/WebOperaMate/).

# Further Reading
For better understanding of the application, refer to Bioconductor package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html) for the R tool description.
