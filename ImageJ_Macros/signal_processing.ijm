// Author: Phillip Muza
// Date: 07.11.22
// Update: 16.02.23 - the function to export all non-zero pixels has been included in this macro

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
             processPixels(path); //This will get processed in the current directory 
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
	//Here parameters are set for mouse GFAP+ cell bodies -/+ 5% - same parameters as GFAP as we expect GFAP signal to capture a large volume of the cells
			run("Particle Analyser", "min=50 max=1750 surface_resampling=2 show_particle surface=Gradient split=0.000 volume_resampling=2 ");
			selectWindow("s100b_mask_parts");
			saveAs("Tiff", dir +"s100b_mask_parts");
			selectWindow("Results");
			saveAs("Results", dir +"s100b_objects.csv");	
	close();
      }
  }

//this function will take "gfap.tif" as a single channel image 
	//(it does not matter which one, as long as its a single channel image) and export all non-zero pixels
		//This is then used to quantify the volume of your ROI
  function processPixels(path) {
       if (endsWith(path, "gfap.tif")) {
            open(path);
            name = getTitle();
            rename("pixels");
//Downsample your images - this is so the image size is manageable when exporting pixels to calculate ROI volume
			image_width = getWidth;
			image_height = getHeight;
			image_stack = nSlices;
			getPixelSize(unit, pixel_width, pixel_height, pixel_depth);
//The scaled_*** line to downsample the image to the same depth as the z-step divide by pixel_depth, otherwise choose your downsampling factor
	//You can change the pixel depth to whatever downsampling factor you want 
		//NOTE: the smaller your downsampling factor the more accurate your volume estimation is BUT 
			//the bigger your .txt files will be (more memory, longer processing...)
			scaled_width = (image_width*pixel_width)/pixel_depth;
			scaled_height = (image_height*pixel_height)/pixel_depth;
			scaled_stack = (image_stack*pixel_depth)/pixel_depth;
			run("Scale...", "width=" + scaled_width + " height=" + scaled_height + " depth=" + scaled_stack + " interpolation=Bicubic average process create title=downsampled");
			selectWindow("downsampled");
//Save your image and export the pixel coordinates
			txtPath = dir+"AllPixels.txt";
			run("Save XY Coordinates...", "background = 0 invert process save=["+txtPath+"]");
	close();
      }
  }

