#!/bin/bash
# set -x 
Date=$(date +%Y-%m-%d-%H-%M-%S)
checkApp_log="checkApp_${Date}.log"

cmd1=$(cf curl /v3/apps > checkApp_${Date}.json)
item_no1=`cf curl /v3/apps | jq '.resources | length'`
item_no=`expr $item_no1 - 1`
cmd1=$(echo "###---------------------------------------------------------------------------------------------------" > $checkApp_log)
cmd1=$(echo "#                     Total number of app: $item_no                                         " >> $checkApp_log)
echo "# Total number of app: $item_no  #" 
for (( i=0; i<=$item_no; i++ ))
  do
    echo "App $i of $item_no "
    List=$(cf curl /v3/apps | jq ".resources[$i].name,.resources[$i].guid,.resources[$i].state,.resources[$i].links.space")
    set -- $List
    appName=$(echo $List | cut -d" " -f1)
    appGui=$(echo $List | cut -d" " -f2)
    appState=$(echo $List | cut -d" " -f3)
    appSpaceLink=$(echo $List | cut -d" " -f6)
    appSpaceLink1=$(echo $appSpaceLink | awk -F/ '{ print $6}')
    appSpaceGui=${appSpaceLink1::${#appSpaceLink1}-1}
 
    List2=$(cf curl /v3/spaces/$appSpaceGui | jq '.name,.links.organization')
    set -- $List2
    appSpaceName=$(echo $List2 | cut -d" " -f1)
    appOrgLink=$(echo $List2 | cut -d" " -f4)
    appOrgGui1=`echo $appOrgLink | awk -F/ '{ print $6}'`
    appOrgGui=${appOrgGui1::${#appOrgGui1}-1}
    appOrgName=`cf curl /v3/organizations/$appOrgGui | jq '.name'`
    cmd1=$(echo "###---------------------------------------------------------------------------------------------------" >> $checkApp_log)
    cmd1=$(echo "#  App No. $i                               " >> $checkApp_log)             
    cmd1=$(echo "#    appName:                 $appName      " >> $checkApp_log)
    cmd1=$(echo "#    appGui:                  $appGui       " >> $checkApp_log)
    cmd1=$(echo "#    appState:                $appState     " >> $checkApp_log)
    cmd1=$(echo "#    appSpaceLink:            $appSpaceLink " >> $checkApp_log)
    cmd1=$(echo "#    appSpaceGui:             $appSpaceGui  " >> $checkApp_log)
    cmd1=$(echo "#    appSpaceName:            $appSpaceName " >> $checkApp_log)
    cmd1=$(echo "#    appOrgLink:              $appOrgLink   " >> $checkApp_log)
    cmd1=$(echo "#    appOrgGui:               $appOrgGui    " >> $checkApp_log)
    cmd1=$(echo "#    appOrgName:              $appOrgName   " >> $checkApp_log)
  done

