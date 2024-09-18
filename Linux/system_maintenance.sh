#!/bin/bash

maintenance_file=maintenance_output.txt

echo “System check up started” >> $maintenance_file
echo >> $maintenance_file

sudo apt upgrade >> $maintenance_file
echo >> $maintenance_file
echo “System packages updated successfully”>> $maintenance_file
echo “-------------------------------------------” >> $maintenance_file
echo >> $maintenance_file
echo “Deleting unnecessary  packages” >> $maintenance_file
echo >> $maintenance_file
sudo apt clean >> $maintenance_file
sudo apt autoremove >> $maintenance_file

echo “-------------------------------------------”>> $maintenance_file
echo >> $maintenance_file
echo “Checking the Disc status” >> $maintenance_file

df -h >> $maintenance_file
echo “-------------------------------------------” >> $maintenance_file
echo >> $maintenance_file
echo “Checking connected users” >> $maintenance_file

echo “Users currently connected” >> $maintenance_file
who | cut -f1 -d ' ' | uniq -c | sort | sed 's/^ *//g' >> $maintenance_file

echo “-------------------------------------------” >> $maintenance_file
echo >> $maintenance_file
echo “Top 5 CPU consuming processes”  >> $maintenance_file
echo  >> $maintenance_file
ps -e -o pid,cmd,%cpu,%mem --sort=-%cpu | head -n 6 >> $maintenance_file

echo>> $maintenance_file

echo “Top 5 Memory consuming processes” >> $maintenance_file
echo>> $maintenance_file
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6 >> $maintenance_file

echo>> $maintenance_file
echo “System check up completed”  >> $maintenance_file

echo “Analysis has been completed. See ‘maintenance_output.txt’”


