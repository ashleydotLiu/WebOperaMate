# Hit detection instructions

This panel intended to detect candidate hits. Please note that the data not passing quality control are excluded from the candidate list. Example setting screenshots are available at [http](http://shiny.rstudio.com/articles/css.html).

## Structure
### Select hit detection method
Please select one detection method from the pull-down list. The supplied method including:

- **stable** : it fits the data to a stable distribution, and extremely high/low data (probability less than low threshold or larger than high threshold) are selected as candidate hits. The stable distribution is based on generalized central limit theorem. It is heavy tailed and skewed, which is often the case of the distribution of the protein intensity data. The stable distribition is widely used in commerce, and has demostrated its power in differential expressed gene detection based on microarray data. The goodness of fitting can be visualized by QQ plot in the "QQ Plot (method stable)" panel after finishing hit detection step.
- **ksd** : it defines the candidate hits as data less than mean-low threshold*sd, and larger than mean+high threshold*sd. The underlying hypothesis is that the data obey normal distribution.
- **kmsd** : it defines the candidate hits as data less than median-low threshold*mean absolute deviation, and larger than *median+high threshold*mean absolute deviation. It is often more robust to outliers than ksd method.

### Multiple t-test of case-control
It assesses the differences of data and their negative controls by multiple t-test. P-value adjust method can be selected from the pull-down list for multiple t-test. Candidate hits are the ones less than the "p-value threshold". This rule disables when p-value threshold is set as 1.

### Highlight File
In case you would like to label genes of interest on the volcano plot, you can provide their barcode, wellID, and labels (gene names or whatever you would like to show) as a 3-column table, saving it as comma seperated format (.csv), and uploading it by clicking  the "select file" button in the "highlightFile" block.

## To run
Press the button "Hit Detection". You can visualize the hits ditribution in "Volcano Plot" panel.

## Generate report
Click the button "Download Report". The digits of the thresholds in the report can be specified in the "digits of threshold".

## Further information
This panel provides an interface to R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html)'s cellSig function.


