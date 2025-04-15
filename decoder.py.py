import pandas
import pydicom
import os
import numpy
from tkinter import filedialog
#workingDir folder should contain raw US files *only*
#directory in next line should be formatted exactly like this:
#workingDir = "C:/Users/HKSLAB07/Downloads/Folder 69/Folder 69/"
workingDir = filedialog.askdirectory()+"/"
files = os.listdir(workingDir)
df=pandas.DataFrame()
base= os.path.basename(os.path.dirname(workingDir))
for file in files:
    dsFull = pydicom.dcmread(workingDir + file)
    #print(type(dsFull))
    ds1 = (dsFull.get_item([0x7fe1, 0x1001]))
    ds1 = pydicom.dataelem.convert_raw_data_element(ds1)
    #print("ds1 \n", type(ds1))
    ds2 = ds1[0].get_item([0x7fe1, 0x1073])
    ds2 = pydicom.dataelem.convert_raw_data_element(ds2)
    #print("ds2 \n", type(ds2))
    ds3 = ds2[0].get_item([0x7fe1, 0x1075])
    ds3 = pydicom.dataelem.convert_raw_data_element(ds3)
    #print("ds3 \n", type(ds3))
    ds4 = ds3[-1].get_item([0x7fe1, 0x1057]).value

    #print("ds2 \n", type(ds2))
    #print("ds3 \n", type(ds3))
    #print("ds4 \n", type(ds4))
    #print(ds4)
    ID = dsFull.PatientID
    imgData = list((file,ID,ds4))
    imgData2 = list((ID,ds4))
    dataSeries = (pandas.Series(data=imgData)).T
    df = pandas.concat([df,dataSeries.to_frame().T],ignore_index=True)
    #print(df)
    #print("iterator: \n", file)

print(df)

df.to_csv(workingDir + base + " output.txt",index=False)
