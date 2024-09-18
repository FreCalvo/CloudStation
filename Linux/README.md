
**Part 1. Users creation and permission assignment**

a) **Create user:**
	-Create new user named devuser.
	-Assign  safe password for devuser.

	Steps in the Terminal.
  -Open the Terminal
	-In order to create the new user use: sudo useradd devuser
	-To assign password for devuser type: sudo  passwd devuser
	-You will be asked to enter the new password: #dev01234
	-You will be asked to retype the new password: #dev01234

b) **Create group Developers:**
	-Create a group named developers.
	-Add devuser to the group developers.

	Steps in the Terminal
	-For the new group to be created type: sudo groupadd developers
	-devuser can be added to the developers group through: sudo usermod -aG developers devuser
	-Confirm devuser was add to developer by typing: groups devuser. 
  -You should see: devuser : devuser developers

![fredubuntu@ubuntufred-$ groups devuser](https://github.com/user-attachments/assets/e3768064-f56b-4ef2-80bd-1cccaf68a191)


c) **Create Project directory:**
	-Create a directory named /opt/devproject.
	-Change the directory property for it to belong to devuser and developers group.
	-Assign read, write and execution permits for the owner and group, but only read and execution for other users.

	Steps in the Terminal.
	-For the directory to be created enter: mkdir opt
	-Again: mkdir opt/devproject
	-Use the following command to change the property of the directory to belong to devuser and developers: sudo chown devuser:developers 		devproject
	-The following permits most be assigned rwxrwxr-x, therefore type :sudo chmod 775 opt/devproject
	-To check permit were allocated as expected do: ls -l
	-devproject should show: drwxrwxr-x # devuser developers ###

￼![total 4](https://github.com/user-attachments/assets/716bc385-490a-4d28-9c5a-660b25b98102)



**Part 2. Create a System Maintenance script**

Create a Bash script named system_maintenance.sh that performs the following tasks:

a)** System update:**
	Updates the system packages.

b) **Packages cleaning:**
	Deletes unnecessary packages and cleans the cache.

c) **checks the disc status:**
	shows the disc usage.

d) **Checks active users:**
	Lists users currently connected.

e) **Checks the CPU process:**
	Shows the 5 processes that consume the most CPU capacity.


Steps in the Terminal

Open the Terminal 
Type:  nano system_maintenance.sh. This will create a dash file and open the text editor.

Copy the script below:

Script

#!/bin/bash

maintenance_file=maintenance_output.txt

echo “System check up started” >> $maintenance_file
echo >> $maintenance_file
	
sudo apt upgrade >> $maintenance_file
echo >> $maintenance_file
echo “System packages updated successfully” >> $maintenance_file

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

———————————————End of the script——————————————————

Type : ^O to save changes. Then press Enter

Type: ^X to exit Nano editor

Enter the command: chmod +x system_maintenance.sh. This will assign execution permission.

Run the .sh program by typing: ./system_maintenance.sh


