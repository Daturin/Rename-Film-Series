@ECHO OFF 

::Definition Acces NAS
net use U: \\Download /user:<login> <password>
net use X: \\video /user:<login> <password>

set dSource=U:\
set dTarget_Movies=X:\Plex_Movies
set dTarget_Series=X:\Plex_Series
set fType=*.avi
set fType2=*.ac3 
set fType3=*.mkv
set fType4=*.mp4
::format des films en cours de telechargement
set fType5=*.part

::Vérification des répetoires clefs
if not exist "%dSource%" goto :Plex_folder 
if not exist "%dTarget_Movies%" mkdir %dTarget_Movies% && echo Le dossier Plex_Movies a ete cree avec succes. 
if not exist "%dTarget_Series%" mkdir %dTarget_Series% && echo Le dossier Plex_Series a ete cree avec succes. 
if not exist "U:\Config_plex.txt"  goto :Config_Plex

::Copier les fichiers présents dans les répertoires Fils
pushd U:\
for /r %%f in (%fType% %fType2% %fType3% %fType4%) do (
	move /-y "%%f" "%dSource%\"
echo La copie du fichier "%%f" s est bien deroulee.
)
timeout 5 >nul

::Supprimer les répertoire qui ne contiennent pas des films en cours de téléchargement
for /f "delims=" %%i in ('dir /a:d /b /s "%dSource%"') do (
	echo "%%i"
	pushd "%%i"	
	if not exist "%fType5%" (
		pushd U:\ && rd /s /q "%%i" && echo La suppression du repertoire "%%i" s est bien deroulee.		
		) else echo Le repertoire "%%i" contient des films en cours de telechargement.	
		timeout 5 >nul
	)

::Lancement du script Powershell
echo **********************************************************
echo Le script de renommage des fichiers est pret a se lancer.
echo **********************************************************
timeout 5 >nul
PowerShell.exe -Command "& '%~dpn0.ps1'" 
pause
exit

:Plex_folder
echo ************************************************************************************************************
echo Le dossier %dSource% n'existe pas, vous devez le creer et deposer vos films dedans !
echo ************************************************************************************************************
pause
exit

:Config_Plex
	echo *******************************************************************************
	echo Le fichier "Config_Plex.txt" n'a pas ete trouve dans le repertoire "%dSource%".
	echo *******************************************************************************
	
	::Creer le fichier Config_Plex
		set /P AREYOUSURE=Voulez-vous que le fichier "Config_Plex.txt" soit creer (O/[N])?
		if /I "%AREYOUSURE%" EQU "O" goto CREATE_CONFIG_PLEX_TXT 
		if /I "%AREYOUSURE%" EQU "N" echo Le fichier "Config_Plex.txt" n'a pas ete creer. && pause && exit 
	
	::Création du fichier texte
	:CREATE_CONFIG_PLEX_TXT
		( echo //Ceci est un commentaire
		echo //Rajouter une chaine de caractere qui doit etre remplacee
		echo FASTSUB
		echo AC3-TMB
		echo LiMiTED
		echo TRUEFRENCH
		echo FRENCH
		echo Cortex91
		echo BDRip
		echo DVDRip
		echo RERiP
		echo WEBRip
		echo BluRay.x264-LOST
		echo BluRayx26
		echo 720p
		echo 1080p
		echo HDTV
		echo VOSTFR
		echo WEB-DL
		echo FiNAL
		echo //Le symbole * permet de prendre en compte les caracteres apres une chaine de caractere ici : Xvid
		echo XviD *.*
		echo DivX *.*) > %dSource%\Config_Plex.txt
	
	:: Sortie de la création du fichier txt
		echo Le fichier "Config_Plex.txt" a ete creer dans le repertoire "%dSource%".
		echo N hesitez pas a le modifier pour prendre en compte de nouvelles chaines de caracteres.
		echo **********
		echo Have fun :)
		echo **********
		goto :TRI_MOVIES

timeout 5 >nul
exit