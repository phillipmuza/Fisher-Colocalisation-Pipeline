//Author: Phillip Muza
//Date: 07.11.22

//This macro will export all non-zero pixels from a single channel image
	//This is required to quantify the volume of your ROI

   requires("1.33s"); 
   dir = getDirectory("Choose your registration folder... ");
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

//This function will list the files in the current directory and run processPixels function
   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processPixels(path);
          }
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

