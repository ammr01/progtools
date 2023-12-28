# ProgTools

ProgTools is a versatile bash script designed to streamline the installation of essential programming tools and facilitate the setup of a beginner-friendly programming environment. The script creates a standardized folder structure for programming projects, allowing users to easily organize and manage their codebase. Additionally, ProgTools generates twelve executable files, each tailored to specific programming languages, namely Assembly, C, C++, Python, PHP (Web projects), and Bash.

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

Inside the programming folder, subfolders are created for C, C++, Python, Assembly, PHP, and Bash scripts.

## Executable Files

ProgTools generates twelve executable files with specific purposes:

- **asm**: Create and edit Assembly projects.
- **runa**: Assemble, link, and run Assembly projects.
- **cee**: Create and edit C projects.
- **runc**: Compile and run C projects.
- **cee++**: Create and edit C++ projects.
- **runc++**: Compile and run C++ projects.
- **py**: Create and edit Python projects.
- **runpy**: Run Python projects.
- **bscript**: Create and edit Bash scripts.
- **runb**: Run Bash scripts.
- **phpp**: Create and edit PHP projects.
- **runphp**: Run PHP projects.

## Conclusion

ProgTools simplifies the installation of essential programming tools and establishes a well-organized structure for programming projects. The generated executable files enable effortless creation, editing, and execution of programs in Assembly, C, C++, Bash, PHP, and Python.

## Examples

### C

To create a new C project called "example" in `{user home directory}/programming/C/example`:

```bash
cee example
```

To add a new header file called "koko.h" to the "example" project and open it in the chosen text editor:

```bash
cee example --add koko.h
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
runp example --args "arg1 arg2"
```

### PHP

To create a new Web project in php  called "example" in `{user home directory}/programming/php/example`, and create index.php file with php template:


```bash
phpp example
```

To add a new js file called "script.js", in js directory to the "example" project and open it in the chosen text editor:

```bash
phpp example --add js/script.js
```

To start php server on port 8888, and open "example" project in the default browser:

```bash
runphp example -p 8888
```

