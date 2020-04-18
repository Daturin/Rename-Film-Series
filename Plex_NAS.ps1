
#DEBUT ENTETE
<#
$list_entete = Get-Content "U:\Config_Plex.txt" | Where-Object {$_ -Match('\[')}
Foreach ($Ligne in $list_entete) {
	echo $Ligne
	Get-ChildItem "U:\"  | Rename-Item -NewName { $_.Name -replace ($Ligne, '') }
}
#>


Get-ChildItem "U:\" | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  { 
	$regex_new=0
	$extension = $_.Extension 
	$BaseName = $_.BaseName
	$FullName = $_.FullName  		#ancien chemin
	$FullNameNew = $FullName		#chemin qui sera MAJ
	$Name = $_.Name
	while ($regex_new -ne '\[\]'){
		$regex = [regex]::match($BaseName,'\[([^\]]+)\]').Groups[1].Value
		$regex_new = '\[' + $regex + '\]'
		echo $regex_new
		echo $BaseName	
		$BaseNameNew = $BaseName -replace ($regex_new,' ')		#Stockage du nouveau nom
		$FullName = $FullNameNew								#Initialiseation du nom du chemin
		echo $BaseNameNew
			if ($regex_new -ne '\[\]') {
			Rename-Item -LiteralPath  $FullNameNew -NewName ($BaseNameNew + $extension)			#L'option literal permet de prendre en compte les "["
			$BaseName = $BaseNameNew
			$FullNameNew = $FullName -replace ($regex_new,' ')		#MAJ du nom du nouveau chemin
			} 
	}
}
#FIN ENTETE


#SEPARATEUR
$excluded_Fic_Param = @("Config_Plex.txt")
#Get-ChildItem "U:\" -recurse -exclude $excluded_Fic_Param | Rename-Item -NewName { $_.Name -replace ('\]', '') }
Get-childitem "U:\" -recurse | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | Rename-Item -NewName { $_.Name -replace ('-', ' ') }
Get-childitem "U:\" -recurse | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | Rename-Item -NewName { $_.Name -replace ('_', ' ') }
Get-ChildItem "U:\" -recurse | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | Rename-Item -NewName { $_.Name -replace ('\[', '') }
Get-ChildItem "U:\" -recurse | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | Rename-Item -NewName { $_.Name -replace ('\]', '') }


#DEBUT CONTENU
$Annee_Debut=1980
#PERMET DE FINIR LA BOUCLE
$Annee_Fin=[int] (Get-Date -UFormat "%Y") + 1
Do {
echo $Annee_Debut 
Get-ChildItem "U:\"  | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
		$extension = $_.Extension 
		$BaseName = $_.BaseName
		$Name = $_.Name
		$Nouveaunom = $BaseName -replace ($Annee_Debut, ' ')
		echo $Nouveaunom 
		Rename-Item -Path $_.FullName -NewName ($Nouveaunom + $extension)
		}
$Annee_Debut=$Annee_Debut+1
}
While ($Annee_Debut -ne $Annee_Fin)

echo 'Le renommage de l annee est termine'
#FIN CONTENU


#DEBUT CONTENU
$list = Get-Content "U:\Config_Plex.txt" | Where-Object {$_ -NotMatch("`/`/") -AND $_ -NotMatch("\[")}
Foreach ($Line in $list) {
	echo $Line
	Get-ChildItem "U:\" | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
		echo $Line
		$extension = $_.Extension 
		$BaseName = $_.BaseName
		$Name = $_.Name
		echo $extension
		$Nouveau = $BaseName -replace ($Line,'')
		echo $Nouveau
		Rename-Item -Path $_.FullName -NewName ($Nouveau + $extension)
		$new_name = $_.Name
		echo $new_name
	}
}
#FIN CONTENU


Get-ChildItem "U:\" | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
	$extension = $_.Extension 
	$BaseName = $_.BaseName
	$Name = $_.Name
	echo $extension
	echo $Name
	echo $BaseName
	$Nouveaunom = $BaseName -replace ('[\.]', ' ')
	echo $Nouveaunom 
	Rename-Item -Path $_.FullName -NewName ($Nouveaunom + $extension)
	}

echo 'Le renommage est termine'

Get-ChildItem "U:\" | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
	$extension = $_.Extension 
	$ancien_nom = $_.BaseName
	echo $ancien_nom
	$ancien_nom.Length
	$nouveau_nom=$ancien_nom.Trim()
	echo $nouveau_nom
	$nouveau_nom.Length
	Rename-Item -Path $_.FullName -NewName ($nouveau_nom + $extension)
}

echo 'Le chaine de caractere a ete optimisee'

echo 'La copie des episodes de serie commence..' 
$Local = "X:\Plex_Series"
Get-ChildItem "U:\"  | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
	
	If($_.Basename -Match('.*?S.*?(\d{2}).*?E.*')) #Permet de prendre en compte les séries type 'S01E08'
		{  
			$Saison = $_.Basename.substring($_.Basename.length - 5, 2)  #S01
			$Episode =  $_.Basename.substring($_.Basename.length - 2, 2)  #E01
			$NomSerie =  $_.Basename.substring(0, $_.Basename.length - 6)  #Fear The Walkign Dead
			$NomSerie = $NomSerie.Trim()
			
			$Fichier = $_.FullName
			
			$Saison ='Saison ' + $Saison
			$Episode ='Episode ' + $Episode
			
			echo $Saison
			echo $Episode 
			echo $NomSerie
			
			$final_folder_serie = "$Local\$NomSerie\"
			$final_folder_saison = "$Local\$NomSerie\$Saison\"
			$FileExists_serie = Test-Path $final_folder_serie 
			$FileExists_saison = Test-Path $final_folder_saison 
			
			echo $final_folder_serie
			echo $final_folder_saison
			
			If ($FileExists_serie -eq $False)  #Check si le répertoire de la série existe
				{	   
		
					New-Item -Path $final_folder_serie	-ItemType Directory -Confirm		#Creation repertoire de la serie sur confirmation du user
		
				}
			If ($FileExists_saison -eq $False)   #Check si le répertoire de la saison existe
				{	
					$FileExists_serie = Test-Path $final_folder_serie 
					echo $FileExists_serie
					If ($FileExists_serie -eq $True)	#Pas de serie = pas de saison
						{	
					
							New-Item -Path $final_folder_saison -ItemType Directory	-Confirm	#Creation repertoire de la saison de la serie
							
						}
				}
			
			echo $Fichier
			echo $_.FullName
			Write-Host $Fichier ' vers ' $final_folder_saison
			Move-Item -Force $Fichier $final_folder_saison		#Déplacer dans le répertoire cible
		}
}
echo 'La copie des episodes de serie s est effectuee avec succes' 

echo 'La copie des films commence..' 
$Local = "X:\Plex_Movies"
Get-ChildItem "U:\"  | Where-Object {-not $_.PSIsContainer -and $_.Extension -ne '.txt' -and $_.Extension -ne '.part' } | foreach-object  {
	$Fichier = $_.FullName
	$final_folder_movies = "$Local"
	Write-Host $Fichier ' vers ' $final_folder_movies
	Move-Item -Force $Fichier $final_folder_movies	#Déplacer dans le répertoire cible
}

echo 'La copie des films s est effectuee avec succes' 

