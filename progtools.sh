#!/bin/bash
if [ "$#" -eq 1 ]; then
	if id -u $1 >/dev/null 2>&1; then
            
        # List of popular text editors
        editors=("vim" "code" "gedit" "nano" "emacs")



        # Prompt the user to select a text editor
        PS3="Enter the number of your preferred text editor: "
        select editor in "${editors[@]}"; do
            if [[ -n $editor ]]; then
                echo "You selected: $editor"
                # Install the selected editor
                apt update
                apt install -fy nasm g++ gcc gdb python3 bc "$editor"
                break
            else
                {>&2 echo "Invalid choice. Please enter a valid number."; exit 1;}  # Exit the script with an error code
            fi
        done







        if [ "$1" = "root" ]; then
            home="/root"
        else
            home="/home/$1"
        fi



        mkdir -p $home/programming/{C,C++,python,asm,bash}  

        chown $1:$1 $home/programming/{C,C++,python,asm,bash} 

        ##asm
        printf '#!/bin/bash 

        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi

        ff=$home/programming/asm/$1
        FILE=$home/programming/asm/$1/$1.asm
        if [[ -d "$ff" ]]; then
            cd "$home/programming/asm/$1"
        else
            mkdir -p "$home/programming/asm/$1" || {>&2 echo "Error : Cannot create new directory."; exit 1;}
            cd "$home/programming/asm/$1"
        fi


        if [[ -f "$FILE" ]]; then
            %s "$1.asm" &
        else
                touch "$1.asm"
                echo "; Author : $(whoami)" >> "$1.asm"' $editor > /bin/asm 	
        printf '
            distro_name=$(lsb_release -si)
                distro_version=$(lsb_release -sr)
        arch=$(uname -m)
        # Check system architecture
        if [ "$arch" == "x86_64" ]; then
            register1="rax"
            register2="rdi"
            syscallid="60"
            call="syscall"
        elif [ "$arch" == "i386" ]  || [ "$arch" == "i686" ]; then
            register1="eax"
            register2="ebx"
            syscallid="1"
            call="int 0x80"
        else
            >&2 echo "Error: Unsupported arch."
            exit 1
        fi

        echo "; OS : $distro_name $distro_version $arch" >> "$1.asm"
            echo "; Date : $(date "+%%d-%%b-%%Y")" >> "$1.asm"
                echo "" >> "$1.asm"
                echo "global _start" >> "$1.asm"
                echo "section .text" >> "$1.asm"
                echo "end:" >> "$1.asm"
                echo "" >> "$1.asm"
                echo "mov $register1,$syscallid" >> "$1.asm"
                echo "mov $register2,0" >> "$1.asm"
                echo "$call" >> "$1.asm"
            echo "_start:" >> "$1.asm"
            echo "jmp end" >> "$1.asm"
                echo "section .data" >> "$1.asm"
                %s "$1.asm" &
        fi' $editor >> /bin/asm
        chown $1:$1 /bin/asm
        chmod 555 /bin/asm

        ##runa
        printf '#!/bin/bash
        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi
        cd $home/programming/asm/"$1" || { >&2 echo "Error: Directory does not exist."; exit 1; }
        s1=`date +%%s.%%N`

        arch=$(uname -m)
        # Check system architecture
        if [ "$arch" == "x86_64" ]; then
            f="elf64"
            m=elf_x86_64
        elif [ "$arch" == "i386" ] || [ "$arch" == "i686" ]; then
            f="elf32"
            m=elf_i386
        else
            >&2 echo "Error: Unsupported arch."
            exit 1
        fi

        nasm -f $f $1.asm || { >&2 echo "Error: assembling error."; exit 1; }
        ld -m $m -o $1 $1.o || { >&2 echo "Error: linking error."; exit 1; }

        script_name="$1"
        shift  

        e1=`date +%%s.%%N`
        t1=$( echo "$e1 - $s1" | bc -l)
        echo ""
        s2=`date +%%s.%%N`
        ./$script_name "$@"
        status=$?
        echo ""
        e2=`date +%%s.%%N`
        t2=$( echo "$e2 - $s2" | bc -l)
        echo ""

        # Get the number of columns in the terminal
        col=$(tput cols)

        # Construct the pattern
        pattern=""
        for ((i = 0; i < col; i++)); do
            pattern+="═"
        done

        # Print the pattern


        echo "$pattern"
        echo " status code :  $status "
        echo " assembled & linked in  $t1 s"
        echo "  executed in $t2 s"
        echo "$pattern"
        rm $script_name' >/bin/runa
        chown $1:$1 /bin/runa
        chmod 555 /bin/runa



        ##runp
        printf '#!/bin/bash

        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi
        cd $home/programming/python/"$1" || { >&2 echo "Error: Directory does not exist."; exit 1; }
        script_name="$1"
        shift 
        s1=`date +%%s.%%N`
        python3 $script_name.py "$@"
        status=$?
        e1=`date +%%s.%%N`
        t1=$( echo "$e1 - $s1" | bc -l)
        echo ""

        # Get the number of columns in the terminal
        col=$(tput cols)

        # Construct the pattern
        pattern=""
        for ((i = 0; i < col; i++)); do
            pattern+="═"
        done

        # Print the pattern


        echo "$pattern"
        echo " status code :  $status "
        echo " executed in $t1 s"
        echo "$pattern"
        ' >/bin/runp
        chown $1:$1 /bin/runp
        chmod 555 /bin/runp




        ##py
        printf '#!/bin/bash 
        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi

        ff=$home/programming/python/$1
        FILE=$home/programming/python/$1/$1.py
        if [[ -d "$ff" ]]; then
            cd "$home/programming/python/$1"
        else
            mkdir -p "$home/programming/python/$1"|| {>&2 echo "Error : Cannot create new directory."; exit 1;}
            cd "$home/programming/python/$1"
        fi


        if [[ -f "$FILE" ]]; then
            %s "$1.py" &
        else
                touch "$1.py"
                %s "$1.py" &
        fi' $editor $editor>/bin/py
        chown $1:$1 /bin/py
        chmod 555 /bin/py

        ##cee
        printf '#!/bin/bash 
        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi

        ff=$home/programming/C/$1
        FILE=$home/programming/C/$1/$1.c
        if [[ -d "$ff" ]]; then
            cd "$home/programming/C/$1"
        else
            mkdir -p "$home/programming/C/$1" || {>&2 echo "Error : Cannot create new directory."; exit 1;}
            cd "$home/programming/C/$1"
        fi


        if [[ -f "$FILE" ]]; then
            %s "$1.c" &
        else
                touch "$1.c"
                echo "/*" >> "$1.c"
                echo "*" >> "$1.c"
                echo "*	Author : $(whoami)' $editor > /bin/cee
                printf '" >> "$1.c"
                echo "*" >> "$1.c"
                distro_name=$(lsb_release -si)
                distro_version=$(lsb_release -sr)
        arch=$(uname -m)
        echo "*	OS : $distro_name $distro_version $arch" >> "$1.c"
                echo "*" >> "$1.c"
            echo "*	Date : $(date "+%%d-%%b-%%Y")" >> "$1.c"
                echo "*" >> "$1.c"
                echo "*/" >> "$1.c"
                echo "#include <stdio.h>" >> "$1.c"
                echo "int main(int argc,char** argv){" >> "$1.c"
                echo "" >> "$1.c"
                echo "	return 0;" >> "$1.c"
                echo "}" >> "$1.c"
                %s "$1.c" &
        fi' $editor >>/bin/cee
        chown $1:$1 /bin/cee
        chmod 555 /bin/cee

        ##cee++
        printf '#!/bin/bash 
        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi

        ff=$home/programming/C++/$1
        FILE=$home/programming/C++/$1/$1.cpp
        if [[ -d "$ff" ]]; then
            cd "$home/programming/C++/$1"
        else
            mkdir -p "$home/programming/C++/$1" || {>&2 echo "Error : Cannot create new directory."; exit 1;}
            cd "$home/programming/C++/$1"
        fi


        if [[ -f "$FILE" ]]; then
            %s "$1.cpp" &
        else
                touch "$1.cpp"
                echo "/*" >> "$1.cpp"
                echo "*" >> "$1.cpp"
                echo "*	Author : $(whoami)"' $editor  > /bin/cee++
                printf ' >> "$1.cpp"
                echo "*" >> "$1.cpp"
                distro_name=$(lsb_release -si)
        distro_version=$(lsb_release -sr)
        arch=$(uname -m)
        echo "*	OS : $distro_name $distro_version $arch" >> "$1.cpp"
                
                
                echo "*" >> "$1.cpp"
            echo "*	Date : $(date "+%%d-%%b-%%Y")" >> "$1.cpp"
                echo "*" >> "$1.cpp"
                echo "*/" >> "$1.cpp"
                echo "#include <iostream>" >> "$1.cpp"
                echo "using namespace std;" >> "$1.cpp"
                echo "int main(int argc,char** argv){" >> "$1.cpp"
                echo "" >> "$1.cpp"
                echo "	return 0;" >> "$1.cpp"
                echo "}" >> "$1.cpp"
                %s "$1.cpp" &
        fi' $editor >>/bin/cee++
        chown $1:$1 /bin/cee++
        chmod 555 /bin/cee++


        ##runc
        printf '#!/bin/bash

        # Function to display usage information
        usage() {
            echo "Usage: runc <project name> [-c <gcc options as string "options in one string in double quotes">] [-e <executable arguments as string "arguments in one string in double quotes">] [-h]"

        }

        # Check if the number of arguments is correct
        if [ "$#" -lt 1 ]; then
            usage; exit 1
        fi

        # Default values
        gcc_options=""
        executable_arguments=""

        # Parse command-line arguments
        while [ "$#" -gt 0 ]; do
            case "$1" in
                -c)
                    shift
                    gcc_options="$1"
                    ;;
                -e)
                    shift
                    executable_arguments="$1"
                    ;;
                -h)
                    usage
                    exit 0
                    ;;
                *)
                    script_name="$1"
                    ;;
            esac
            shift
        done

        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi


        # Change to the C script directory
        cd "$home/programming/C/$script_name" || { >&2 echo "Error: Directory does not exist."; exit 1; }

        s1=$(date +%%s.%%N)

        # Compile the C script with additional options
        gcc "$script_name.c" $gcc_options -o "$script_name" || {>&2 echo "Error: Compilation failed.";usage; exit 1; }

        e1=$(date +%%s.%%N)
        t1=$(echo "$e1 - $s1" | bc -l)
        echo ""

        s2=$(date +%%s.%%N)

        # Execute the compiled program with provided arguments
        ./$script_name $executable_arguments
        status=$?

        e2=$(date +%%s.%%N)
        t2=$(echo "$e2 - $s2" | bc -l)
        echo ""

        # Get the number of columns in the terminal
        col=$(tput cols)

        # Construct the pattern
        pattern=""
        for ((i = 0; i < col; i++)); do
            pattern+="═"
        done

        # Print the pattern
        echo "$pattern"
        echo " status code :  $status "
        echo " compiled in $t1 s"
        echo "  executed in $t2 s"
        echo "$pattern"

        # Clean up
        rm "$script_name" || {>&2 echo "Error: Unable to remove compiled executable."; exit 1; }
        ' >/bin/runc
        chown $1:$1 /bin/runc
        chmod 555 /bin/runc






        ##runc++
        printf '#!/bin/bash

        # Function to display usage information
        usage() {
            echo "Usage: runc++ <project name> [-c <g++ options as string "options in one string in double quotes">] [-e <executable arguments as string "arguments in one string in double quotes">] [-h]"

        }

        # Check if the number of arguments is correct
        if [ "$#" -lt 1 ]; then
            usage; exit 1
        fi

        # Default values
        gpp_options=""
        executable_arguments=""

        # Parse command-line arguments
        while [ "$#" -gt 0 ]; do
            case "$1" in
                -c)
                    shift
                    gpp_options="$1"
                    ;;
                -e)
                    shift
                    executable_arguments="$1"
                    ;;
                -h)
                    usage
                    exit 0
                    ;;
                *)
                    script_name="$1"
                    ;;
            esac
            shift
        done

        if [ $(whoami) = "root" ]; then
            home="/root"
        else
            home="/home/$(whoami)"
        fi


        # Change to the C++ script directory
        cd "$home/programming/C++/$script_name" || { >&2 echo "Error: Directory does not exist."; exit 1; }

        s1=$(date +%%s.%%N)

        # Compile the C++ script with additional options
        gpp "$script_name.cpp" $gpp_options -o "$script_name" || {>&2 echo "Error: Compilation failed.";usage; exit 1; }

        e1=$(date +%%s.%%N)
        t1=$(echo "$e1 - $s1" | bc -l)
        echo ""

        s2=$(date +%%s.%%N)

        # Execute the compiled program with provided arguments
        ./$script_name $executable_arguments
        status=$?

        e2=$(date +%%s.%%N)
        t2=$(echo "$e2 - $s2" | bc -l)
        echo ""

        # Get the number of columns in the terminal
        col=$(tput cols)

        # Construct the pattern
        pattern=""
        for ((i = 0; i < col; i++)); do
            pattern+="═"
        done

        # Print the pattern
        echo "$pattern"
        echo " status code :  $status "
        echo " compiled in $t1 s"
        echo "  executed in $t2 s"
        echo "$pattern"

        # Clean up
        rm "$script_name" || {>&2 echo "Error: Unable to remove compiled executable."; exit 1; }
        ' >/bin/runc++
        chown $1:$1 /bin/runc++
        chmod 555 /bin/runc++


echo ""
printf 'Thank you %s for using progtools, progtools is a programming environment for beginners
the programming file structure is in %s/programming directory
more languages and ideas will be added in the future
cee : to edit C files with your favorite editor
asm : to edit assembly files with your favorite editor
py : to edit python3 files with your favorite editor
cee++ : to edit C++ files with your favorite editor
runc : to run your C project
runc++ : to run your C++ project
runa : to run your assembly project
runp : to run your python3 project' $1 $home
echo ""

	else
		>&2echo "syntax : progtools <user-name>" 
		>&2 echo "invalid username" 
	fi
else 
	>&2 echo "syntax : progtools <user-name>"
	>&2 echo "invalid number of arguments" 
fi
