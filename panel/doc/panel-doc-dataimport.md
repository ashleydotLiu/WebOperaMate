# Data Import instructions

This panel intended to import and visualize the raw data. Example setting screenshots are available at [http](http://shiny.rstudio.com/articles/css.html).

## Structure
### Analyze item
After all data uploaded in the previous step, the measured parameters are listed in "Analyze item" pull-down list. Select the item you are interested in, e.g. "Average.Intensity.of.Nuclei".
### Wells to use
Select or input the positive/negative control well ID. Wells excluded from the analysis are selected under "Wells not considered in the analysis". It accepts regular expression like *03 (which means the column 03, that is A03, B03 ...). Press enter on the keyboard after one regular expression. Leave them as blank if not available.
### Cell number loading
Cell number is one criteria in quality control, as low cell number often yields untrustworthing results. Please select the item representing the cell number, e.g. "Cells.Analyzed".

## To run
Click the button "Import Data". Data can be downloaded by clicking "Download" at the bottom. You can visualize the data or move to the next step afterward.

## View data
After data are imported, a heatmap should appear on the Heatmap panel, along with a slidebar and pull-down list on the sidebar. Select the plate ID for visualization. Note that slidebar only plays function when the pull-down list is left blank.

The visualization includes heatmap and boxplot method. In the heatmap panel, the rows are the well ID and columns are the plate ID. A large region of distinguishing color (red: large values, blue: small values) in heatmap indicates an abnormal pattern usually due to batch effects or edge effects. In the boxplot panel, the first row shows data organized by plates, while the second row shows data organized by wells. The data distribution due to different plates or different well positions are visualized.

You can also examine data in one plate by selecting only one plate ID.


## Further information
This panel provides an interface to R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html)'s cellLoad function.
