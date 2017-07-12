#!/bin/bash

AOSP="$1"		# aosp directory location
APK="$2"		# apk full path

echo "###############################################################"
echo "# APK Unpacking"
echo "###############################################################"

echo "Extracting package name..."

WORK_DIR="$PWD"
PKG="$(aapt dump badging "$APK" | awk '/package/{gsub("name=|'"'"'","");  print $2}')"
DATA_DIR="/data/data/$PKG"

echo "Running of an emulator..."

cd $AOSP
source build/envsetup.sh > /dev/null 2>&1
lunch full-eng > /dev/null 2>&1
emulator > /dev/null 2>&1 &
cd $WORK_DIR

echo "Waiting for emulator loading..."

while [ "$EBOOT" != "1" ]
do	
	sleep 3s
	EBOOT="$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d ' \r\n')"	
done

echo "Installing of apk..."

adb install $APK > /dev/null 2>&1

echo "Launching of app..."

adb shell monkey -p $PKG -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1

echo "Waiting for the app loading..."

iter=0
max_iter=5
while [ -z "$DEX" ] && [ $iter -lt $max_iter ];
do	
	sleep 3s
	(( iter++ ))
	DEX="$(adb shell find $DATA_DIR -name *__unpacked_dex | tr -d ' \r\n')"	
done

if [ $iter -eq $max_iter ]; then
	echo "Something wrong. Unpacked dex was not created!"
	kill %1
	exit
fi

OAT="$(adb shell find $DATA_DIR -name *__unpacked_oat | tr -d ' \r\n')"

echo "Pulling unpacked DEX from emulator..."

echo "	$DEX"
echo "	$OAT"

adb pull $DEX > /dev/null 2>&1
adb pull $OAT > /dev/null 2>&1

echo "Uninstalling of apk..."

adb uninstall $PKG > /dev/null 2>&1

kill %1

echo "App was successfully unpacked!"
echo "###############################################################"