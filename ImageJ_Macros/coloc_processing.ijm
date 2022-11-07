// Author: Phillip Muza
// Date: 07.11.22

//This macro will open two single channel images in your directory and run colocalisation analysis 
	//producing a table describing the volume and coordinates of each colocalised object (or cell) 

//In this example it will find segmented objects in images named "gfap_mask.tif" and "s100b_mask.tif" and
	//using the Boolean operater AND to find where the objects in the two images exist in the same space and
		//create a new object where the 2 signal overlap
			//NOTE: this new object is an overlap of the 2 signal - BE CAREFUL HOW YOU INTERPRET DATA FROM THESE IMAGES
				//it is highly recommend only using total number data and not any volume data from these objects 

   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");

//This funcion lists the directories it will process
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }
  
//This function will list the files in the current directory and run process Coloc function
   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processColoc(path);
          }
      }
  }
   
//This function will find "gfap_mask.tif" and "s100b_mask.tif" images and run colocalisation analysis on it
		//NOTE TO SELF: currently this function will run multiple times depending on the number of files in the directory
			//Correct so it only runs once after it finds "gfap_mask.tif" and "s100b_mask.tif" - this is very time-consuming otherwise    
function processColoc(path) {
  	
  	for(i=0; i<list.length; i++) {
  		if(matches(list[i], "gfap_mask.tif") || matches(list[i], "s100b_mask.tif")) {
  			open(dir+list[i]);
  		}
  	}
  	imageCalculator("AND create stack", "s100b_mask.tif","gfap_mask.tif");
	selectWindow("Result of s100b_mask.tif");
	saveAs("Tiff", dir + "coloc_mask");
	run("Particle Analyser", "  min=10 max=1750 surface_resampling=2 show_particle surface=Gradient split=0.000 volume_resampling=2");
  	selectWindow("coloc_mask_parts");
	saveAs("Tiff", dir + "coloc_parts");
	selectWindow("Results");
	saveAs("Results", dir + "coloc_objects.csv");
close("*");
}

