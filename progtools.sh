#!/bin/bash

show_help() {
    echo "Usage: progtools <user name>"
    echo "*needs root permissions."

    
}

create_exe() {

            
    if [ "$#" -lt 2 ]; then
        {>&2 echo "Error : Few arguments to create() function."; return 2;}
    elif [ "$#" -gt 2 ]; then
        {>&2 echo "Error : Many arguments to create() function."; return 2;}
    
    fi

    directory=$1
    file_name=$2

    cd $directory || {>&2 echo "Error : Cannot find $directory"; return 1;}

    touch "$file_name" || {>&2 echo "Error : Cannot create new File : $file_name"; return 1;}

    chown $user_name:$user_name $file_name || {>&2 echo "Error : Cannot change ownership for : $file_name"; return 1;} 

    chmod 555 $file_name || {>&2 echo "Error : Cannot change permissions for : $file_name"; return 1;} 

}




fill_file() {

    if [ "$#" -lt 3 ]; then
        {>&2 echo "Error : Few arguments to fill_file() function."; return 2;}
    elif [ "$#" -gt 3 ]; then
        {>&2 echo "Error : Many arguments to fill_file() function."; return 2;}
    
    fi


    directory=$1
    file_name=$2
    string=$3

    create_directory $directory || return $?
    cd $directory
    if [[ -f "$file_name" ]]; then
        return 0
    else
        echo "$string" > $file_name || {>&2 echo "Error : Cannot write to : $file_name"; return 1;}
    fi
        
}


install_deps() {
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


}

user_name=$1

if [ $user_name = "root" ]; then
    programming_dir="/root/programming"
else
    programming_dir="/home/$user_name/programming"
fi



set_cee_content() {
cee_content="    #!/bin/bash 

    show_help() {
        echo \"Usage: \$0 [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add <filename>        Add a new C file with a default template and open it\"
        echo \"  --add-file <filename>   Add and open file\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"cee project1 : will create project \\\"project1\\\", and open main file \\\"project1.c\\\" using file editor.\"
        echo \"cee project1 --add test : will create a new c file called \\\"test.c\\\" in the \\\"project1\\\" directory, using default C template, then use editor to open the file.\"
        echo \"cee project1 --add-file test.h : will create a new file called \\\"test.h\\\" in the \\\"project1\\\" directory, then use editor to open the file.\"
        echo \"cee project1 -o test.h : will open file \\\"test.h\\\" if exists, using text editor.\"

        
    }
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    open() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to open() function.\"; return 1;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to open() function.\"; return 1;}
            
            fi

            directory=\$1
            file_name=\$2

            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else 
                create \$directory \$file_name ||  return \$?
            fi
            
            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                $editor \"\$file_name\" & 
               #^^^^
            else
                create \$directory \$file_name || return \$?
                $editor \"\$file_name\" & 
               #^^^^    
            fi


    }

    create() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
            
            fi

            directory=\$1
            file_name=\$2
        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi


            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                    touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
            fi


    }


 create_directory() {

                    
            if [ \"\$#\" -lt 1 ]; then
                {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
            elif [ \"\$#\" -gt 1 ]; then
                {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
            
            fi

            directory=\$1

        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi

    }

    fill_file() {

            if [ \"\$#\" -lt 3 ]; then
                {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
            elif [ \"\$#\" -gt 3 ]; then
                {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
            
            fi


            directory=\$1
            file_name=\$2
            string=\$3

            create_directory \$directory || return \$?
            cd \$directory
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
            fi
            
    }

    if [ \$(whoami) = \"root\" ]; then
        programming_dir=\"/root/programming/C\"
                                          #^
    else
        programming_dir=\"/home/\$(whoami)/programming/C\"
                                                    #^
    fi



    open_file() {
        open  \"\$programming_dir/\$1\" \$2 || return \$?
    }

    add() {
        create  \"\$programming_dir/\$1\" \$2 || return \$?
        open_file \$1 \$2 || return \$?
    }



    add_and_fill() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_main_template
        fill_file  \$directory \$file_name \"\$main_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

    add_and_fill2() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_c_template
        fill_file  \$directory \$file_name \"\$c_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

    set_c_template() {

       c_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$project_name
* 
*/
#include <stdio.h>

    \"
    }

    set_main_template() {
        
        
   main_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$project_name
* 
*/
#include <stdio.h>
int main(int argc,char** argv){

    return 0;
}

    \"

    }

    distro_name=\$(lsb_release -si)
    distro_version=\$(lsb_release -sr)
    arch=\$(uname -m)
    user=\$(whoami)
    date=\$(date \"+%d-%b-%Y\")

 




    # selected is to check if any project is selected (1 = false, 0 = true)
    # options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 
    selected=1
    options=1
    option=\"\"

   
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help; exit 0
                ;;
            --add)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    if [[ \$file_to_add == *.c ]]; then
                                          #^^
                        file_to_add=\"\${file_to_add%.c}\"  # Strip .c extension
                                                   #^^           #^^
                    fi

                    file_to_add=\$file_to_add.c
                                           #^^
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
                    exit 1
                fi
                ;;
            --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"addfile\"
                        shift;shift
                    fi

                    if [ \$selected -eq 0 ]; then
                        add \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add-file option requires a filename argument.\"
                    exit 1
                fi
                ;;

                -o|--open)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_open=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"open\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help
                    exit 1
                fi
                project_name=\"\$1\";
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                    elif  [ \$option = \"addfile\" ]; then
                        add \$project_name \$file_to_add || exit \$?
                    elif [ \$option = \"open\" ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_fill \$project_name \$project_name.c || exit \$?
                                                           #^^
                fi
                ;;
        esac
    done


    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



"

}


set_ceepp_content() {
ceepp_content="   #!/bin/bash 

    show_help() {
        echo \"Usage: \$0 [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add <filename>        Add a new C++ file with a default template and open it\"
        echo \"  --add-file <filename>   Add and open file\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"cee++ project1 : will create project \\\"project1\\\", and open main file \\\"project1.cpp\\\" using file editor.\"
        echo \"cee++ project1 --add test : will create a new c++ file called \\\"test.cpp\\\" in the \\\"project1\\\" directory, using default C++ template, then use editor to open the file.\"
        echo \"cee++ project1 --add-file test.h : will create a new file called \\\"test.h\\\" in the \\\"project1\\\" directory, then use editor to open the file.\"
        echo \"cee++ project1 -o test.h : will open file \\\"test.h\\\" if exists, using text editor.\"

        
    }
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    open() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to open() function.\"; return 1;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to open() function.\"; return 1;}
            
            fi

            directory=\$1
            file_name=\$2

            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else 
                create \$directory \$file_name ||  return \$?
            fi
            
            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                $editor \"\$file_name\" & 
               #^^^^
            else
                create \$directory \$file_name || return \$?
                $editor \"\$file_name\" & 
               #^^^^    
            fi


    }

    create() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
            
            fi

            directory=\$1
            file_name=\$2
        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi


            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                    touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
            fi


    }


 create_directory() {

                    
            if [ \"\$#\" -lt 1 ]; then
                {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
            elif [ \"\$#\" -gt 1 ]; then
                {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
            
            fi

            directory=\$1

        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi

    }

    fill_file() {

            if [ \"\$#\" -lt 3 ]; then
                {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
            elif [ \"\$#\" -gt 3 ]; then
                {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
            
            fi


            directory=\$1
            file_name=\$2
            string=\$3

            create_directory \$directory || return \$?
            cd \$directory
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
            fi
            
    }

    if [ \$(whoami) = \"root\" ]; then
        programming_dir=\"/root/programming/C++\"
                                          #^^^
    else
        programming_dir=\"/home/\$(whoami)/programming/C++\"
                                                    #^^^
    fi



    open_file() {
        open  \"\$programming_dir/\$1\" \$2 || return \$?
    }

    add() {
        create  \"\$programming_dir/\$1\" \$2 || return \$?
        open_file \$1 \$2 || return \$?
    }



    add_and_fill() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_main_template
        fill_file  \$directory \$file_name \"\$main_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

    add_and_fill2() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_cpp_template
        fill_file  \$directory \$file_name \"\$cpp_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

    set_cpp_template() {

       cpp_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$project_name
* 
*/
#include <iostream>
using namespace std;

    \"
    }

    set_main_template() {
        
        
   main_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$project_name
* 
*/
#include <iostream>
using namespace std;
int main(int argc,char** argv){

	return 0;
}
    \"

    }

    distro_name=\$(lsb_release -si)
    distro_version=\$(lsb_release -sr)
    arch=\$(uname -m)
    user=\$(whoami)
    date=\$(date \"+%d-%b-%Y\")

 




    # selected is to check if any project is selected (1 = false, 0 = true)
    # options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 
    selected=1
    options=1
    option=\"\"

    
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help; exit 0
                ;;
            --add)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    if [[ \$file_to_add == *.cpp ]]; then
                                          #^^^^
                        file_to_add=\"\${file_to_add%.cpp}\"  # Strip .cpp extension
                                                   #^^^           #^^^^
                    fi

                    file_to_add=\$file_to_add.cpp
                                           #^^^^
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
                    exit 1
                fi
                ;;
            --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"addfile\"
                        shift;shift
                    fi

                    if [ \$selected -eq 0 ]; then
                        add \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add-file option requires a filename argument.\"
                    exit 1
                fi
                ;;

                -o|--open)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_open=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"open\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help
                    exit 1
                fi
                project_name=\"\$1\";
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                    elif  [ \$option = \"addfile\" ]; then
                        add \$project_name \$file_to_add || exit \$?
                    elif [ \$option = \"open\" ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_fill \$project_name \$project_name.cpp || exit \$?
                                                           #^^^^
                fi
                ;;
        esac
    done


    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^








"

}





set_asm_content() {
asm_content="
   #!/bin/bash 

    show_help() {
        echo \"Usage: \$0 [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add <filename>        Add a new asm file with a default template and open it\"
        echo \"  --add-file <filename>   Add and open file\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"asm project1 : will create project \\\"project1\\\", and open main file \\\"project1.asm\\\" using file editor.\"
        echo \"asm project1 --add test : will create a new asm file called \\\"test.asm\\\" in the \\\"project1\\\" directory, using default asm template, then use editor to open the file.\"
        echo \"asm project1 --add-file test.h : will create a new file called \\\"test.h\\\" in the \\\"project1\\\" directory, then use editor to open the file.\"
        echo \"asm project1 -o test.h : will open file \\\"test.h\\\" if exists, using text editor.\"

        
    }
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    open() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to open() function.\"; return 1;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to open() function.\"; return 1;}
            
            fi

            directory=\$1
            file_name=\$2

            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else 
                create \$directory \$file_name ||  return \$?
            fi
            
            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                $editor \"\$file_name\" & 
               #^^^^
            else
                create \$directory \$file_name || return \$?
                $editor \"\$file_name\" & 
               #^^^^    
            fi


    }

    create() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
            
            fi

            directory=\$1
            file_name=\$2
        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi


            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                    touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
            fi


    }


 create_directory() {

                    
            if [ \"\$#\" -lt 1 ]; then
                {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
            elif [ \"\$#\" -gt 1 ]; then
                {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
            
            fi

            directory=\$1

        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi

    }

    fill_file() {

            if [ \"\$#\" -lt 3 ]; then
                {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
            elif [ \"\$#\" -gt 3 ]; then
                {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
            
            fi


            directory=\$1
            file_name=\$2
            string=\$3

            create_directory \$directory || return \$?
            cd \$directory
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
            fi
            
    }

    if [ \$(whoami) = \"root\" ]; then
        programming_dir=\"/root/programming/asm\"
                                          #^^^
    else
        programming_dir=\"/home/\$(whoami)/programming/asm\"
                                                    #^^^
    fi



    open_file() {
        open  \"\$programming_dir/\$1\" \$2 || return \$?
    }

    add() {
        create  \"\$programming_dir/\$1\" \$2 || return \$?
        open_file \$1 \$2 || return \$?
    }



    add_and_fill() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_main_template
        fill_file  \$directory \$file_name \"\$main_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

    add_and_fill2() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_asm_template
        fill_file  \$directory \$file_name \"\$asm_template\" || return \$?
        open_file \$1 \$2 || return \$?
    }

set_asm_template() {

       
asm_template=\"; Author : \$user
; OS : \$distro_name \$distro_version \$arch
; Date : \$date
; Project Name : \$project_name

section .text

section .data\"


    }

    set_main_template() {

 main_template=\"; Author : \$user
; OS : \$distro_name \$distro_version \$arch
; Date : \$date
; Project Name : \$project_name
global _start
section .text
end:
mov \$register1,\$syscallid
mov \$register2,0
\$call
_start:


jmp end
section .data\"
        
        
    }


    distro_name=\$(lsb_release -si)
    distro_version=\$(lsb_release -sr)
    arch=\$(uname -m)
    user=\$(whoami)
    date=\$(date \"+%d-%b-%Y\")
    # Check system architecture
    if [ \"\$arch\" == \"x86_64\" ]; then
        register1=\"rax\"
        register2=\"rdi\"
        syscallid=\"60\"
        call=\"syscall\"
    elif [ \"\$arch\" == \"i386\" ]  || [ \"\$arch\" == \"i686\" ]; then
        register1=\"eax\"
        register2=\"ebx\"
        syscallid=\"1\"
        call=\"int 0x80\"
    else
        >&2 echo \"Error: Unsupported arch.\"
        exit 1
    fi



    




    # selected is to check if any project is selected (1 = false, 0 = true)
    # options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 
    selected=1
    options=1
    option=\"\"

    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help; exit 0
                ;;
            --add)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    if [[ \$file_to_add == *.asm ]]; then
                                          #^^^^
                        file_to_add=\"\${file_to_add%.asm}\"  # Strip .asm extension
                                                   #^^^           #^^^^
                    fi

                    file_to_add=\$file_to_add.asm
                                           #^^^^
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
                    exit 1
                fi
                ;;
            --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"addfile\"
                        shift;shift
                    fi

                    if [ \$selected -eq 0 ]; then
                        add \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add-file option requires a filename argument.\"
                    exit 1
                fi
                ;;

                -o|--open)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_open=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"open\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help
                    exit 1
                fi
                project_name=\"\$1\";
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_fill2 \$project_name \$file_to_add || exit \$?
                    elif  [ \$option = \"addfile\" ]; then
                        add \$project_name \$file_to_add || exit \$?
                    elif [ \$option = \"open\" ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_fill \$project_name \$project_name.asm || exit \$?
                                                           #^^^^
                fi
                ;;
        esac
    done


    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^








"

}


set_bscript_content() {
bscript_content="   #!/bin/bash 

    show_help() {
        echo \"Usage: \$0 [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add <filename>        Add a new bash script file with a default template and open it\"
        echo \"  --add-file <filename>   Add and open file\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"bscript project1 : will create project \\\"project1\\\", and open main file \\\"project1.sh\\\" using file editor.\"
        echo \"bscript project1 --add test : will create a new bash script file called \\\"test.sh\\\" in the \\\"project1\\\" directory, using default bash template, then use editor to open the file.\"
        echo \"bscript project1 --add-file test.h : will create a new file called \\\"test.h\\\" in the \\\"project1\\\" directory, then use editor to open the file.\"
        echo \"bscript project1 -o test.h : will open file \\\"test.h\\\" if exists, using text editor.\"

        
    }
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    open() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to open() function.\"; return 1;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to open() function.\"; return 1;}
            
            fi

            directory=\$1
            file_name=\$2

            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else 
                create \$directory \$file_name ||  return \$?
            fi
            
            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                $editor \"\$file_name\" & 
               #^^^^
            else
                create \$directory \$file_name || return \$?
                $editor \"\$file_name\" & 
               #^^^^    
            fi


    }

    create() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
            
            fi

            directory=\$1
            file_name=\$2
        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi


            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                    touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
            fi


    }


 create_directory() {

                    
            if [ \"\$#\" -lt 1 ]; then
                {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
            elif [ \"\$#\" -gt 1 ]; then
                {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
            
            fi

            directory=\$1

        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi

    }

    fill_file() {

            if [ \"\$#\" -lt 3 ]; then
                {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
            elif [ \"\$#\" -gt 3 ]; then
                {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
            
            fi


            directory=\$1
            file_name=\$2
            string=\$3

            create_directory \$directory || return \$?
            cd \$directory
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
            fi
            
    }

    if [ \$(whoami) = \"root\" ]; then
        programming_dir=\"/root/programming/bash\"
                                          #^^^
    else
        programming_dir=\"/home/\$(whoami)/programming/bash\"
                                                    #^^^
    fi



    open_file() {
        open  \"\$programming_dir/\$1\" \$2 || return \$?
    }

    add() {
        create  \"\$programming_dir/\$1\" \$2 || return \$?
        open_file \$1 \$2 || return \$?
    }



    add_and_fill() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_bash_template
        fill_file  \$directory \$file_name \"\$bash_template\" || return \$?
        cd \$directory || return \$?
        chmod u+x \$file_name || return \$?
        open_file \$1 \$2 || return \$?
    }


set_bash_template() {

bash_template=\"#!/bin/bash
# Author : \$user
# OS : \$distro_name \$distro_version \$arch
# Date : \$date
# Project Name : \$project_name




\"

}


    distro_name=\$(lsb_release -si)
    distro_version=\$(lsb_release -sr)
    arch=\$(uname -m)
    user=\$(whoami)
    date=\$(date \"+%d-%b-%Y\")



    




    # selected is to check if any project is selected (1 = false, 0 = true)
    # options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 
    selected=1
    options=1
    option=\"\"

    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help; exit 0
                ;;
            --add)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    if [[ \$file_to_add == *.sh ]]; then
                                          #^^^^
                        file_to_add=\"\${file_to_add%.sh}\"  # Strip .sh extension
                                                   #^^^           #^^^^
                    fi

                    file_to_add=\$file_to_add.sh
                                           #^^^^
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_fill \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
                    exit 1
                fi
                ;;
            --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"addfile\"
                        shift;shift
                    fi

                    if [ \$selected -eq 0 ]; then
                        add \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add-file option requires a filename argument.\"
                    exit 1
                fi
                ;;

                -o|--open)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_open=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"open\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help
                    exit 1
                fi
                project_name=\"\$1\";
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_fill \$project_name \$file_to_add || exit \$?
                    elif  [ \$option = \"addfile\" ]; then
                        add \$project_name \$file_to_add || exit \$?
                    elif [ \$option = \"open\" ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_fill \$project_name \$project_name.sh || exit \$?
                                                           #^^^^
                fi
                ;;
        esac
    done


    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^








"

}




set_py_content() {
    py_content="   #!/bin/bash 

    show_help() {
        echo \"Usage: \$0 [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add <filename>        Add a new python file with a default template and open it\"
        echo \"  --add-file <filename>   Add and open file\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"bscript project1 : will create project \\\"project1\\\", and open main file \\\"project1.py\\\" using file editor.\"
        echo \"bscript project1 --add test : will create a new python file called \\\"test.py\\\" in the \\\"project1\\\" directory, using default python template, then use editor to open the file.\"
        echo \"bscript project1 --add-file test.h : will create a new file called \\\"test.h\\\" in the \\\"project1\\\" directory, then use editor to open the file.\"
        echo \"bscript project1 -o test.h : will open file \\\"test.h\\\" if exists, using text editor.\"

        
    }
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    open() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to open() function.\"; return 1;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to open() function.\"; return 1;}
            
            fi

            directory=\$1
            file_name=\$2

            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else 
                create \$directory \$file_name ||  return \$?
            fi
            
            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                $editor \"\$file_name\" & 
               #^^^^
            else
                create \$directory \$file_name || return \$?
                $editor \"\$file_name\" & 
               #^^^^    
            fi


    }

    create() {

                    
            if [ \"\$#\" -lt 2 ]; then
                {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
            elif [ \"\$#\" -gt 2 ]; then
                {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
            
            fi

            directory=\$1
            file_name=\$2
        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi


            #try to create or open the file 
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                    touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
            fi


    }


 create_directory() {

                    
            if [ \"\$#\" -lt 1 ]; then
                {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
            elif [ \"\$#\" -gt 1 ]; then
                {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
            
            fi

            directory=\$1

        
            #try to create or open the Directory
            if [[ -d \"\$directory\" ]]; then
                cd \"\$directory\"
            else
                mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
                cd \"\$directory\"
            fi

    }

    fill_file() {

            if [ \"\$#\" -lt 3 ]; then
                {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
            elif [ \"\$#\" -gt 3 ]; then
                {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
            
            fi


            directory=\$1
            file_name=\$2
            string=\$3

            create_directory \$directory || return \$?
            cd \$directory
            if [[ -f \"\$file_name\" ]]; then
                return 0
            else
                echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
            fi
            
    }

    if [ \$(whoami) = \"root\" ]; then
        programming_dir=\"/root/programming/python\"
                                          #^^^
    else
        programming_dir=\"/home/\$(whoami)/programming/python\"
                                                    #^^^
    fi



    open_file() {
        open  \"\$programming_dir/\$1\" \$2 || return \$?
    }

    add() {
        create  \"\$programming_dir/\$1\" \$2 || return \$?
        open_file \$1 \$2 || return \$?
    }



    add_and_fill() {
        directory=\"\$programming_dir/\$1\"
        file_name=\$2
        set_python_template
        fill_file  \$directory \$file_name \"\$python_template\" || return \$?
        cd \$directory || return \$?
        chmod u+x \$file_name || return \$?
        open_file \$1 \$2 || return \$?
    }


set_python_template() {

python_template=\"# Author : \$user
# OS : \$distro_name \$distro_version \$arch
# Date : \$date
# Project Name : \$project_name

if __name__ == \"__main__\":
    

\"

}


    distro_name=\$(lsb_release -si)
    distro_version=\$(lsb_release -sr)
    arch=\$(uname -m)
    user=\$(whoami)
    date=\$(date \"+%d-%b-%Y\")



    




    # selected is to check if any project is selected (1 = false, 0 = true)
    # options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 
    selected=1
    options=1
    option=\"\"

    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help; exit 0
                ;;
            --add)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    if [[ \$file_to_add == *.py ]]; then
                                          #^^^^
                        file_to_add=\"\${file_to_add%.py}\"  # Strip .py extension
                                                   #^^^           #^^^^
                    fi

                    file_to_add=\$file_to_add.py
                                           #^^^^
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_fill \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
                    exit 1
                fi
                ;;
            --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"addfile\"
                        shift;shift
                    fi

                    if [ \$selected -eq 0 ]; then
                        add \$project_name \$file_to_add || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: --add-file option requires a filename argument.\"
                    exit 1
                fi
                ;;

                -o|--open)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_open=\"\$2\"
                    
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"open\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help
                    exit 1
                fi
                project_name=\"\$1\";
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_fill \$project_name \$file_to_add || exit \$?
                    elif  [ \$option = \"addfile\" ]; then
                        add \$project_name \$file_to_add || exit \$?
                    elif [ \$option = \"open\" ]; then
                        open_file \$project_name \$file_to_open || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_fill \$project_name \$project_name.py || exit \$?
                                                           #^^^^
                fi
                ;;
        esac
    done


    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^









"

}


set_runc_content() {

    runc_content="
    #!/bin/bash

show_help() {
    echo \"Usage: runc [options] <project_name>\"
    echo \"Options:\"
    echo \"  -h, --help              Show this help message.\"
    echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the project elf, providing the arguments to the elf file.\"
    echo \"  -c, --gcc_options <gcc options as a string> Run the compile and run project\"
    echo \"Examples:\"
    echo \"runc project1 --args \\\"arg1 arg2 ... argn\\\" --gcc-options \\\"-pthread -g\\\": will run the elf file, and provide the arguments to the elf file.\"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

compile() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to compile() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to compile() function.\"; return 2;}
    fi
    
    project_name=\$1
    gcc_options=\$2
   #^^^
    cd \"\$programming_dir\"
    start_time=\$(date +%s.%N)
    gcc -o \$project_name *.c \$gcc_options || return \$?
   #^^^                   ^^  ^^^
    finish_time=\$(date +%s.%N)
    compile_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
}

execute() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to execute() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to execute() function.\"; return 2;}
    fi
    project_name=\$1
    arguments=\$2
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [[ -f \"\$project_name\" ]]; then
        start_time=\$(date +%s.%N)
        ./\$project_name \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)
    
    else
        compile || return \$?
        if [[ -f \"\$project_name\" ]]; then
            start_time=\$(date +%s.%N)
            ./\$project_name \$arguments
            status_code=\$?
            finish_time=\$(date +%s.%N)
        else
            return 1
        fi
        
    
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done

    # Print the pattern
    echo \"\$pattern\"
    echo \" status code :  \$status_code \"
    echo \" compiled in \$compile_time s\"
    echo \"  executed in \$execute_time s\"
    echo \"\$pattern\"

    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove compiled executable.\"; exit 1; }
        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 5 ]; then
    show_help; exit 1
fi


# Default values
gcc_options=\"\"
#^^
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help; exit 0
        ;;
        -a|--args)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                arguments=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --args option requires a string argument.\"
                exit 1
            fi
            ;;
        -c|--gcc_options)
            #^^^
            if [ -n \"\$2\" ]; then
                    
                #Get options
                gcc_options=\"\$2\"
               #^^^
                shift 2
            else
                >&2 echo \"Error: --gcc_options option requires a string argument.\"
                                  #^^^
                exit 1
            fi
            ;;
        *)
            if [ \$selected -eq 0 ]; then
                show_help
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
    shift
done

# Get programming directory
if [ \$(whoami) = \"root\" ]; then
    programming_dir=\"/root/programming/C/\$project_name\"
                                      #^
else
    programming_dir=\"/home/\$(whoami)/programming/C/\$project_name\"
                                                #^
fi

compile \"\$project_name\" \"\$gcc_options\" ||  exit \$?
                         #^^^
execute \"\$project_name\" \"\$arguments\" 



            


    "
}

set_runcpp_content(){

    runcpp_content="
        #!/bin/bash

show_help() {
    echo \"Usage: runc++ [options] <project_name>\"
    echo \"Options:\"
    echo \"  -h, --help              Show this help message.\"
    echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the project elf, providing the arguments to the elf file.\"
    echo \"  -c, --gpp_options <g++ options as a string> Run the compile and run project\"
    echo \"Examples:\"
    echo \"runc++ project1 --args \\\"arg1 arg2 ... argn\\\" --gpp-options \\\"-pthread -g\\\": will run the elf file, and provide the arguments to the elf file.\"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

compile() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to compile() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to compile() function.\"; return 2;}
    fi
    
    project_name=\$1
    gpp_options=\$2
   #^^^
    cd \"\$programming_dir\"
    start_time=\$(date +%s.%N)
    g++ -o \$project_name *.cpp \$gpp_options || return \$?
   #^^^                   ^^  ^^^
    finish_time=\$(date +%s.%N)
    compile_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
}

execute() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to execute() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to execute() function.\"; return 2;}
    fi
    project_name=\$1
    arguments=\$2
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [[ -f \"\$project_name\" ]]; then
        start_time=\$(date +%s.%N)
        ./\$project_name \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)
    
    else
        compile || return \$?
        if [[ -f \"\$project_name\" ]]; then
            start_time=\$(date +%s.%N)
            ./\$project_name \$arguments
            status_code=\$?
            finish_time=\$(date +%s.%N)
        else
            return 1
        fi
        
    
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done

    # Print the pattern
    echo \"\$pattern\"
    echo \" status code :  \$status_code \"
    echo \" compiled in \$compile_time s\"
    echo \"  executed in \$execute_time s\"
    echo \"\$pattern\"

    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove compiled executable.\"; exit 1; }
        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 5 ]; then
    show_help; exit 1
fi


# Default values
gpp_options=\"\"
#^^
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help; exit 0
        ;;
        -a|--args)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                arguments=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --args option requires a string argument.\"
                exit 1
            fi
            ;;
        -c|--gpp_options)
            #^^^
            if [ -n \"\$2\" ]; then
                    
                #Get options
                gpp_options=\"\$2\"
               #^^^
                shift 2
            else
                >&2 echo \"Error: --gpp_options option requires a string argument.\"
                                  #^^^
                exit 1
            fi
            ;;
        *)
            if [ \$selected -eq 0 ]; then
                show_help
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
    shift
done

# Get programming directory
if [ \$(whoami) = \"root\" ]; then
    programming_dir=\"/root/programming/C++/\$project_name\"
                                      #^
else
    programming_dir=\"/home/\$(whoami)/programming/C++/\$project_name\"
                                                #^
fi

compile \"\$project_name\" \"\$gpp_options\" ||  exit \$?
                         #^^^
execute \"\$project_name\" \"\$arguments\" 



            


    "
}




set_runp_content() {

    runp_content="
    #!/bin/bash

show_help() {
    echo \"Usage: runp [options] <project_name>\"
    echo \"Options:\"
    echo \"  -h, --help              Show this help message.\"
    echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the main python file, providing the arguments to the python file.\"
    echo \"Examples:\"
    echo \"runp project1 --args \\\"arg1 arg2 ... argn\\\" : will execute the python file using python3, and provide the arguments to the python file.\"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

execute() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to execute() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to execute() function.\"; return 2;}
    fi
    project_name=\$1
    arguments=\$2
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [[ -f \"\$project_name.py\" ]]; then
        start_time=\$(date +%s.%N)
        python3 \$project_name.py \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)    
    else
        return 1
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done

    # Print the pattern
    echo \"\$pattern\"
    echo \" status code :  \$status_code \"
    echo \"  executed in \$execute_time s\"
    echo \"\$pattern\"

        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 3 ]; then
    show_help; exit 1
fi


# Default values
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help; exit 0
        ;;
        -a|--args)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                arguments=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --args option requires a string argument.\"
                exit 1
            fi
            ;;
        *)
            if [ \$selected -eq 0 ]; then
                show_help
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
    shift
done

# Get programming directory
if [ \$(whoami) = \"root\" ]; then
    programming_dir=\"/root/programming/python/\$project_name\"
                                      #^
else
    programming_dir=\"/home/\$(whoami)/programming/python/\$project_name\"
                                                #^
fi


execute \"\$project_name\" \"\$arguments\" 



            

"

}


set_runa_content() {

    runa_content="
    #!/bin/bash

show_help() {
    echo \"Usage: runa [options] <project_name>\"
    echo \"Options:\"
    echo \"  -h, --help      Show this help message.\"
    echo \"  -a, --args  <arguments as one string, in double or single quotes>       Execute the project elf, providing the arguments to the elf file.\"
    echo \"  -n, --nasm_options <nasm options as a string>       Set nasm options\"
    echo \"  -l, --ld_options <ld options as a string>       Link object files\"
    
    echo \"Examples:\"
    echo \"runa project1 --args \\\"arg1 arg2 ... argn\\\" --ld-options \\\"--option1 --option2\\\" --nasm-options \\\"--option1 --option2\\\": will run the elf file, and provide the arguments to the elf file, and set ld and nasm options.\"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

assemble() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to assemble() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to assemble() function.\"; return 2;}
    fi
    
    project_name=\$1
    nasm_options=\$2
   #^^^
    cd \"\$programming_dir\"
    start_time=\$(date +%s.%N)
    
    for file in *.asm; do
        nasm -f \$file_type \$file \$nasm_options || { >&2 echo \"Error: assembling error.\"; exit 1; }
    done
   
   #^^^                   ^^  ^^^
    finish_time=\$(date +%s.%N)
    assemble_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
}


link() {
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to link() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to link() function.\"; return 2;}
    fi
    
    project_name=\$1
    ld_options=\$2
   #^^^
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [ \"\$#\" -eq 2 ]; then 
        if [ -z \$2 ]; then
            start_time=\$(date +%s.%N)
            ld -m \"\$emulation\" -o \$1 *.o || return \$?
            finish_time=\$(date +%s.%N)
        else
            start_time=\$(date +%s.%N)
            ld -m \"\$emulation\" -o \$1 *.o \"\$ld_options\" || return \$?
            # add double quotes here
            finish_time=\$(date +%s.%N)
        fi
    else
        start_time=\$(date +%s.%N)
        ld -m \"\$emulation\" -o \$1 *.o || return \$?
        finish_time=\$(date +%s.%N)
    
    fi 


    link_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    


}

execute() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to execute() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to execute() function.\"; return 2;}
    fi
    project_name=\$1
    arguments=\$2

    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [[ -f \"\$project_name\" ]]; then
        start_time=\$(date +%s.%N)
        ./\$project_name \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)
    
    else
        return 1
    fi
        
    
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done

    # Print the pattern
    echo \"\$pattern\"
    echo \" status code :  \$status_code \"
    echo \" assembled in \$assemble_time s\"
    echo \" linked in \$link_time s\"
    echo \"  executed in \$execute_time s\"
    echo \"\$pattern\"

    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove elf file.\"; exit 1; }
        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 7 ]; then
    show_help; exit 1
fi


# Default values
nasm_options=\"\"
#^^^
ld_options=\"\"
#^
arguments=\"\"
selected=1

arch=\$(uname -m)

# Check system architecture
if [ \"\$arch\" == \"x86_64\" ]; then
    file_type=\"elf64\"
    emulation=elf_x86_64
elif [ \"\$arch\" == \"i386\" ] || [ \"\$arch\" == \"i686\" ]; then
    file_type=\"elf32\"
    emulation=elf_i386
else
    >&2 echo \"Error: Unsupported arch.\"
    exit 1
fi



# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help; exit 0
        ;;
        -a|--args)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                arguments=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --args option requires a string argument.\"
                exit 1
            fi
            ;;
        -n|--nasm_options)
            #^^^
            if [ -n \"\$2\" ]; then
                    
                #Get options
                nasm_options=\"\$2\"
               #^^^
                shift 2
            else
                >&2 echo \"Error: --nasm_options option requires a string argument.\"
                                  #^^^
                exit 1
            fi
            ;;

        -l|--ld_options)
            #^^^
            if [ -n \"\$2\" ]; then
                    
                #Get options
                ld_options=\"\$2\"
               #^^^
                shift 2
            else
                >&2 echo \"Error: --ld_options option requires a string argument.\"
                                  #^^^
                exit 1
            fi
            ;;

        *)
            if [ \$selected -eq 0 ]; then
                show_help
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
    shift
done

# Get programming directory
if [ \$(whoami) = \"root\" ]; then
    programming_dir=\"/root/programming/asm/\$project_name\"
                                      #^
else
    programming_dir=\"/home/\$(whoami)/programming/asm/\$project_name\"
                                                #^
fi

assemble \"\$project_name\" \"\$nasm_options\" ||  exit \$?
                         #^^^
link \"\$project_name\" \"\$ld_options\" ||  exit \$?
                         #^^^

execute \"\$project_name\" \"\$arguments\" 



            




    "

}

set_runb_content(){

    runb_content="
    #!/bin/bash

show_help() {
    echo \"Usage: runb [options] <project_name>\"
    echo \"Options:\"
    echo \"  -h, --help              Show this help message.\"
    echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the main bash file, providing the arguments to the script.\"
    echo \"Examples:\"
    echo \"runb project1 --args \\\"arg1 arg2 ... argn\\\" : will execute the script, and provide the arguments to the script.\"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

execute() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to execute() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to execute() function.\"; return 2;}
    fi
    project_name=\$1
    arguments=\$2
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    if [[ -f \"\$project_name.sh\" ]]; then
        start_time=\$(date +%s.%N)
        ./\$project_name.sh \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)    
    else
        return 1
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done

    # Print the pattern
    echo \"\$pattern\"
    echo \" status code :  \$status_code \"
    echo \"  executed in \$execute_time s\"
    echo \"\$pattern\"

        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 3 ]; then
    show_help; exit 1
fi


# Default values
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help; exit 0
        ;;
        -a|--args)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                arguments=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --args option requires a string argument.\"
                exit 1
            fi
            ;;
        *)
            if [ \$selected -eq 0 ]; then
                show_help
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done

# Get programming directory
if [ \$(whoami) = \"root\" ]; then
    programming_dir=\"/root/programming/bash/\$project_name\"
                                      #^
else
    programming_dir=\"/home/\$(whoami)/programming/bash/\$project_name\"
                                                #^
fi


execute \"\$project_name\" \"\$arguments\" 



            


    "

}

if [ "$#" -eq 1 ]; then
	if id -u $1 >/dev/null 2>&1; then
        install_deps      
    
        mkdir -p $home/programming/{C,C++,python,asm,bash}  

        chown $1:$1 $home/programming/{C,C++,python,asm,bash} 

        set_cee_content
        create_exe /bin cee || exit $?
        fill_file /bin cee $cee_content || exit $?
        
        set_ceepp_content
        create_exe /bin cee++ || exit $?
        fill_file /bin cee++ $ceepp_content || exit $?
        

        set_asm_content
        create_exe /bin asm || exit $?
        fill_file /bin asm $asm_content || exit $?
        

        set_py_content
        create_exe /bin py || exit $?
        fill_file /bin py $py_content || exit $?
        
        set_bscript_content
        create_exe /bin bscript || exit $?
        fill_file /bin bscript $bscript_content || exit $?

        set_runc_content
        create_exe /bin runc || exit $?
        fill_file /bin runc $runc_content || exit $?
        
        set_runcpp_content
        create_exe /bin runc++ || exit $?
        fill_file /bin runc++ $runcpp_content || exit $?
        

        set_runa_content
        create_exe /bin runa || exit $?
        fill_file /bin runa $runa_content || exit $?
        

        set_runp_content
        create_exe /bin runp || exit $?
        fill_file /bin runp $runp_content || exit $?
        
        set_runb_content
        create_exe /bin runb || exit $?
        fill_file /bin runb $runb_content || exit $?


                
      


       
        


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
		show_help
		>&2 echo "invalid username" 
	fi
else 
	show_help
	>&2 echo "invalid number of arguments" 
fi
