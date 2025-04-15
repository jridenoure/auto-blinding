# auto-blinding
resources to automatically pull info from NP3 US images, crop and rename.

decoder.py and batchProcessFolders.ijm should be common for all future studies with B-mode MT ultrasounds. CSA images will require an update to the crop size.

python output processor[StudyID].R will be renamed with study IDs e.g. CS = cluster sets, FS = fractional sets, etc to reflect the info needed from the image labels.

**Initial setup:**

1. Download and install R, python, imageJ, Rstudio

2. In imageJ, install batchProcessFolders.ijm

3. In the command line, install python packages pandas, pydicom, tkinter:

   Windows:
   
         py -m pip install pandas
         py -m pip install pydicom
         py -m pip install tkinter
  
   Mac/Linux:
   
       python -m pip install pandas
       python -m pip install pydicom
       python -m pip install tkinter
  
5. In Rstudio command line, run:

        install.packages(c("tidyverse","writexl","stringr","tools","dplyr","gWidgets2","gWidgets2tcltk))

**Running files:**

1. Ensure that there's only raw US images in the folder. If the folder is zipped, extract it.

2. Run decoder.py on folder using IDLE (easier) or Pycharm

3. Run python output processor[StudyID].R (up to the renaming section) on folder

4. From imageJ run batchProcessFolders.ijm

5. From Rstudio run the rest of the script
