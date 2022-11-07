// Author: Phillip Muza
// Date: 07.11.22

//This macro opens multichannel images and saves them as their respective channels. This is the first step of the Fisher-Colocalisation-Pipeline
	//This macro can run recursively through directories - if doing so recursively, I recommend naming all your multichannel images the same.
		//as an example this macro assumes all multichannel images are named "img.tif" 

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

//This function will list the files within the current directory it will run "processMultichannelImg" on
   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processMultichannelImg(path);
          }
      }
  }

//This is the processMultichannelImg function that will open "img.tif" or whatever you chose to name your multichannel image and save them as individual channels
  function processMultichannelImg(path) {
       if (endsWith(path, "img.tif")) { //change the name of your image from "img.tif" to whatever here - I recommend keeping your multichannel image named as img.tif
            open(path);
			run("Split Channels");
			selectWindow("C1-img.tif"); //the macro will look for channels names "C*-img.tif" - the "img.tif" will need to be changed to whatever your multichannel image name is called
			rename("dapi"); //This is the new name of "C1-img.tif"
			selectWindow("C3-img.tif"); 
			rename("s100b"); //New name of "C3-img.tif"
			saveAs("Tiff", dir + "s100b"); //This command saves "s100b" image as "s100b.tif" - use this where appropriate for your channels
			selectWindow("C2-img.tif"); 
			rename("gfap"); //New name of "C2-img.tif"
			saveAs("Tiff", dir + "gfap");
		close("*");
      }
  }