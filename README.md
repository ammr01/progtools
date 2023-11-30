# ProgTools

ProgTools is a versatile bash script designed to streamline the installation of essential programming tools and facilitate the setup of a beginner-friendly programming environment. The script creates a standardized folder structure for programming projects, allowing users to easily organize and manage their codebase. Additionally, ProgTools generates ten executable files, each tailored to specific programming languages, namely Assembly, C, C++, Python, and Bash.

## Requirements

ProgTools is intended for use on Linux operating systems, particularly those utilizing the apt package manager (such as Debian and Ubuntu). Root privileges are required to execute the script successfully.

## Usage

To run ProgTools, execute the following command with root privileges:

```bash
sudo ./progtools.sh <username>
```

Replace `<username>` with the desired user's username to install the tools and create the file structure in their home directory.

## Folder Structure

The script establishes a standardized folder structure for programming projects at the following location:

```
{user home directory}/programming/
```

Inside the programming folder, subfolders are created for C, C++, Python, Assembly, and Bash scripts.

## Executable Files

ProgTools generates eight executable files with specific purposes:

- **asm**: Create and edit Assembly projects.
- **runa**: Assemble, link, and run Assembly projects.
- **cee**: Create and edit C projects.
- **runc**: Compile and run C projects.
- **cee++**: Create and edit C++ projects.
- **runc++**: Compile and run C++ projects.
- **py**: Create and edit Python projects.
- **runp**: Run Python projects.
- **bscript**: Create and edit Bash scripts.
- **runb**: Run Bash scripts.

## Conclusion

ProgTools simplifies the installation of essential programming tools and establishes a well-organized structure for programming projects. The generated executable files enable effortless creation, editing, and execution of programs in Assembly, C, C++, Bash, and Python.

## Examples

### C

To create a new C project called "example" in `{user home directory}/programming/C/example`:

```bash
cee example
```

To add a new C file called "koko.c" to the "example" project and open it in the chosen text editor:

```bash
cee example --add koko.c
```

To compile and run the "example" project with specific options and arguments:

```bash
runc -c "-pthread -g -O3" -a "arg1 arg2" example
```

### C++

To create a new C++ project called "example" in `{user home directory}/programming/C++/example`:

```bash
cee++ example
```

To add a new C++ file called "koko.cpp" to the "example" project and open it in the chosen text editor:

```bash
cee++ example --add koko.cpp
```

To compile and run the "example" project with specific options and arguments:

```bash
runc++ -c "-option1 -option2" -a "arg1 arg2" example
```

### Assembly

To create a new Assembly project called "example" in `{user home directory}/programming/asm/example`:

```bash
asm example
```

To add a new Assembly file called "koko.asm" to the "example" project and open it in the chosen text editor:

```bash
asm example --add koko.asm
```

To assemble and link the "example" project with specific options and arguments:

```bash
runa -l "-ld_option1 -ld_option2" -a "arg1 arg2" -n "-nasm_option1 -nasm_option2"  example
```

### Bash

To create a new Bash script project called "example" in `{user home directory}/programming/bash/example`:

```bash
bscript example
```

To add a new Bash script file called "koko.sh" to the "example" project and open it in the chosen text editor:

```bash
bscript example --add koko.sh
```

To run the "example" Bash script with specific arguments:

```bash
runb example --args "arg1 arg2"
```

### Python3

To create a new Python3 project called "example" in `{user home directory}/programming/python/example`:

```bash
py example
```

To run the "example" Python script with specific arguments:

```bash
runp example --args 	"arg1 arg2"
```
