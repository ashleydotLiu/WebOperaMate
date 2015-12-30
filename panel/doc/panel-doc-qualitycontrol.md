# Quality control instructions

This panel intended to do quality control. Example setting screenshots are available at [http](http://shiny.rstudio.com/articles/css.html).

## Structure
### Select quality control method
Please select all needed quality control methods.

- **plateCorrelation** : it calculates the pearson correlation of replicated plates (three or more replicates are required). Low correlations (threshold is set in the "The minimum correlation between the replicates" once you check it) indicates bad plate which may due to bad plate quality or abnormal environment, etc.. The correlation can be visualized in PlateQC panel after finishing quality control step.
- **wellSd** : it calculates the mean and standard deviation (sd) of replicated wells (three or more replicates are required). Large sds indicates unstable replicates. However, the variation of sds correlates with the mean value, which should be represented by a Gaussian process. Due to the large computational cost by Guassian process, here we simply bin the mean to several ranges, and suppose the sds of each corresponding range are similar. Abnormal sds are the outliers in the boxplot (black dot), and are regarded as bad well replicates. The distribution  can be visualized in WellQC panel after finishing quality control step.
- **zFactor**: it calculates the Z-factors based on positive (pos) and negative (neg) controls (only active when both positive and negative controls are provided in the data import step). Define the means and sds of pos and neg as mu(pos), mu(neg), sigma(pos), sigma(neg), the Z-factor is defined as 1-3*(sigma(pos)+sigma(neg))/abs(mu(pos)-mu(neg)).
- **cellNumber** : it treats data with low cell number (threshold is set in the "The cell number threshold" once you check it) as failing quality control, because low cell number often yields untrustworthing results.

### Replace the bad wells or not
The data in the bad wells can be replaced by their replicates or simply denoted as NA.

## To run
Click the button "Quality Control". Data can be downloaded by clicking "Download" at the bottom. To be downloaded files can be selected in the checkbox.

## Further information
This panel provides an interface to R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html)'s cellQC function.
