#!/bin/bash
if [ "$#" -eq 1 ]; then
	if id -u $1 >/dev/null 2>&1; then
		if [ $1 != "root" ]; then
apt update
apt install -y -f nasm g++ gcc gdb python3 bc vim 
mkdir -p /home/$1/Desktop/programming/{C,C++,python,asm,bash}
##asm
printf '#!/bin/bash 
ff=/home/%s/Desktop/programming/asm/$1
FILE=/home/%s/Desktop/programming/asm/$1/$1.asm
if [[ -d "$ff" ]]; then
	cd "/home/%s/Desktop/programming/asm/$1"
else
	mkdir "/home/%s/Desktop/programming/asm/$1"
	cd "/home/%s/Desktop/programming/asm/$1"
fi


if [[ -f "$FILE" ]]; then
	vim "$1.asm"
else
        touch "$1.asm"
        echo "; Author : %s" >> "$1.asm"' $1 $1 $1 $1 $1 $1> /bin/asm 
echo "" >>/bin/asm	
echo '
	distro_name=$(lsb_release -si)
        distro_version=$(lsb_release -sr)
arch=$(uname -m)
echo "; OS : $distro_name $distro_version $arch" >> "$1.asm"
	echo "; Date : $(date "+%d-%b-%Y")" >> "$1.asm"
        echo "" >> "$1.asm"
        echo "global _start" >> "$1.asm"
        echo "section .text" >> "$1.asm"
        echo "end:" >> "$1.asm"
        echo "" >> "$1.asm"
        echo "mov rax,60" >> "$1.asm"
        echo "mov rdi,0" >> "$1.asm"
        echo "syscall" >> "$1.asm"
	echo "_start:" >> "$1.asm"
	echo "jmp end" >> "$1.asm"
        echo "section .data" >> "$1.asm"
        vim "$1.asm"
fi' >> /bin/asm
chown $1:$1 /bin/asm
chmod 500 /bin/asm

##arun
printf '#!/bin/bash
cd /home/%s/Desktop/programming/asm/"$1"
s1=`date +%%s.%%N`
nasm -f elf64 $1.asm
ld -m elf_x86_64 -o $1 $1.o
e1=`date +%%s.%%N`
t1=$( echo "$e1 - $s1" | bc -l)
echo ""
s2=`date +%%s.%%N`
./$1
echo ""
e2=`date +%%s.%%N`
t2=$( echo "$e2 - $s2" | bc -l)
echo ""
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
echo " assembled & linked in  $t1 s"
echo "  executed in $t2 s"
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
rm $1' $1>/bin/arun
chown $1:$1 /bin/arun
chmod 500 /bin/arun

##pyrun
printf '#!/bin/bash
cd /home/%s/Desktop/programming/python/"$1"
s1=`date +%%s.%%N`
python3 $1.py $2 $3 $4 $5
e1=`date +%%s.%%N`
t1=$( echo "$e1 - $s1" | bc -l)
echo ""
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
echo " executed in $t1 s"
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
' $1>/bin/pyrun
chown $1:$1 /bin/pyrun
chmod 500 /bin/pyrun

##py
printf '#!/bin/bash 
ff=/home/%s/Desktop/programming/python/$1
FILE=/home/%s/Desktop/programming/python/$1/$1.py
if [[ -d "$ff" ]]; then
	cd "/home/%s/Desktop/programming/python/$1"
else
	mkdir "/home/%s/Desktop/programming/python/$1"
	cd "/home/%s/Desktop/programming/python/$1"
fi


if [[ -f "$FILE" ]]; then
	vim "$1.py"
else
        touch "$1.py"
        vim "$1.py"
fi' $1 $1 $1 $1 $1>/bin/py
chown $1:$1 /bin/py
chmod 500 /bin/py

##code
printf '#!/bin/bash 
ff=/home/%s/Desktop/programming/C/$1
FILE=/home/%s/Desktop/programming/C/$1/$1.c
if [[ -d "$ff" ]]; then
	cd "/home/%s/Desktop/programming/C/$1"
else
	mkdir "/home/%s/Desktop/programming/C/$1"
	cd "/home/%s/Desktop/programming/C/$1"
fi


if [[ -f "$FILE" ]]; then
	vim "$1.c"
else
        touch "$1.c"
        echo "/*" >> "$1.c"
        echo "*" >> "$1.c"
        echo "*	Author : %s' $1 $1 $1 $1 $1 $1> /bin/code
	echo '" >> "$1.c"
        echo "*" >> "$1.c"
        distro_name=$(lsb_release -si)
        distro_version=$(lsb_release -sr)
arch=$(uname -m)
echo "*	OS : $distro_name $distro_version $arch" >> "$1.c"
        echo "*" >> "$1.c"
	echo "*	Date : $(date "+%d-%b-%Y")" >> "$1.c"
        echo "*" >> "$1.c"
        echo "*/" >> "$1.c"
        echo "#include <stdio.h>" >> "$1.c"
        echo "int main(){" >> "$1.c"
        echo "" >> "$1.c"
        echo "	return 0;" >> "$1.c"
        echo "}" >> "$1.c"
        vim "$1.c"
fi'>>/bin/code
chown $1:$1 /bin/code
chmod 500 /bin/code

##codec
printf '#!/bin/bash 
ff=/home/%s/Desktop/programming/C++/$1
FILE=/home/%s/Desktop/programming/C++/$1/$1.cpp
if [[ -d "$ff" ]]; then
	cd "/home/%s/Desktop/programming/C++/$1"
else
	mkdir "/home/%s/Desktop/programming/C++/$1"
	cd "/home/%s/Desktop/programming/C++/$1"
fi


if [[ -f "$FILE" ]]; then
	vim "$1.cpp"
else
        touch "$1.cpp"
        echo "/*" >> "$1.cpp"
        echo "*" >> "$1.cpp"
        echo "*	Author : %s"' $1 $1 $1 $1 $1 $1 > /bin/codec
	echo ' >> "$1.cpp"
        echo "*" >> "$1.cpp"
        distro_name=$(lsb_release -si)
distro_version=$(lsb_release -sr)
arch=$(uname -m)
echo "*	OS : $distro_name $distro_version $arch" >> "$1.cpp"
        
        
        echo "*" >> "$1.cpp"
	echo "*	Date : $(date "+%d-%b-%Y")" >> "$1.cpp"
        echo "*" >> "$1.cpp"
        echo "*/" >> "$1.cpp"
        echo "#include <iostream>" >> "$1.cpp"
        echo "using namespace std;" >> "$1.cpp"
        echo "int main(){" >> "$1.cpp"
        echo "" >> "$1.cpp"
        echo "	return 0;" >> "$1.cpp"
        echo "}" >> "$1.cpp"
        vim "$1.cpp"
fi'>>/bin/codec
chown $1:$1 /bin/codec
chmod 500 /bin/codec

##codet
printf '#!/bin/bash 
ff=/home/%s/Desktop/programming/C/$1
FILE=/home/%s/Desktop/programming/C/$1/$1.c
if [[ -d "$ff" ]]; then
	cd "/home/%s/Desktop/programming/C/$1"
else
	mkdir "/home/%s/Desktop/programming/C/$1"
	cd "/home/%s/Desktop/programming/C/$1"
fi


if [[ -f "$FILE" ]]; then
	vim "$1.c"
else
        touch "$1.c"
	echo "/*" >> "$1.c"
        echo "*" >> "$1.c"
        echo "*	Author : %s' $1 $1 $1 $1 $1 $1> /bin/codet
	echo '" >> "$1.c"
        echo "*" >> "$1.c"
        distro_name=$(lsb_release -si)
        distro_version=$(lsb_release -sr)
arch=$(uname -m)
echo "*	OS : $distro_name $distro_version $arch" >> "$1.c"
        echo "*" >> "$1.c"
	echo "*	Date : $(date "+%d-%b-%Y")" >> "$1.c"
        echo "*" >> "$1.c"
        echo "*/" >> "$1.c"
 
        echo "#include <stdio.h>" >> "$1.c"
	echo "#include <stdlib.h>" >> "$1.c"
       	echo "#include <unistd.h>" >> "$1.c"
       	echo "#include <string.h>" >> "$1.c"
	echo "#include <pthread.h>" >> "$1.c"
        echo "int main(){" >> "$1.c"
        echo "" >> "$1.c"
        echo "        return 0;" >> "$1.c"
        echo "}" >> "$1.c"
	vim "$1.c"
fi'>>/bin/codet
chown $1:$1 /bin/codet
chmod 500 /bin/codet

##run
printf '#!/bin/bash
cd /home/%s/Desktop/programming/C/"$1"
s1=`date +%%s.%%N`
gcc $1.c
e1=`date +%%s.%%N`
t1=$( echo "$e1 - $s1" | bc -l)
echo ""
s2=`date +%%s.%%N`
./a.out
echo ""
e2=`date +%%s.%%N`
t2=$( echo "$e2 - $s2" | bc -l)
echo""
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
echo " compiled in $t1 s"
echo "  executed in $t2 s"
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
rm a.out' $1>/bin/run
chown $1:$1 /bin/run
chmod 500 /bin/run

##runc
printf '#!/bin/bash
cd /home/%s/Desktop/programming/C++/"$1"
s1=`date +%%s.%%N`
g++ $1.cpp
e1=`date +%%s.%%N`
t1=$( echo "$e1 - $s1" | bc -l)
echo ""
s2=`date +%%s.%%N`
./a.out
echo ""
e2=`date +%%s.%%N`
t2=$( echo "$e2 - $s2" | bc -l)
echo""
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
echo " compiled in $t1 s"
echo "  executed in $t2 s"
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
rm a.out' $1>/bin/runc
chown $1:$1 /bin/runc
chmod 500 /bin/runc

##runt
printf '#!/bin/bash
cd /home/%s/Desktop/programming/C/"$1"
s1=`date +%%s.%%N`
gcc -g -pthread $1.c
e1=`date +%%s.%%N`
t1=$( echo "$e1 - $s1" | bc -l)
echo ""
s2=`date +%%s.%%N`
./a.out
echo ""
e2=`date +%%s.%%N`
t2=$( echo "$e2 - $s2" | bc -l)
echo""
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
echo " compiled in $t1 s"
echo "  executed in $t2 s"
echo "\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\\"
rm a.out' $1>/bin/runt
chown $1:$1 /bin/runt
chmod 500 /bin/runt
		else
			echo "syntax : progtools64 <username> *not root" >&2
			echo "do not enter root as username" >&2	
		fi
	else
		echo "syntax : progtools64 <username> *not root" >&2
		echo "invalid username" >&2
	fi
else 
	echo "syntax : progtools64 <username> *not root" >&2
	echo "invalid number of arguments" >&2
fi
