// Author: Phillip Muza
// Date: 07.11.22

//This macro will open single channel images in your directory and process them to produce tables 
		//describing for each "object" (or cell) the volume and coordinates
//In this macro it will open "gfap.tif" and "s100b.tif" images from the directory
//This macro can run recursively.  

   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   
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

//This function will list the files in the current directory and run the all the following "processXYZ" functions
   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processGFAP(path); //This will get processed in the current directory
             processS100B(path); //This will get processed in the current directory
             //processXYZ(path); //If you want to make a new function to process another multichannel img, add it here and below this function
          }
      }
  }

//The image filtering and object counting workflow is CUSTOM-MADE!!! Feel free to change to whatever is appropriate for your signal and experiment
  function processGFAP(path) {
       if (endsWith(path, "gfap.tif")) {
            open(path);
            name = File.nameWithoutExtension;
//You can modify how you want to process the images from here
//Run Unsharp Masking of the image 
            //First apply a small median (low pass) filter to blur the image
            run("Median 3D...", "x=2 y=2 z=2");
            rename("median");
            run("Duplicate...", "title=gaussian");
    		//Secondly apply big Gaussian Blur (low pass) filter to further blur the image 
            selectWindow("gaussian");
            run("Gaussian Blur 3D...", "x=15 y=15 z=15");
            //Unsharp mask the image by substracting the big Gauss Blur from your small median filtered image
            imageCalculator("Subtract create stack", "median","gaussian");
            rename("sharp");
            close("\\Others");
//Make sure the pixel width, height, and voxel depth (z-step) is correct in the properties 
			selectWindow("sharp");
//This line runs a threshold - QC this stage of the script and change accordingly 
			run("Auto Threshold", "method=Triangle ignore_black ignore_white white stack");
			saveAs("Tiff", dir + "gfap_mask");
//This runs the BoneJ particle analyzers - change min & max of the size of objects you want to analyse
	//Here parameters are set for mouse GFAP+ cell bodies -/+ 5%
			run("Particle Analyser", "min=10 max=1750 surface_resampling=2 show_particle surface=Gradient split=0.000 volume_resampling=2 ");
			selectWindow("gfap_mask_parts");
			saveAs("Tiff", dir + "gfap_mask_parts");
			selectWindow("Results");
			saveAs("Results", dir + "gfap_objects.csv");	
	close("*");
      }
  }

  function processS100B(path) {
       if (endsWith(path, "s100b.tif")) {
            open(path);
            name = File.nameWithoutExtension;
//You can modify how you want to process the images from here
//Run Unsharp Masking of the image 
            //First apply a small median (low pass) filter to blur the image
            run("Median 3D...", "x=2 y=2 z=2");
            rename("median");
            run("Duplicate...", "title=gaussian");
    		//Secondly apply big Gaussian Blur (low pass) filter to further blur the image 
            selectWindow("gaussian");
            run("Gaussian Blur 3D...", "x=15 y=15 z=15");
            //Unsharp mask the image by substracting the big Gauss Blur from your small median filtered image
            imageCalculator("Subtract create stack", "median","gaussian");
            rename("sharp");
            close("\\Others");
//Make sure the pixel width, height, and voxel depth (z-step) is correct in the properties 
			selectWindow("sharp");
//This line runs a threshold - QC this stage of the script and change accordingly 
			run("Auto Threshold", "method=Triangle ignore_black ignore_white white stack");
			saveAs("Tiff", dir +"s100b_mask");
//This runs the BoneJ particle analyzers - change min & max of the size of objects you want to analyse
	//Here parameters are set for mouse S100B+ cell bodies -/+ 5% - same parameters as GFAP as we expect GFAP signal to capture a large volume of the cells
			run("Particle Analyser", "min=10 max=1750 surface_resampling=2 show_particle surface=Gradient split=0.000 volume_resampling=2 ");
			selectWindow("s100b_mask_parts");
			saveAs("Tiff", dir +"s100b_mask_parts");
			selectWindow("Results");
			saveAs("Results", dir +"s100b_objects.csv");	
	close();
      }
  }

