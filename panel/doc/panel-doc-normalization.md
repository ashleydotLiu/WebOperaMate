# Normalization instructions

This panel intended to normalize data. Example setting screenshots are available at [http](http://shiny.rstudio.com/articles/css.html).

## Structure
### Select normalization method
Please select one normalization method from the pull-down list. The supplied method including:

- **MP** : median polish method. It performs median polish to data matrix. The median of data from each plate and the median of data at each well position are both 1 after normalization.
- **PMed** : plate median method. It divides data by the median of its plate. The median of data from each plate are 1 after normalization.
- **Z** : z-score method. It subtracts data by the plate median and then divides by the plate standard deviation.
- **Ctr** : negative control method. It divides data by the mean of the negative control of its plate. It is often not as accurate as others as to large sample screening.
- **None** : no normalization will perform.

## To run
The running process begins once you have selected the normalization method. Data can be downloaded by clicking "Download" at the bottom. You can visualize the data or move to the next step afterward.

## View data
The visualization is the same as that of the previous step. You can compare the distribution of the data before and after normalization.

## Further information
This panel provides an interface to R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html)'s cellNorm function.
