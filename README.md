# Fisher-Colocalisation-Pipeline
The page outlines a pipeline to run object-based colocalisation using ImageJ/Fiji macros, and an example template to run data analysis in R.

This pipeline is used quantify cell density, cell volume, and signal coverage using object-based colocalisation.

This pipeline utilises the same workflow described in the semi-automated brain slice cell segmentation (LINK) to segment cells and produce a table describing volumes of segmented objects (or cells) for a given label, and an ImageJ/Fiji macro which uses the AND Boolean operator to quantify segmented objects which are colocalised. 

Custom-made R scripts were designed to quantify the cell density, cell volume, and signal coverage for given cell signals and colocalised cell signals.

## Working Practice 
When I put this together I had a lot of images, generally multiple images per animal, so I recommended organising your directories as below. This directory organisation works optimally for the pipeline but please feel free to change to what suits your needs and experiment. 

EXAMPLE: Animal_1 had 2 images of the CA1 and Animal_2 had 1 image, their directory organisation would be:
```
 CA1
  |___Animal_1
              |___ImgA
                      |___img.tif (multichannel image)
              |___ImgB
                      |___img.tif (multichannel image)
  |___Animal_2
              |__img.tif (multichannel image)
```              
**NOTE: within each subdirectory in Animal_1 and Animal_2 (even if there is no subdirectory) all the multichannel images are named the same - this allows the experimenter to run scripts recursively without having to worry about unique filenames.**

## Run the pipeline in the following order:
  1.  In imageJ/Fiji, run the following macros:
      - split_colours.ijm - this seperates your multichannel image into individual channels
      - signal_processing.ijm - this processes your individuals channels
      - coloc_processing.ijm - this run object-based colocalisation on 2 single channel segmented binary images
      - export_pixels.ijm - this exports all non-zero pixels from a single channel image 
         - this is used to quantify your ROI volume
  2. In R, run the following scripts:
      - load_dataframes.R - this will combine all the tables produced from 1. to make a "merged_df.csv" so its format ready for data analysis
          - note: this only runs for one multichannel image, see below to run it recursively
      - load_dataframes_recursive.R - this will run load_dataframes.R recursively and uniquely name each "merged_df.csv"
      -analysis_script.R - an example for how to wrangle the data together to generate a final dataframe ready for statistical analysis 
      
