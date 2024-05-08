This is a general guidline to how the script works, along with some assumptions.

We assume that you have a factorio server present already on your headless Linux Server that is running a Debian Based system with the installation in the /opt/ folder.

We also assume that you have a basic understanding of where your files are and will need to adjust the file according.

The script has 4 functions.

Function 1. Retrieves the Latest version from the Factorio.com/download website. 

*note* If anything changes with this site it could break the auto-update feature.

Function 2. Retrieves the Current installation from the factorio installation.
  
*note* If your installation is not in the same location you will need to adjust this accordingly

Function 3. Compares the two versions that you have revieved to determine if you have the latest or not.

Function 4. This is an automated update that has several logical steps

Steps of the script

1. Removes the Archived Installation - Oldest Version
2. Copies the Backup to the Archived position
3. Removes the Backup Installation
4. Stops the Service
5. Copies the current installation to the Backup position
6. Downloads a copy of the newest version
7. Makes sure the service is not running
8. Untars the xz file into the current installation assuming it is in the /opt/ folder
9. Starts the Service
10. Checks the status.


If you system is up to date the script will do nothing.
