#!/bin/bash
# Author : user
# OS : Debian 12 x86_64
# Date : 24-Dec-2023
# Project Name : progtoolsV2.0


show_help() {
    echo "Usage: progtools <user name>"
    echo "*needs root permissions."
}

create_directory() {
            
    if [ "$#" -lt 1 ]; then
        {>&2 echo "Error : Few arguments to create_directory() function."; return 2;}
    elif [ "$#" -gt 1 ]; then
        {>&2 echo "Error : Many arguments to create_directory() function."; return 2;}
    
    fi

    directory=$1

    #try to create or open the Directory
    if [ -d "$directory" ]; then
        cd "$directory"
    else
        mkdir -p "$directory" || {>&2 echo "Error : Cannot create new directory : $directory"; return 1;}
        cd "$directory"
    fi

}

create() {
                
    if [ "$#" -lt 1 ]; then
        {>&2 echo "Error : Few arguments to create() function."; return 2;}
    elif [ "$#" -gt 1 ]; then
        {>&2 echo "Error : Many arguments to create() function."; return 2;}
    
    fi

    directory=$(dirname $1) 
    file_name=$(basename $1)

    #try to create or open the Directory
    if [ -d "$directory" ]; then
        cd "$directory"
    else
        create_directory "$directory" ||  return $?;
    fi

    #try to create or open the file 
    if [ -f "$file_name" ]; then
        return 0
    else
        touch "$file_name" || {>&2 echo "Error : Cannot create new File : $file_name"; return 1;}
    fi
}

create_exe() {

            
    if [ "$#" -lt 1 ]; then
        {>&2 echo "Error : Few arguments to create_exe() function."; return 2;}
    elif [ "$#" -gt 1 ]; then
        {>&2 echo "Error : Many arguments to create_exe() function."; return 2;}
    
    fi

    directory=$(dirname $1) 
    file_name=$(basename $1)

    #try to create or open the Directory
    if [ -d "$directory" ]; then
        cd "$directory"
    else
        create_directory "$directory" ||  return $?;
    fi

    #try to create or open the file 
    if [ -f "$file_name" ]; then
        return 0
    else
        touch "$file_name" || {>&2 echo "Error : Cannot create new File : $file_name"; return 1;}
    fi
    chown "$user_name:$user_name" "$file_name" || {>&2 echo "Error : Cannot change ownership for : $file_name"; return 1;} 

    chmod 555 "$file_name" || {>&2 echo "Error : Cannot change permissions for : $file_name"; return 1;} 

}

fill_file() {

    if [ "$#" -lt 2 ]; then
        {>&2 echo "Error : Few arguments to fill_file() function."; return 2;}
    elif [ "$#" -gt 2 ]; then
        {>&2 echo "Error : Many arguments to fill_file() function."; return 2;}
    
    fi

    path=$1
    directory=$(dirname $path) 
    file_name=$(basename $path)
    string=$2

    existdir=1

    if [ -d "$directory" ]; then
        existdir=0    
        cd "$directory"
    else 
        create "$path"  ||  return $?
    fi
    
    if [ -f "$file_name" ] && [ $existdir -eq 0 ] ; then
        if [ -s "$file_name" ]; then
            echo "$file_name is already exist, and have a size greater than 0!" >&2;return 0
        else
            echo "$string" > $file_name || {>&2 echo "Error : Cannot write to : $file_name"; return 1;}
        fi        
    else
        echo "$string" > $file_name || {>&2 echo "Error : Cannot write to : $file_name"; return 1;}
    fi
    
}


retry_vscode() {
    if [ -e /etc/os-release ]; then
    # Source the file to load variables
    . /etc/os-release
        # Check if the PRETTY_NAME variable contains "Kali"
        if [[ $PRETTY_NAME == *"Kali"* ]]; then
            editor=code-oss
            return 0
        fi
    fi
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg || return 5
    install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg || return 6
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' || return 7
    apt-get update || return 8
    apt-get install code || apt-get install code-insiders || return 9
    return 0
}

retry() {

    if [ "$#" -lt 1 ]; then
        {>&2 echo "Error : Few arguments to retry() function."; return 2;}
    elif [ "$#" -gt 1 ]; then
        {>&2 echo "Error : Many arguments to retry() function."; return 2;}
    
    fi

    editor=$1
    if [ -z $editor ]; then
        return 1
    elif [[ $editor == "vscode" ]]
        editor=code
        apt install $editor || retry_vscode
    else
        return 2
    fi
    
}

install_deps() {
  # List of popular text editors
    editors=("vim" "vscode" "gedit" "nano" "emacs")
    # Prompt the user to select a text editor
    PS3="Enter the number of your preferred text editor: "
    select editor in "${editors[@]}"; do
        if [ -n $editor ]; then
            echo "You selected: $editor"
            # Install the selected editor
            apt update || {>&2 echo "Apt error!"; return 1;}
            apt install -fy nasm php g++ gcc gdb python3 bc || {>&2 echo "Apt error!"; return 1;}  
	        apt install -fy  $editor || retry $editor || return $?
	    
            break
        else
            {>&2 echo "Invalid choice. Please enter a valid number."; return 1;}  # Exit the script with an error code
        fi
    done


}

set_cee_content() {
cee_content="#!/bin/bash

userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"cee\" \"main\" \$@

"

}


set_ceepp_content() {
ceepp_content="#!/bin/bash

userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"cee++\" \"main\" \$@


"

}


set_asm_content() {
asm_content="#!/bin/bash

userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"asm\" \"main\" \$@
"

}


set_bscript_content() {
bscript_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"bscript\" \"no-main\" \$@

"

}


set_py_content() {
    py_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"py\" \"main\" \$@
"

}

set_phpp_content() {
    phpp_content="#!/bin/bash

userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

decide \"phpp\" \"no-main\" \$@"

}

set_runc_content() {

    runc_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

compile() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to compile() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to compile() function.\"; return 2;}
    fi
    
    project_name=\$1
    gcc_options=\$2
   #^^^
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
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
    
    print_result \"runc\" \"\$status_code\" \"\$compile_time\" \"\$execute_time\"
    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove compiled executable.\"; exit 1; }
        
}


# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 5 ]; then
    show_help \"runc\"; exit 1
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
            show_help \"runc\"; exit 0
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
                show_help \"runc\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done
programming_dir=\"\$userhome/programming/C/\$project_name\"

compile \"\$project_name\" \"\$gcc_options\" ||  exit \$?
                         #^^^
execute \"\$project_name\" \"\$arguments\" 
"
}

set_runcpp_content(){

    runcpp_content="#!/bin/bash

userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

compile() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to compile() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to compile() function.\"; return 2;}
    fi
    
    project_name=\$1
    gpp_options=\$2
   #^^^
    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}
    start_time=\$(date +%s.%N)
    g++ -o \$project_name *.cpp \$gpp_options || return \$?
   #^^^                    ^^  ^^^
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
    
    print_result \"runc++\" \"\$status_code\" \"\$compile_time\" \"\$execute_time\"
                 #^^^^^^
    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove compiled executable.\"; exit 1; }
        
}



# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 5 ]; then
    show_help \"runc++\"; exit 1
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
            show_help \"runc++\"; exit 0
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
                show_help \"runc++\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done


programming_dir=\"\$userhome/programming/C++/\$project_name\"

compile \"\$project_name\" \"\$gpp_options\" ||  exit \$?
                         #^^^
execute \"\$project_name\" \"\$arguments\" 

    "
}




set_runpy_content() {

    runpy_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

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
        {>&2 echo \"Error : main file is missing: \$programming_dir/\$project_name.py\"; return 1;}
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    
    print_result \"runpy\" \"\$status_code\" \"\$execute_time\"
        
}


# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 3 ]; then
    show_help \"runpy\"; exit 1
fi


# Default values
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help \"runpy\"; exit 0
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
                show_help \"runpy\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done

# Get programming directory

programming_dir=\"\$userhome/programming/python/\$project_name\"


execute \"\$project_name\" \"\$arguments\" || exit \$?

"

}


set_runa_content() {

    runa_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

assemble() {
             
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to assemble() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to assemble() function.\"; return 2;}
    fi
    
    project_name=\$1
    nasm_options=\$2
    cd \"\$programming_dir\"
    start_time=\$(date +%s.%N)
    
    for file in *.asm; do
        nasm -f \$file_type \$file \$nasm_options || { >&2 echo \"Error: assembling error.\"; exit 1; }
    done
   
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

    print_result \"runa\" \"\$status_code\" \"\$assemble_time\" \"\$link_time\" \"\$execute_time\"

    # Clean up
    rm \"\$project_name\" || {>&2 echo \"Error: Unable to remove elf file.\"; exit 1; }
        
}





# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 7 ]; then
    show_help \"runa\"; exit 1
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
            show_help \"runa\"; exit 0
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
                show_help \"runa\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done

programming_dir=\"\$userhome/programming/asm/\$project_name\"

assemble \"\$project_name\" \"\$nasm_options\" ||  exit \$?
                         #^^^
link \"\$project_name\" \"\$ld_options\" ||  exit \$?
                         #^^^

execute \"\$project_name\" \"\$arguments\" 

    "

}

set_runb_content(){

    runb_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi



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
        chmod +x ./\$project_name.sh  
        start_time=\$(date +%s.%N)
        ./\$project_name.sh \$arguments
        status_code=\$?
        finish_time=\$(date +%s.%N)    
    else
        return 1
    fi
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    print_result \"runpy\" \"\$status_code\" \"\$execute_time\"
}


# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 3 ]; then
    show_help \"runb\"; exit 1
fi


# Default values
arguments=\"\"
selected=1




# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help \"runb\"; exit 0
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
                show_help \"runb\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift;

            ;;
    esac
done

# Get programming directory
programming_dir=\"\$userhome/programming/bash/\$project_name\"
                                      #^

execute \"\$project_name\" \"\$arguments\" 

    "

}
set_runphp_content(){

    runphp_content="#!/bin/bash
userhome=$user_home
common=\"\$userhome/progtools/common.sh\"
if [ -f \"\$common\" ]; then
    source \"\$common\" 
else 
    {>&2 echo \"Error : Missing File: \$common\"; exit 1;}
fi

handle_int(){
    kill -2 \$php_pid
    finish_time=\$(date +%s.%N)
    execute_time=\$(echo \"\$finish_time - \$start_time\" | bc -l)    
    echo -e \"PHP Server has been killed successfully after running for \033[1m\$execute_time s\033[m!\"
    exit 0
}

handle_term(){
    echo \"Exit the program!\"
    exit 0
}

trap handle_term SIGTERM
trap handle_int SIGINT




stop(){

    # echo -e \"DEBUG: stop function current pid: \$\$\nppid: \$PPID\"
    echo \"Port \$serverport is already used, or invalid!\" >&2
    kill -15 \$\$
}


#start
start(){


    if [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to start() function.\"; return 2;}
    elif [ \"\$#\" -eq 0 ]; then
        serverport=8080
    else
        serverport=\$1
    fi

    php_options=\$2

    cd \"\$programming_dir\" || {>&2 echo \"Error : Directory not exist : \$programming_dir\"; return 2;}

    start_time=\$(date +%s.%N)

    (php -S localhost:\$serverport \$php_options -t \$programming_dir  || stop) &
    

    php_pid=\$!

    sleep 1

    if [ \$no_browser -eq 1 ]; then

        setsid xdg-open \"http://localhost:\$serverport\" &

    else
        echo -e \"server is available on \033[94;1mhttp://localhost:\$serverport\033[m, also it available publicy using the server IP\"
    fi

    wait \$php_pid


}

# Check if the number of arguments is correct
if [ \"\$#\" -lt 1 ] || [ \"\$#\" -gt 6 ]; then
    show_help \"runphp\"; exit 1
fi

# Default values
php_options=\"\"
port=\"\"
no_browser=1

#^^

selected=1

# Get options
while [ \"\$#\" -gt 0 ]; do
    case \"\$1\" in
        -h|--help)
            show_help \"runphp\"; exit 0
        ;;
        -o|--php_options)
                
            if [ -n \"\$2\" ]; then
                    
                #Get args
                php_options=\"\$2\"
                shift 2
            else
                >&2 echo \"Error: --php_options option requires a string argument.\"
                exit 1
            fi
            ;;
        -p|--port)
            #^^^
            if [ -n \"\$2\" ]; then
                    
                #Get options
                port=\$2
               #^^^
                shift 2
            else
                >&2 echo \"Error: --port option requires an argument.\"
                                  #^^^
                exit 1
            fi
            ;;
        -n|--no_browser)
            no_browser=0
            shift 1
            ;;
        *)
            if [ \$selected -eq 0 ]; then
                show_help \"runphp\"
                exit 1
            fi

            project_name=\"\$1\"
            selected=0;shift 1;

            ;;
    esac
done

programming_dir=\"\$userhome/programming/php/\$project_name\"

start \$port \$php_options || exit \$?

    "

}
set_files_content(){

    files_content="#!/bin/bash

userhome=$user_home
temp=\$userhome/progtools/temp.sh
if [ -f \$temp  ]; then
    source \$temp 
else
    {>&2 echo \"Error : Missing File: \$temp\"; exit 5;}
fi

create_directory() {
            
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to create_directory() function.\"; return 2;}
    elif [ \"\$#\" -gt 1 ]; then
        {>&2 echo \"Error : Many arguments to create_directory() function.\"; return 2;}
    
    fi

    directory=\$1

    #try to create or open the Directory
    if [ -d \"\$directory\" ]; then
        cd \"\$directory\"
    else
        mkdir -p \"\$directory\" || {>&2 echo \"Error : Cannot create new directory : \$directory\"; return 1;}
        cd \"\$directory\"
    fi

}

create() {
                
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to create() function.\"; return 2;}
    elif [ \"\$#\" -gt 1 ]; then
        {>&2 echo \"Error : Many arguments to create() function.\"; return 2;}
    
    fi

    directory=\$(dirname \$1) 
    file_name=\$(basename \$1)

    #try to create or open the Directory
    if [ -d \"\$directory\" ]; then
        cd \"\$directory\"
    else
        create_directory \"\$directory\" ||  return \$?;
    fi

    #try to create or open the file 
    if [ -f \"\$file_name\" ]; then
        return 0
    else
        touch \"\$file_name\" || {>&2 echo \"Error : Cannot create new File : \$file_name\"; return 1;}
    fi
}

open_file() {
          
    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to open_file() function.\"; return 1;}
    elif [ \"\$#\" -gt 1 ]; then
        {>&2 echo \"Error : Many arguments to open_file() function.\"; return 1;}
    
    fi

    directory=\$(dirname \$1) 
    file_name=\$(basename \$1)

    if [ -d \"\$directory\" ]; then
        cd \"\$directory\"
    else 
        create \"\$directory/\$filename\"  ||  return \$?
    fi
    
    #try to create or open the file 
    if [ -f \"\$file_name\" ]; then
        $editor \"\$file_name\" 
        #^^^^
    else
        create \"\$directory/\$file_name\" || return \$?
        $editor \"\$file_name\" 
        #^^^^    
    fi

}
fill_file() {

    if [ \"\$#\" -lt 2 ]; then
        {>&2 echo \"Error : Few arguments to fill_file() function.\"; return 2;}
    elif [ \"\$#\" -gt 2 ]; then
        {>&2 echo \"Error : Many arguments to fill_file() function.\"; return 2;}
    
    fi

    path=\$1
    directory=\$(dirname \$path) 
    file_name=\$(basename \$path)
    string=\$2

    existdir=1

    if [ -d \"\$directory\" ]; then
        existdir=0    
        cd \"\$directory\"
    else 
        create \"\$path\"  ||  return \$?
    fi
    
    if [ -f \"\$file_name\" ] && [ \$existdir -eq 0 ] ; then
        return 0
    else
        echo \"\$string\" > \$file_name || {>&2 echo \"Error : Cannot write to : \$file_name\"; return 1;}
    fi
    
}


add(){

    if [ \"\$#\" -lt 2 ]; then
        {>&2 echo \"Error : Few arguments to add() function.\"; return 2;}
    elif [ \"\$#\" -gt 3 ]; then
        {>&2 echo \"Error : Many arguments to add() function.\"; return 2;}
    fi

    path=\$1
    directory=\$(dirname \$1) 
    file_name=\$(basename \$1)
    project_name=\$2
    file_type=\$3
    
    if [ -z \$file_type ]; then
        main=1
    elif [ \$file_type == \"main\" ]; then
        main=0
    elif [ \$file_type == \"no-main\" ]; then
        main=1
    else
        main=1
    fi

    
    if [[ \$file_name == *.php ]]; then
        set_phpp_php_template \"\$project_name\"
        fill_file \"\$path\" \"\$phpp_php_template\" || return \$?
    elif [[ \$file_name == *.html ]]; then
        set_phpp_html_template \"\$project_name\" 
        fill_file \"\$path\" \"\$phpp_html_template\" || return \$?
    elif [[ \$file_name == *.c ]] && [ \$main -eq 0 ]; then
        set_cee_main_template \"\$project_name\" 
        fill_file \"\$path\" \"\$cee_main_template\" || return \$?
    elif [[ \$file_name == *.c ]] && [ \$main -eq 1 ]; then
        set_cee_c_template \"\$project_name\" 
        fill_file \"\$path\" \"\$cee_c_template\" || return \$?
    elif [[ \$file_name == *.cpp ]] && [ \$main -eq 0 ]; then
        set_ceepp_main_template \"\$project_name\" 
        fill_file \"\$path\" \"\$ceepp_main_template\" || return \$?
    elif [[ \$file_name == *.cpp ]] && [ \$main -eq 1 ]; then
        set_ceepp_cpp_template \"\$project_name\" 
        fill_file \"\$path\" \"\$ceepp_cpp_template\" || return \$?
    elif [[ \$file_name == *.h ]]; then
        set_header_template \"\$file_name\" 
        fill_file \"\$path\" \"\$header_template\" || return \$?
    elif [[ \$file_name == *.asm ]] && [ \$main -eq 0 ]; then
        set_asm_main_template \"\$project_name\" 
        fill_file \"\$path\" \"\$asm_main_template\" || return \$?
    elif [[ \$file_name == *.asm ]] && [ \$main -eq 1 ]; then
        set_asm_asm_template \"\$project_name\" 
        fill_file \"\$path\" \"\$asm_asm_template\" || return \$?
    elif [[ \$file_name == *.py ]] && [ \$main -eq 0 ]; then
        set_py_main_template \"\$project_name\" 
        fill_file \"\$path\" \"\$py_main_template\" || return \$?
    elif [[ \$file_name == *.py ]] && [ \$main -eq 1 ]; then
        set_py_python_template \"\$project_name\" 
        fill_file \"\$path\" \"\$py_python_template\" || return \$?
    elif [[ \$file_name == *.sh ]]; then
        set_bscript_bash_template \"\$project_name\" 
        fill_file \"\$path\" \"\$bscript_bash_template\" || return \$?
    else
        create \"\$path\"
    fi


}


add_and_open(){
    if [ \"\$#\" -lt 2 ]; then
        {>&2 echo \"Error : Few arguments to add_open() function.\"; return 2;}
    elif [ \"\$#\" -gt 3 ]; then
        {>&2 echo \"Error : Many arguments to add_open() function.\"; return 2;}
    fi

    path=\$1
    project_name=\$2
    file_type=\$3
    
    add \$path \$project_name \$file_type || return \$?
    open_file \$path || return \$?

}



    "

}
set_common_content(){

    common_content="#!/bin/bash

# selected is to check if any project is selected (1 = false, 0 = true)
# options is to check if any options is selected (1 = false \"not yet\", 0 = true, 2 = false \"no options at all\" ) 

userhome=$user_home
files=\"\$userhome/progtools/files.sh\"
if [ -f \"\$files\" ]; then
    source \"\$files\" 
else 
    {>&2 echo \"Error : Missing File: \$files\"; exit 1;}
fi


show_help() {

    if [ \"\$#\" -lt 1 ]; then
        {>&2 echo \"Error : Few arguments to show_help() function.\"; return 2;}
    elif [ \"\$#\" -gt 1 ]; then
        {>&2 echo \"Error : Many arguments to show_help() function.\"; return 2;}
    
    fi

    src=\$1

    if [[ \$src == \"cee\" ]]; then
        lang=\"C\"
        ext=\"c\"
        main_file=\"main\"
        main_name=\"project1\"
        secondary=\"test.h\"
    elif [[ \$src == \"cee++\" ]]; then
        lang=\"C++\"
        ext=\"cpp\"
        main_file=\"main\"
        main_name=\"project1\"
        secondary=\"test.h\"
    elif [[ \$src == \"asm\" ]]; then
        lang=\"asm\"
        ext=\"asm\"
        main_file=\"main\"
        main_name=\"project1\"
        secondary=\"test.h\"
    elif [[ \$src == \"py\" ]]; then
        lang=\"python\"
        ext=\"py\"
        main_file=\"main\"
        main_name=\"project1\"
        secondary=\"test.py\"
    elif [[ \$src == \"phpp\" ]]; then
        lang=\"php\"
        ext=\"php\"
        main_file=\"php\"
        main_name=\"index\"
        secondary=\"js/script.js\"
        phpp_extra=\"a new directory \\\"js\\\", then create\"
        phpp_extra2=\"/js\"
        
    elif [[ \$src == \"bscript\" ]]; then
        lang=\"bash\"
        ext=\"sh\"
        main_file=\"\"
        main_name=\"project1\"
    fi


    if [[ \$src == \"cee\" ]] || [[ \$src == \"cee++\" ]] || [[ \$src == \"asm\" ]] || [[ \$src == \"py\" ]] || [[ \$src == \"bscript\" ]] || [[ \$src == \"phpp\" ]] ; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message\"
        echo \"  --add, --add-file <filename>        Add a new file with a default template to the file extension and open it using editor\"
        echo \"  -o, --open <filename>   open an existing file\"
        echo \"Examples:\"
        echo \"\$src project1 : will create project \\\"project1\\\", and open \$main_file \$lang file \\\"\$main_name.\$ext\\\" using file editor.\"
        echo \"\$src project1 --add \$secondary : will create \$phpp_extra a new file called \\\"\$secondary\\\" in the \\\"project1\$phpp_extra2\\\" directory, using default template for the file extension, then use editor to open the file.\"
        echo \"\$src project1 -o \$secondary : will open file \\\"\$secondary\\\" if exists, using text editor.\"

    elif [[ \$src == \"runc\" ]]; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message.\"
        echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the project elf, providing the arguments to the elf file.\"
        echo \"  -c, --gcc_options <gcc options as a string> Run the compile and run project\"
        echo \"Examples:\"
        echo \"\$src project1 --args \\\"arg1 arg2 ... argn\\\" --gcc-options \\\"-pthread -g\\\": will run the elf file, and provide the arguments to the elf file.\"
    elif [[ \$src == \"runc++\" ]]; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message.\"
        echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the project elf, providing the arguments to the elf file.\"
        echo \"  -c, --gpp_options <g++ options as a string> Run the compile and run project\"
        echo \"Examples:\"
        echo \"\$src project1 --args \\\"arg1 arg2 ... argn\\\" --gpp-options \\\"-pthread -g\\\": will run the elf file, and provide the arguments to the elf file.\"

    elif [[ \$src == \"runa\" ]]; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help      Show this help message.\"
        echo \"  -a, --args  <arguments as one string, in double or single quotes>       Execute the project elf, providing the arguments to the elf file.\"
        echo \"  -n, --nasm_options <nasm options as a string>       Set nasm options\"
        echo \"  -l, --ld_options <ld options as a string>       Link object files\"
        
        echo \"Examples:\"
        echo \"\$src project1 --args \\\"arg1 arg2 ... argn\\\" --ld-options \\\"--option1 --option2\\\" --nasm-options \\\"--option1 --option2\\\": will run the elf file, and provide the arguments to the elf file, and set ld and nasm options.\"

    elif [[ \$src == \"runpy\" ]]; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message.\"
        echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the main python file, providing the arguments to the python file.\"
        echo \"Examples:\"
        echo \"\$src project1 --args \\\"arg1 arg2 ... argn\\\" : will execute the python file using python3, and provide the arguments to the python file.\"
    elif [[ \$src == \"runb\" ]]; then
        echo \"Usage: runb [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message.\"
        echo \"  -a, --args  <arguments as one string, in double or single quotes>     Execute the main bash file, providing the arguments to the script.\"
        echo \"Examples:\"
        echo \"runb project1 --args \\\"arg1 arg2 ... argn\\\" : will execute the script, and provide the arguments to the script.\"
    elif [[ \$src == \"runphp\" ]]; then
        echo \"Usage: \$src [options] <project_name>\"
        echo \"Options:\"
        echo \"  -h, --help              Show this help message.\"
        echo \"  -o, --php_options  <options for \\\"php\\\" command as one string, in double or single quotes>\"
        echo \"  -p, --port <server port number> start php server on specified port\"
        echo \"  -n, --no_browser   only start php server without open the project in default browser\"
        echo \"Examples:\"
        echo \"\$src project1 --php_options \\\"option1 option2 ... option n\\\" --port 4747 : will run php server on localhost:4747, and opens the project in browser.\"
    else
        echo \"invalid src \$src for show_help() function!\" >&2;return 8
   
    fi
}


decide(){
    
    if [ \"\$#\" -lt 2 ]; then
        {>&2 echo \"Error : Few arguments to decide() function.\"; return 2;}
    elif [ \"\$#\" -gt 5 ]; then
        {>&2 echo \"Error : Many arguments to decide() function.\"; return 2;}
    
    fi

    selected=1
    options=1
    option=\"\"
    main_index=1
    src=\$1
    shift 1
    main=\$1
    shift 1
    if [[ \$src == \"cee\" ]]; then
        lang=\"C\"
        ext=\"c\"
    elif [[ \$src == \"cee++\" ]]; then
        lang=\"C++\"
        ext=\"cpp\"
    elif [[ \$src == \"asm\" ]]; then
        lang=\"asm\"
        ext=\"asm\"
    elif [[ \$src == \"py\" ]]; then
        lang=\"python\"
        ext=\"py\"
    elif [[ \$src == \"phpp\" ]]; then
        lang=\"php\"
        ext=\"php\"
        main_index=0

    elif [[ \$src == \"bscript\" ]]; then
        lang=\"bash\"
        ext=\"sh\"
    else
          echo \"invalid src \$src for decide() function!\" >&2;return 8
    fi

    while [ \$# -gt 0 ]; do
        case \$1 in
            -h|--help)
                show_help \$src; exit 0
                ;;
            --add | --add-file)
                
                if [ -n \"\$2\" ]; then
                    
                    #Get file name
                    file_to_add=\"\$2\"
                        
                    #Check for options
                    if [ \$options -eq 0 ]; then
                        break
                    else
                        options=0
                        option=\"add\"
                        shift 2
                    fi

                    if [ \$selected -eq 0 ]; then
                        add_and_open  \"\$project_dir/\$file_to_add\" \"\$project_name\" || exit \$? 
                        break
                    fi
                else
                    >&2 echo \"Error: --add option requires a filename argument.\"
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
                        open_file  \"\$project_dir/\$file_to_open\" || exit \$?
                        break
                    fi
                else
                    >&2 echo \"Error: -o/--open option requires a filename argument.\"
                    exit 1
                fi
                ;;

                
            *)

                if [ \$selected -eq 0 ]; then
                    show_help \$src
                    exit 1
                fi


                project_name=\"\$1\";
                project_dir=\"\$userhome/programming/\$lang/\$project_name\"
            
                
                if [ \$options -eq 0 ]; then
                    if [ \$option = \"add\" ]; then
                        add_and_open  \"\$project_dir/\$file_to_add\" \"\$project_name\" || exit \$? 
                    elif [ \$option = \"open\" ]; then
                        open_file \"\$project_dir/\$file_to_open\" || exit \$?
                    fi    
                fi
                selected=0;shift;

                if [ \$main_index -eq 1 ];then
                    main_file_name=\$project_name
                else
                    main_file_name=\"index\"
                fi
                if [ \$# -eq 0 ] && [ \$options -ne 0 ]; then
                    add_and_open \"\$project_dir/\$main_file_name.\$ext\" \"\$project_name\" \"\$main\" || exit \$?
                fi
                ;;
        esac
    done

}




print_result(){
    
    if [ \"\$#\" -lt 3 ]; then
    {>&2 echo \"Error : Few arguments to print_result() function.\"; return 2;}
    elif [ \"\$#\" -gt 5 ]; then
    {>&2 echo \"Error : Many arguments to print_result() function.\"; return 2;}
    fi

    src=\$1
    status_code=\$2
    

    # Get the number of columns in the terminal
    col=\$(tput cols)

    # Construct the pattern
    pattern=\"\"
    
    for ((i = 0; i < col; i++)); do
        pattern+=\"═\"
    done
    if [ \$status_code -eq 0 ]; then
	color=\"32m\"
    else
	color=\"31m\" 
    fi
    # Print the pattern
    echo \"\"
    echo -e \"\033[\$color\$pattern\033[m\"
    echo -e \" status code :\033[1;\$color \$status_code\033[m \"
    
    
    if [[ \$src == \"runc\" ]] || [[ \$src == \"runc++\" ]] ; then
        compile_time=\$3
        execute_time=\$4
        echo -e \" compiled in \033[1m\$compile_time s\033[m\"
        echo -e \"  executed in \033[1m\$execute_time s\033[m\"
    elif [[ \$src == \"runa\" ]]; then
        assemble_time=\$3
        link_time=\$4
        execute_time=\$5
        echo -e \"  assembled in \033[1m\$assemble_time s\033[m\"
        echo -e \" linked in \033[1m\$link_time s\033[m\"
        echo -e \"  executed in \033[1m\$execute_time s\033[m\"
    elif [[ \$src == \"runpy\" ]] || [[ \$src == \"runb\" ]]; then
        execute_time=\$3
        echo -e \"  executed in \033[1m\$execute_time s\033[m\"
    fi

    echo -e \"\033[\$color\$pattern\033[m\"
}

    "

}
set_temp_content(){

    temp_content="#!/bin/bash

unknown_arch=1
distro_name=\$(lsb_release -si)
distro_version=\$(lsb_release -sr)
arch=\$(uname -m)
user=\$(whoami)
date=\$(date \"+%d-%b-%Y\")
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
    unknown_arch=0
fi


set_phpp_php_template() {

       phpp_php_template=\"<!DOCTYPE html>
<html lang=\\\"en\\\">
<head>
    <meta charset=\\\"UTF-8\\\">
    <meta name=\\\"viewport\\\" content=\\\"width=device-width, initial-scale=1.0\\\">
    <title>\$1</title>
</head>
<body>
    <?php
        /*
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


        //Code Here :



    ?>
</body>
</html>
    \"
    }

    

    set_phpp_html_template() {

       phpp_html_template=\"<!DOCTYPE html>
<html lang=\\\"en\\\">
<head>
    <meta charset=\\\"UTF-8\\\">
    <meta name=\\\"viewport\\\" content=\\\"width=device-width, initial-scale=1.0\\\">
    <title>\$1</title>
</head>
<body>
    
</body>
</html>
    \"
    }



    set_cee_c_template() {

       cee_c_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$1
* 
*/
#include <stdio.h>

    \"
    }

    set_cee_main_template() {
        
        
   cee_main_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$1
* 
*/
#include <stdio.h>
int main(int argc,char** argv){


    return 0;
}

    \"

    }



 
set_ceepp_cpp_template() {

       ceepp_cpp_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$1
* 
*/
#include <iostream>
using namespace std;


    \"
    }

    set_ceepp_main_template() {
        
        
   ceepp_main_template=\"/*
*
*	Author : \$user
*                
*	OS : \$distro_name \$distro_version \$arch
*
*	Date : \$date
*
*   Project Name : \$1
* 
*/
#include <iostream>
using namespace std;
int main(int argc,char** argv){


	return 0;
}
    \"

    }

set_header_template() {
        
    header_file_name=\"\${1%.h}\"

    header_template=\"#ifndef \${header_file_name^^}_H
#define \${header_file_name^^}_H


#endif\"
}



set_asm_asm_template() {

    if [ \$unknown_arch -eq 0 ]; then
        return 1;
    fi
       
    asm_asm_template=\"; Author : \$user
; OS : \$distro_name \$distro_version \$arch
; Date : \$date
; Project Name : \$1

section .text

section .data

\"


}


set_asm_main_template() {

    if [ \$unknown_arch -eq 0 ]; then
        return 1;
    fi
    asm_main_template=\"; Author : \$user
; OS : \$distro_name \$distro_version \$arch
; Date : \$date
; Project Name : \$1
global _start
section .text
end:
mov \$register1,\$syscallid
mov \$register2,0
\$call
_start:


jmp end
section .data

\"
    
    }
set_py_main_template() {
py_main_template=\"# Author : \$user
# OS : \$distro_name \$distro_version \$arch
# Date : \$date
# Project Name : \$1

if __name__ == \\\"__main__\\\":
    


\"
}



set_py_python_template() {

py_python_template=\"# Author : \$user
# OS : \$distro_name \$distro_version \$arch
# Date : \$date
# Project Name : \$1



\"

}



set_bscript_bash_template() {

bscript_bash_template=\"#!/bin/bash
# Author : \$user
# OS : \$distro_name \$distro_version \$arch
# Date : \$date
# Project Name : \$1




\"

}


"

}


if [ "$#" -lt 1 ]; then
    >&2 echo "invalid number of arguments" ;show_help
    exit 5
fi
user_name=$1
exist=0
id "$user_name" >/dev/null || exist=1

if [ $exist -eq 1  ]; then
    echo "user: $user_name is invalid!" >&2
    show_help; exit 9;
fi


if [ $user_name = "root" ]; then
    user_home="/root"
else
    user_home="/home/$user_name"
fi

programming_dir="$user_home/programming"
progtools_dir="$user_home/progtools"

install_deps || exit $?
    
mkdir -p $programming_dir/{C,C++,python,asm,bash,php} 
chown "$user_name:$user_name" "$programming_dir"
mkdir -p $progtools_dir || echo "$progtools_dir is already exist" >&2
chown "$user_name:$user_name" "$progtools_dir"
echo -e "\nexport PATH=$PATH:$progtools_dir" >> "$user_home/.$(basename `echo $SHELL`)rc"
chown "$user_name:$user_name" $programming_dir/{C,C++,python,asm,bash,php} || exit $?

set_cee_content
create_exe "$progtools_dir/cee" || exit $?
fill_file "$progtools_dir/cee" "$cee_content" || exit $?

set_ceepp_content
create_exe "$progtools_dir/cee++" || exit $?
fill_file "$progtools_dir/cee++" "$ceepp_content" || exit $?

set_asm_content
create_exe "$progtools_dir/asm" || exit $?
fill_file "$progtools_dir/asm" "$asm_content" || exit $?
                
set_py_content
create_exe "$progtools_dir/py" || exit $?
fill_file "$progtools_dir/py" "$py_content" || exit $?


set_bscript_content
create_exe "$progtools_dir/bscript" || exit $?
fill_file "$progtools_dir/bscript" "$bscript_content" || exit $?

set_phpp_content
create_exe "$progtools_dir/phpp" || exit $?
fill_file "$progtools_dir/phpp" "$phpp_content" || exit $?

set_runc_content
create_exe "$progtools_dir/runc" || exit $?
fill_file "$progtools_dir/runc" "$runc_content" || exit $?

set_runcpp_content
create_exe "$progtools_dir/runc++" || exit $?
fill_file "$progtools_dir/runc++" "$runcpp_content" || exit $?

set_runpy_content
create_exe "$progtools_dir/runpy" || exit $?
fill_file "$progtools_dir/runpy" "$runpy_content" || exit $?

set_runa_content
create_exe "$progtools_dir/runa" || exit $?
fill_file "$progtools_dir/runa" "$runa_content" || exit $?

set_runb_content
create_exe "$progtools_dir/runb" || exit $?
fill_file "$progtools_dir/runb" "$runb_content" || exit $?

set_runphp_content
create_exe "$progtools_dir/runphp" || exit $?
fill_file "$progtools_dir/runphp" "$runphp_content" || exit $?


set_files_content
create_exe "$progtools_dir/files.sh" || exit $?
fill_file "$progtools_dir/files.sh" "$files_content" || exit $?

set_common_content
create_exe "$progtools_dir/common.sh" || exit $?
fill_file "$progtools_dir/common.sh" "$common_content" || exit $?

set_temp_content
create_exe "$progtools_dir/temp.sh" || exit $?
fill_file "$progtools_dir/temp.sh" "$temp_content" || exit $?

echo ""
printf 'Thank you %s for using progtools, progtools is a programming environment for beginners
the programming file structure is in %s/programming directory
more languages and ideas will be added in the future
cee : to create new C project, and edit C files with your favorite editor
asm : to create new assembly project, and edit assembly files with your favorite editor
py : to create new python3 project, and edit python3 files with your favorite editor
cee++ : to create new C++ project, and edit C++ files with your favorite editor
bscript : to create new bash script project, and edit bash files with your favorite editor
phpp : to create new php project, and edit web files with your favorite editor
runc : to run your C project
runc++ : to run your C++ project
runa : to run your assembly project
runpy : to run your python3 project
runb : to run your bash script project
runphp : to start php server, and open project in default browser' $1 $home
echo ""
