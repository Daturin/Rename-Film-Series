# INSTALLATION

To install it right you need to define :

	- the folder where your files has been doawload 
	- the folder where your files need to be moved
	- this folder need to contains two  subfolders : "Movies" and "Series" 


# DESCRIPTION

The .bat script permit to copy and moved the files from "Download" to "Videos"
The .ps1 script permit to rename the files and class into "Movies" or "Series"
The .txt script permit to determine which words could be delete from filenames.

# SCRIPTS

# Plex_NAS.bat : 

When you doawnload movies or series, the files may be stocked into a directory.
The first step allows you to remove the file from the directory that contains it and put it in the root of the download directory.

A function was include this year to ignore if file are dowloading currently the script is running
The ".part" file are ignored.


# Plex_NAS.ps1 :

This script allows you to rename all the files in your download directory.
Folder and files being downloaded are ignored.

The first step:
	
	- allows you to delete the characters in "[]" before the real name of your movie or your epidemic
	(usually this is the website where the files were downloaded)

The second step:
	
	- rename the file if a year has been found between 1980 and the current year
	(very problematic for movien 2012 but it was a bad movie ..)

The third step:
	
	- read the "Config_Plex" file and rename the films if they contain words from the "Config_Pex" file
	- there is a subtlety in this configuration file, you can delete all the characters after a keyword
	- For example if you write: FRANÇAIS *. * -> All characters after this keyword are deleted (so be careful!)

The fourth step:
	
	- classifies the file if it is detected at an episode of a series
	- to determine if a file is an episode, the script searches in the file name if it ends with "S ?? E ??"
	- In that case :
		-a sub-folder is created in the "Series" folder
		-a sub-folder is created in the previous sub-folder with the season number: "Season 01"
		-the script asks you to confirm that the episode could be moved to the new tree

