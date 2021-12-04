# !/bin/bash 

# /usr/local/bin/wp-cli --version --allow-root >> /tmp/hit1
WPCLI="/usr/local/bin/wp-cli --allow-root"

# Create Log Directory. 
# WorkDir="/home/centos/Jerry-Stuff/Scripts/WordPress-CLI"
WorkDir="$PWD"
mkdir -p $WorkDir/logs > /dev/null 2>&1
mkdir -p $WorkDir/WP-ZIPS > /dev/null 2>&1

# Location which keep the wordpress.zips
WPZIPDIR="$WorkDir/WP-ZIPS"

# Format - Date,Month,Year + Hours,Minutes
timestamp=$(date +'%d%m%Y-%H%M')

logs=$WorkDir/logs/clean_wordpress_$timestamp.log

# File having cPanel user's, who needs to be cleaned.
cpuserlist="$WorkDir/$HOSTNAME.txt"

if [ ! -f ${cpuserlist} ]
then
    touch $cpuserlist
    echo "List File is Created!! Please add cPanel UserName's to: $cpuserlist"
    exit
else    
    if [ ! -s ${cpuserlist} ]
    then 
        echo "List File is Empty!! Please add cPanel UserName's to: $cpuserlist"
        exit
    fi
fi
 
# List of suspended cPanels of this server.
rm -f /tmp/tmp_listsuspended
/usr/sbin/whmapi1 listsuspended >> /tmp/tmp_listsuspended

# Function - Check wp-cli - php & functions
phpini=$($WPCLI --info | grep "php.ini" | awk '{print $3}')
grep "disable_functions" $phpini | grep -v ";" | grep "proc_open" > /dev/null 2>&1
# grep "disable_functions" $phpini 
if [ $? -eq "0" ]; then

	echo "ERROR: Please Check - disable_functions @ $phpini"
	exit
fi	


# *** =>  Functions are defined here  <= *** #
# Function Fresh WP if not existing locally - 
DownloadWP() {
	LatestWP="5.8.2" # Enter the latest version of wp. 
	if [ ! -f $WPZIPDIR/wordpress-$LatestWP.zip ]; then
		cd $WPZIPDIR/
		wget https://wordpress.org/wordpress-$LatestWP.zip > /dev/null 2>&1
		
	fi		

	if [ $WordPress -eq 1 ]; then
		WPVERFILE="wordpress-$WPVER.zip"

		if [ ! -f $WPZIPDIR/$WPVERFILE ]; then
			echo "Downloading - $WPVERFILE" 
			cd $WPZIPDIR/
			wget https://wordpress.org/$WPVERFILE > /dev/null 2>&1

			if [ $? -eq 0 ]; then
				echo "- $WPVERFILE Downloaded." 
			else 
				echo "- $WPVERFILE Not available for Download."
			fi	
		fi 	
	fi 	
}


# Function to delete the Inactive Plugins
Remove_InactivePlugins() {
	cd "$DOCROOT"/
	Inactive_Plugins=( `$WPCLI plugin list --status=inactive | awk '{print $1}' | grep -v "name" | grep -v "wpgateway"` )
	# Inactive_Plugins=( akismet )

	for Plugin in ${Inactive_Plugins[@]}; do
		echo "Inactive Plugin - delete: $Plugin"
		$WPCLI plugin delete $Plugin > /dev/null 2>&1
	done	

}


# Function to delete the Inactive Themes
Remove_InactiveThemes () {
	cd "$DOCROOT"/
	Inactive_Themes=( `$WPCLI theme list --status=inactive | awk '{print $1}' | grep -v "name"` )
	# Inactive_Themes=( twentyseventeen )

	for Theme in ${Inactive_Themes[@]}; do
		echo "Inactive Theme - delete: $Theme"
		$WPCLI theme delete $Theme > /dev/null 2>&1
	done
}

# Function Removing old files - 
MoveOld_WP() {
		# Let's kill all processes of this cPanel
    	pkill -u $CP

		echo "Function [MoveOld_WP] => Moving Old Stuff"
		# OLDDATA=""$HomeDir"/HackStuff"
		# OLDCONF=""$HomeDir"/ConfStuff"
		# "$DOCROOT" ""$OLDCONF""$DOCROOT"/"
		cp "$DOCROOT"/wp-config.php ""$OLDCONF""$DOCROOT"/" > /dev/null 2>&1
		cp "$DOCROOT"/.htaccess ""$OLDCONF""$DOCROOT"/" > /dev/null 2>&1
		cp "$DOCROOT"/*.ini ""$OLDCONF""$DOCROOT"/" > /dev/null 2>&1

		mv "$DOCROOT"/wp-admin ""$OLDDATA""$DOCROOT"/"
		mv "$DOCROOT"/wp-includes ""$OLDDATA""$DOCROOT"/"

		find "$DOCROOT" -maxdepth 1 -type f -name "*.php" ! -name "wp-config.php" -exec mv {} ""$OLDDATA""$DOCROOT"/" \;
		find "$DOCROOT" -maxdepth 1 -type f -name "*.bak" -exec mv {} ""$OLDDATA""$DOCROOT"/" \;

		rm -rf "$DOCROOT"/wpclonejack_0777 # Remove incomplete Backup Dir.
		rm -rf "$DOCROOT"/backup_0777
		rm -rf "$DOCROOT"/cgi-bin/*
		rm -rf "$DOCROOT"/.well-known
		find "$DOCROOT" -maxdepth 1 -type l -exec rm -f {} \; # Deleting the symlinks created by hacks. 
		find "$DOCROOT" -maxdepth 1 -type f -iname ".*" ! -iname ".htaccess" ! -iname ".user.ini" -exec rm -f {} \;
		find "$DOCROOT" -maxdepth 4 -type f -name "passwd" -exec rm -f {} \;
} 

# This Function will Clean the wp-content - 
CleanWpContent () {
		# Let's kill all processes of this cPanel
    	pkill -u $CP

		mkdir -p ""$OLDDATA""$DOCROOT"/wp-content/uploads"
		cd "$DOCROOT"/wp-content/

		StdDirectories="cache maintenance plugins themes uploads w3tc-config wflogs wp-business-listing wpgcache"
		WPContetnDirList=( `ls -d */ | cut -d'/' -f1 | sort -n` )

		echo "=> Extra Folder will be moved to - "$OLDDATA""$DOCROOT"/wp-content/"
		for ContentDir in ${WPContetnDirList[@]}; do 
			
			echo $StdDirectories | grep -w -o "$ContentDir" > /dev/null 2>&1
			if [ $? -ne 0 ]; then
				echo "Extra Folders in Wp-Content - "$DOCROOT"/wp-content/$ContentDir"
				mv "$DOCROOT"/wp-content/"$ContentDir" ""$OLDDATA""$DOCROOT"/wp-content/" > /dev/null 2>&1
						
			fi	

		done 

		# Reset the files Permissions & keep the logs
		echo "=> Files with Execute Permissions." 
		find "$DOCROOT"/wp-content/ -type f ! -perm 0644 -exec ls -ld {} \;  
		find "$DOCROOT"/wp-content/ -type f ! -perm 0644 -exec chmod 0644 {} \; 
		echo "=> Folder with Execute Permissions."  
		find "$DOCROOT"/wp-content/ -type d ! -perm 0755 -exec chmod 0755 {} \; 

		# Keep log of .htaccess findings and removing unwanted .htaccess.
		# find "$DOCROOT"/wp-content/ -type f -name ".htaccess" -exec ls -ld {} \;
		find "$DOCROOT"/wp-content/ -type f -name ".htaccess" -exec rm -f {} \;
		# find "$DOCROOT"/wp-content/ -type f -name "passwd" -exec rm -f {} \;  

		# cd $HomeDir
		# Moving Extra .php files wp-content.
		find "$DOCROOT"/wp-content/uploads/ -name "*.php" -exec mv {} ""$OLDDATA""$DOCROOT"/wp-content/uploads/" \; > /dev/null 2>&1
		# Moving Extra .php files wp-content.
		find "$DOCROOT"/wp-content/ -maxdepth 1 -type f -name "*.php" ! -name "maintenance.php" ! -name "index.php" ! -name "w3-total-cache-config.php" -exec mv {} ""$OLDDATA""$DOCROOT"/wp-content/" \; > /dev/null 2>&1
		find "$DOCROOT"/wp-content/ -maxdepth 3 -type l -exec rm -f {} \; # Deleting the symlinks created by hacks. 

}


# Function Fresh WP if not existing locally & Restore it 
RestoreWP() {
	if [ -d "$DOCROOT"/tmpwp ]; then
		rm -rf "$DOCROOT"/tmpwp
		mkdir "$DOCROOT"/tmpwp
	else 
		mkdir "$DOCROOT"/tmpwp
	fi 		

	cp $WPZIPDIR/$WPVERFILE "$DOCROOT"/tmpwp/ > /dev/null 2>&1

	cd "$DOCROOT"/tmpwp/
	unzip $WPVERFILE > /dev/null 2>&1
	rm -rf wordpress/wp-content

	chown -R $CP:$CP wordpress/
	find wordpress/ -type f -exec chmod 0644 {} \; > /dev/null 2>&1
	find wordpress/ -type d -exec chmod 0755 {} \; > /dev/null 2>&1
	echo " Copying Fresh Core Files pwd - $PWD"
	cp -rp wordpress/* "$DOCROOT"/

	echo "UpGrading WordPress & Plugins & Theme"
	$WPCLI core update --path="$DOCROOT" --force > /dev/null 2>&1
	
	SiteURL=$($WPCLI option get siteurl --path="$DOCROOT")
	WPVER=$($WPCLI core version --path="$DOCROOT")
	echo -e "[ SiteURL: $SiteURL ] : Updated WordPress Version: $WPVER  \n" #>> $logs 2>&1
        
    echo "	=> Updated Plugins"
    $WPCLI plugin update --all --path="$DOCROOT" #> /dev/null 2>&1
    echo  -e " \n"
        
    echo "	=> Updated Themes"
    $WPCLI theme update --all --path="$DOCROOT" #> /dev/null 2>&1
    echo -e " \n"

    chown -R $CP:$CP "$DOCROOT"/wp-admin/
    chown -R $CP:$CP "$DOCROOT"/wp-includes/
    chown -R $CP:$CP "$DOCROOT"/wp-content/plugins/
    chown -R $CP:$CP "$DOCROOT"/wp-content/themes/

	rm -rf "$DOCROOT"/tmpwp
}

# This Function Checks if cPanel having WordPress or not.
CheckWp() {
	# $WPCLI core is-installed --path="$DOCROOT" > /dev/null 2>&1
	$WPCLI core version --path="$DOCROOT"  >> $logs 2>&1
    Return=$(echo $?)

    if [ $Return -ne 0 ]; then	
    	# echo  -e " \n"
   		echo "No WordPress: [ cPanel: $CP ]  [ Domain: $DOM ] [ WebRoot: $DOCROOT ]" 
		# $WPCLI core is-installed --path="$DOCROOT" >> $logs 2>&1
		$WPCLI core version --path="$DOCROOT"  >> $logs 2>&1
		echo  -e " \n"

		unset WordPress
        WordPress="0"
 		 
	else
		echo  -e " \n"
		SiteURL=$($WPCLI option get siteurl --path="$DOCROOT")

		echo "WordPress Found: [ cPanel: $CP ] [SiteURL: $SiteURL] [ WebRoot: $DOCROOT ]"
			
		WPVER=$($WPCLI core version --path="$DOCROOT")
        echo -e "[ Domain: $DOM ] : WP Version: $WPVER  \n"
        
        echo "=> [ Domain: $DOM ] : Plugins"
        $WPCLI plugin list --path="$DOCROOT"
        echo  -e " \n"
        
        echo "=> [ Domain: $DOM ] : Themes"
        $WPCLI theme list --path="$DOCROOT"
        echo -e " \n"
 
        unset WordPress
        WordPress="1"

        # Let's kill all processes of this cPanel
        pkill -u $CP

        DownloadWP >> $logs 2>&1 # Function to download the wordpress if not existing.
        Remove_InactivePlugins >> $logs 2>&1
        Remove_InactiveThemes >> $logs 2>&1
        MoveOld_WP >> $logs 2>&1 # Function - Move the old stuff to safe folder for tmp basis.
        CleanWpContent >> $logs 2>&1
        RestoreWP >> $logs 2>&1

	fi	    	
}


# - Funtion - Checks the Document Root's Directory Structure.
CheckStrucure() {
	# SITETYPE="1" => Means Site is known - like wordpress etc.
	# SITETYPE="0" => Means Site is unknown. 

	StrucureDir=$1
	cd $StrucureDir	

	if [ -d "wp-admin" -a -d "wp-content" -a -d "wp-includes" -a -f "wp-config.php" ]; then
	  	 echo "Document Root Having WordPress Files: $StrucureDir"
	  	 DirectoryList=( `ls -l $StrucureDir | grep ^d | awk '{print $NF}' | sort -n | grep -v -e 'wp-admin\|wp-content\|wp-includes\|cgi-bin\|tmpwp'` )
	  	 SITETYPE="1"
	  	 DOCROOT="$StrucureDir"
	  	 mkdir -p "$OLDDATA"/"$DOCROOT"
		 mkdir -p "$OLDCONF"/"$DOCROOT"
	  	 CheckWp >> $logs 2>&1
	  	 echo  -e " \n"	
	  	 	   	 
	elif [ -d "application" -a -d "assets" -a -d "cache" -a -d "system" -a -d "upload" ]; then
		 echo "Document Root Having Store Files: $StrucureDir"
		 DirectoryList=( `ls -l $StrucureDir | grep ^d | awk '{print $NF}' | sort -n | grep -v -e 'application\|assets\|cache\|system\|upload\|cgi-bin\|tmpwp'` )
		 SITETYPE="1"
		 echo  -e " \n"

	elif [ -d "configuration" -a -d "css" -a -d "images" -a -d "js" -a -d "library" ]; then
		 echo "Document Root Having Rapify Files: $StrucureDir"
		 DirectoryList=( `ls -l $StrucureDir | grep ^d | awk '{print $NF}' | sort -n | grep -v -e 'configuration\|css\|images\|js\|library\|cgi-bin\|tmpwp'` )
    	 SITETYPE="1"
    	 echo  -e " \n"
	else
	     echo "  Document Root Having Unknown Files:: ** Unknown Data ** : $StrucureDir"
	     DirectoryList=( `ls -l $StrucureDir | grep ^d | awk '{print $NF}' | sort -n | grep -v 'cgi-bin\|tmpwp'` )
	     SITETYPE="0"
	     # echo  -e " \n"
		 # 	 if [ "$SITETYPE" -eq "0" ]; then
			# 	echo "  Moving this SubDomain's $ExtraDir_Domain Stuff from: $DOCROOT To "$OLDDATA""$DOCROOT"/"
			# 	mkdir -p "$OLDDATA"/"$DOCROOT"
			# 	echo "Subdomain - $DOCROOT" ""$OLDDATA""$DOCROOT"/"
			# 	echo  -e " \n"
			# fi	
		   # unset DOCROOT
	fi 

}

GetExtraDir_PublicHtml() {
	# cd $PublicHtml
	echo  -e " \n"
	echo "Scaning => public_html"

	CheckStrucure $PublicHtml >> $logs 2>&1
    SubDomainRootDir=( `uapi --user=$CP SiteTemplates list_user_settings | grep "documentroot" | awk '{print $2}'| awk -F '/' '{print $NF}' | grep -v "public_html"` )
    # SubDomainRootDir=( `uapi --user=$CP SiteTemplates list_user_settings | grep "documentroot" | awk '{print $2}'| awk -F '/' '{print $NF}'` )
	

	echo "Sub-Domain's WebRoot - ${SubDomainRootDir[@]}"
	echo "All Direcotry List - ${DirectoryList[@]}"
	echo  -e " \n"	

	if [ "$SITETYPE" -eq "1" ]; then

		for ExtraDir in ${DirectoryList[@]}; do 
			echo ${SubDomainRootDir[@]} | grep -w -o "$ExtraDir" > /dev/null 2>&1
			if [ $? -ne 0 ]; then
				unset DOCROOT
				DOCROOT=""$PublicHtml"/$ExtraDir"
				echo "=================="
				echo "Extra Directory Path - * $ExtraDir * - $DOCROOT"
				CheckStrucure  $DOCROOT >> $logs 2>&1

				if [ "$SITETYPE" -eq "0" ]; then
					echo "  Moving this Extra Directory Stuff from: $DOCROOT To "$OLDDATA""$DOCROOT"/"
					mkdir -p "$OLDDATA"/"$DOCROOT"
					mkdir -p "$OLDCONF"/"$DOCROOT"
					# echo "Extra Directory: Will Move later: $DOCROOT" ""$OLDDATA""$DOCROOT"/"
					mv "$DOCROOT" ""$OLDDATA""$DOCROOT"/"
					echo  -e " \n"
				fi	

			else 
				unset DOCROOT
				DOCROOT=$(uapi --user=$CP SiteTemplates list_user_settings | grep "documentroot" | grep -w "$ExtraDir" | awk '{print $2}')
				ExtraDir_Domain=$(uapi --user=$CP SiteTemplates list_user_settings | grep "domain:" | awk '{print $2}' | grep -w "$ExtraDir")
				echo "=================="
				echo "SubDomain's WebRoot - * $ExtraDir * * Domain - $ExtraDir_Domain * - $DOCROOT"
				CheckStrucure $DOCROOT  >> $logs 2>&1

				if [ "$SITETYPE" -eq "0" ]; then
					echo "  Moving this SubDomain's $ExtraDir_Domain Stuff from: $DOCROOT To "$OLDDATA""$DOCROOT"/"
					mkdir -p "$OLDDATA"/"$DOCROOT"
					mkdir -p "$OLDCONF"/"$DOCROOT"
					# echo "Subdomain - Will Move later: - $DOCROOT" ""$OLDDATA""$DOCROOT"/"
					mv "$DOCROOT" ""$OLDDATA""$DOCROOT"/"
					echo  -e " \n"
				fi	
				# CheckWp >> $logs 2>&1

			fi 			
		done	

	fi	
}

# *** # *** #
# *** # *** #

WPG_CP=( `cat $cpuserlist` )

# Final Execution of functions & Actions
for CP in ${WPG_CP[@]}; do
	sleep 2 
	echo  -e " \n"  >> $logs 2>&1
	echo "==> *** <==" >> $logs
	echo "==> CPANEL: $CP <==" >> $logs

	# echo "==> CPANEL: $CP <=="

	unset HomeDir
	HomeDir=$(uapi --user=$CP SiteTemplates list_user_settings | grep "homedir" | awk '{print $2}' | head -n1)

	# Checking if UAPI is capable of getting enough data.
	if [ -z "$HomeDir" ]; then
	   echo "ERROR: Unable To locate Home Directory of this cPanel: $CP"
	   UAPI_ERROR=$(uapi --user=$CP SiteTemplates list_user_settings | grep -A 1 "errors")
	   echo "$UAPI_ERROR"
	   echo "Please Check Feature List Settings."	
	   exit 
	   # As Exiting the script as UAPI is failed.
	fi

	# Let's kill all processes of this cPanel
    pkill -u $CP

	# Location where all old extra stuff will get moved. 
	OLDDATA=""$HomeDir"/HackStuff"
	OLDCONF=""$HomeDir"/ConfStuff"

	OLD_DATADIR=( $OLDDATA $OLDCONF )

	 for CheckOldDir in ${OLD_DATADIR[@]}; do 
	 		if [ -d $CheckOldDir ]; then

	 			echo "  NOTE: Old Suspicious Data Backup Folder already exists - "$CheckOldDir""_"$(date -r "$CheckOldDir" +"%Y%m%d_%H%M%S")" >> $logs 2>&1 
	 			mv -n "$CheckOldDir" ""$CheckOldDir"_$(date -r "$CheckOldDir" +"%Y%m%d_%H%M%S")"
	 			mkdir -p "$CheckOldDir"
	 			echo "  NOTE: New Suspicious Data will get moved to: $CheckOldDir" >> $logs 2>&1

	 		else 
	 			echo "  NOTE: Suspicious Data will get moved to: $CheckOldDir" >> $logs 2>&1		
	 			mkdir -p "$CheckOldDir"
	 		fi 	
	 done		

	# Checking if cPanel is active or Suspended.
	grep "$CP" /tmp/tmp_listsuspended > /dev/null 2>&1
   	if [ $? -eq 0 ]; then
   		SuspendedDomain=$(uapi --user=$CP SiteTemplates list_user_settings | grep "domain:" | awk '{print $2}')
   		echo "Suspended: [ cPanel: $CP ]  [ Domain: $SuspendedDomain ]" >> $logs 2>&1
   		echo  -e " \n"
   	else
   		PublicHtml=""$HomeDir"/public_html"
   		# echo "Public Html => $PublicHtml" >> $logs 2>&1
 		GetExtraDir_PublicHtml >> $logs 2>&1
		
  	fi

done	

# Once Whole Process is done, Just list the domains which are Cleaned & Upgraded. 
cd $WorkDir
echo "Logs: $logs"
cat $logs | grep -i "SiteURL"

# Some - v2
rm -f error_log index.php
