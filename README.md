# progtools

This is a bash script designed to install essential programming tools and set up a folder structure for programming projects.<br>
The script also creates ten executable files, asm, arun, py, pyrun, code, codet, codec, run, runc and runt.<br>
which can be used to compile and run programs written in Assembly, C, C++ and Python.<br><br>

# Requirements

The script is designed to work on Linux operating systems, specifically those that use the apt package manager (such as Debian and Ubuntu).<br>
The script requires root privileges to run.

# Usage

To run the script, execute the following command with root privileges:<br><br>

**sudo ./progtools64.sh <username>**<br><br>
or<br><br>
**sudo ./progtools32.sh <username>**<br>
*for 32 systems.<br><br>
Replace <username> with the username of the user for whom you want to use the 10 executable files.<br><br>

# Folder Structure
<br>
The script creates a folder structure for programming projects at the following location:
<br><br>
**/home/\<username\>/Desktop/programming/**
<br><br>
Inside the programming folder, the script creates subfolders for C, C++, Python, Assembly, and Bash scripts.
<br><br>
# Executable Files

The script creates 10 executable files:
<br>
**asm**<br>

This file is used to create and edit Assembly files.<br>
If the file already exists, the script opens the file in Vim. <br>
If the file does not exist, the script creates the file and adds a template for an Assembly program.<br><br>

**arun**
<br><br>
This file is used to assemble, link, and run an Assembly program.<br>
The script assembles the program using NASM, links it using LD, and then runs the program.<br> 
The script also calculates the time it takes to assemble and run the program.<br><br>


**code**
<br><br>
This file is used to create and edit C files.<br>
If the file already exists, the script opens the file in Vim. <br>
If the file does not exist, the script creates the file and adds a template for an C program.<br><br>


**run**
<br><br>
This file is used to compile and run an C program.<br>
The script compile the program using GCC and then runs the program.<br> 
The script also calculates the time it takes to compile and run the program.<br><br>


**codec**
<br><br>
This file is used to create and edit C++ files.<br>
If the file already exists, the script opens the file in Vim. <br>
If the file does not exist, the script creates the file and adds a template for an C++ program.<br><br>


**runc**
<br><br>
This file is used to compile and run an C++ program.<br>
The script compile the program using G++ and then runs the program.<br> 
The script also calculates the time it takes to compile and run the program.<br><br>


**codet**
<br><br>
This file is used to create and edit C files.<br>
If the file already exists, the script opens the file in Vim. <br>
If the file does not exist, the script creates the file and adds a template for an C program that uses pthread.<br><br>



**runt**
<br><br>
This file is used to compile and run an C program that uses pthread.<br>
The script compile the program using GCC and then runs the program.<br> 
The script also calculates the time it takes to compile and run the program.<br><br>


**py**

This file is used to create and edit Python files. <br>
If the file already exists, the script opens the file in Vim. <br>
If the file does not exist, the script creates the file and opens it in Vim.<br><br>
**pyrun**<br>
This file is used to run a Python program.<br>
The script runs the program using Python 3 and calculates the time it takes to run the program.<br><br>

# Conclusion

This script is a simple way to install essential programming tools and set up a folder structure <br>for programming projects.<br>
The executable files created by the script make it easy to create, edit, and run programs in Assembly, C, C++ and Python.
