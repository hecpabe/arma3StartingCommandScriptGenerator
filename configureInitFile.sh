#!/bin/bash

# Title: Configure Init File
# Name: Tomas Priora / @hecpabe
# Description: A script to configure the init file of the Arma3 Server
# Date: 5/12/2022

# Global Declarations
serverPath="/home/steam/arma3server"
serverName="server"
configFile="server.cfg"
initFile="start.sh"

tempFile="aux.tmp"

array=()
arrayLength=0

startingCommand="./arma3server -name=$serverName -config=$configFile "

# Main Program
echo "#!/bin/bash" > $initFile
echo "" >> $initFile
echo "cd $serverPath" >> $initFile

# Read mods and put them in the starting script
ls -l mods/mods | awk '{print $9}' | grep "\S" > $tempFile
readarray -t array < $tempFile
arrayLength=${#array[@]}
arrayLength=$(($arrayLength - 1))

startingCommand="$startingCommand -mod="

for i in $(seq 0 $arrayLength);
do
  if [ $i -gt 0 ]
  then
    startingCommand="$startingCommand\;"
  fi
  startingCommand="$startingCommand$(echo ${array[$i]})"
done

# Read serverside mods and put them in the starting script
ls -l mods/servermods | awk '{print $9}' | grep "\S" > $tempFile
readarray -t array < $tempFile
arrayLength=${#array[@]}
arrayLength=$(($arrayLength - 1))

startingCommand="$startingCommand -serverMod="

for i in $(seq 0 $arrayLength);
do
  if [ $i -gt 0 ]
  then
    startingCommand="$startingCommand\;"
  fi
  startingCommand="$startingCommand$(echo ${array[$i]})"
done

echo $startingCommand >> $initFile
rm $tempFile
