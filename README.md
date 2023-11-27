# progtools

This is a bash script designed to install essential programming tools and builds up the beginner programming environment.<br>
The script also creates ten executable files, asm, runa, py, runp, cee, runc, cee++, runc++.<br>
which can be used to compile and run programs written in Assembly, C, C++ and Python.<br><br>

# Requirements

The script is designed to work on Linux operating systems, specifically those that use the apt package manager (such as Debian and Ubuntu).<br>
The script requires root privileges to run.

# Usage

To run the script, execute the following command with root privileges:<br><br>

`sudo ./progtools.sh \<username\>`<br><br>

Replace <username> with the username of the user for whom you want to use the<br>tools and install file structure in his home directory.<br><br>

# Folder Structure
<br>
The script creates a folder structure for programming projects at the following location:
<br><br>
  
  `{user home directory}/programming/`
  <br><br>
Inside the programming folder, the script creates subfolders for C, C++, Python, Assembly, and Bash scripts.<br><br>
  
# Executable Files

The script creates 8 executable files:
<br><br>
**asm**<br>

This file is used to create and edit Assembly files.<br>
If the file already exists, the script opens the file in the chosen text editor. <br>
If the file does not exist, the script creates the file and adds a template for an Assembly program based on system arch.<br><br>

**runa**
<br><br>
This file is used to assemble, link, and run an Assembly program.<br>
The script assembles the program using NASM, links it using LD, and then runs the program.<br> 
The script also calculates the time it takes to assemble and run the program.<br><br>


**cee**
<br><br>
This file is used to create and edit C files.<br>
If the file already exists, the script opens the file in the chosen text editor. <br>
If the file does not exist, the script creates the file and adds a template for an C program.<br><br>


**runc**
<br><br>
This file is used to compile and run an C program.<br>
The script compile the program using GCC and then runs the program.<br> 
The script also calculates the time it takes to compile and run the program.<br><br>


**cee++**
<br><br>
This file is used to create and edit C++ files.<br>
If the file already exists, the script opens the file in the chosen text editor. <br>
If the file does not exist, the script creates the file and adds a template for an C++ program.<br><br>


**runc++**
<br><br>
This file is used to compile and run an C++ program.<br>
The script compile the program using G++ and then runs the program.<br> 
The script also calculates the time it takes to compile and run the program.<br><br>



**py**
<br><br>
This file is used to create and edit Python files. <br>
If the file already exists, the script opens the file in the chosen text editor. <br>
If the file does not exist, the script creates the file and opens the file in the chosen text editor.<br><br>


**runp**<br><br>
This file is used to run a Python program.<br>
The script runs the program using Python 3 and calculates the time it takes to run the program.<br><br>

# Conclusion

This script is a simple way to install essential programming tools and set up a folder structure <br>for programming projects.<br>
The executable files created by the script make it easy to create, edit, and run programs in Assembly, C, C++ and Python.


# Examples
<br>**C**<br><br>
to create a new C project called example in `{user home directory}/programming/C/example` : <br><br>
`cee example` 
<br><br>
the script will open the main C file called example.c in the chosen text editor in the progtools installation.<br>
to run example project use:<br><br>
`runc -c "-pthread -g" -e "arg1 arg2" example`
<br> <br>
this will compile example.c using the provided gcc options "-pthred and -g", and will pass arg1 and <br> arg2 to example elf file.<br>
-e : pass args to elf file
-c : pass options to gcc on compilation
 <br><br><br>
 <br>**C++**<br><br>
<br>
 to create a new C++ project called example in `{user home directory}/programming/C++/example` : <br><br>
`cee++ example`
<br><br>
the script will open the main C++ file called example.cpp in the chosen text editor in the progtools installation.<br>
to run example project use:<br><br>
`runc++ -c "g++ options" -e "arg1 arg2" example`
<br><br> 
this will compile example.cpp using the provided g++ options "g++ options", and will pass arg1 and <br> arg2 to example elf file.<br>
-e : pass args to elf file
-c : pass options to g++ on compilation



<br><br><br><br>
<br>**Assembly**<br><br>
to create a new asm project called example in `{user home directory}/programming/asm/example` : <br><br>
`asm example`
<br><br>
the script will open the main asm file called example.asm in the chosen text editor in the progtools installation.<br>
to run example project use:<br><br>
`runa example "arg1 arg2"`
<br> <br>
this will assemble example.asm using nasm and link using ld, and will pass arg1 and <br> arg2 to example elf file.<br>



<br><br>
<br>
<br>**Python3**<br><br>

to create a new python3 project called example in `{user home directory}/programming/pyhton/example` : <br><br>
`py example`
<br><br>
the script will open the main python file called example.py in the chosen text editor in the progtools installation.<br>
to run example project use:<br><br>
`runp example "arg1 arg2"`
<br><br> 
this will execute example.py, and will pass arg1 and <br> arg2 to example python file.<br>


