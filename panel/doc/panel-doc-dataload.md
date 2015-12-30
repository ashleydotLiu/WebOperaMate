# Data Upload instructions

This panel intended to upload files obtained from Columbus system. Example setting screenshots are available at [http](http://shiny.rstudio.com/articles/css.html).

## Structure
### Columbus files uploading
Flat files should be compressed to one zipball (.zip), and are uploaded by clicking the select files button in the "Upload compressed file" block.
### Well-gene specification file uploading
The well-gene specification file should be available during experimental design. It indicates the well position and the gene located. Only comma seperated file (.csv) is supported. Files of other formats can be resaved to .csv by Microsoft Excel or other software. The lines before the column name line (including barcode, well and genesymbol items) should be omitted by select the omitting line number in "Number of lines before column names". The well-gene mapping table is shown in the "Well-Gene Mapping Table" panel.
### Filename parser
If all file names follow the same naming rule, you can provide one example and WebOperaMate will extract information of others accordingly. Suppose the file name is Matrix.130506-s2-02.txt, which is the data from plate 02, replicate s2, and its barcode in the well-gene specification file is DSIMGA02, then the blanks should be filled as follows:
- **An example of data file name** : Matrix.130506-s2-02.txt
- **Seperator** : -
- **Plate ID** : 02
- **Replication ID** : s2
- **Barcode in the specification file** : DSIMGA02

Moreover, select your file format from Matrix and Table, which you specified during the analysis by Columbus system.

The parsed information is reflected in the "Uploaded File" panel. Make sure everything is all right. You can change the content by clicking "Download" button to download the table first, modifying it and uploading it again by clicking the select file button under "Upload customized file information table". Make sure the checkbox "Upload a customized file information table" is in checked status in this case.

## To run
At last, click the button "Start analyzing!" at bottom to upload these data. (Sometimes, you need to click it twice when the  "Well-Gene Mapping Table" panel is active). Then move to the next section "Data import" and wait until the Analyze item selection box appears.

## Further information
This panel provides an interface to R package [OperaMate](https://www.bioconductor.org/packages/release/bioc/html/OperaMate.html)'s loadAll function.
