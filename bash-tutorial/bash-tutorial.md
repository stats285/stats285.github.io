---
layout: default
---

_This tutorial is contributed by Hatef Monajemi (@monajemi)_

The following tutorial is intended to familiarize you with writing Bash scripts. 
We will review the core elements of Bash scripting that you will be
using frequently in this class.  

# Table of Contents
- [Bash script](#bash-script)
- [Variables](#variables) 
- [If statement](#if-statement)
- [Loops](#loops)
- [File manipulation](#file-manipulation)
    - [Read/Write](#readwrite) 
    - [Changing file content](#changing-file-content)
    
## Bash script

Bash scripting is a great way to automate your computational tasks
and is used regularly by system admins, programmers, data scientists 
and many others to reduce the pain of having to do certain tasks many times manually.

Here is how a Bash script may look like:

```bash
#!/bin/bash
# File: bashMain.sh
# STATS 285, 2017

# Write some commands to be executed
echo "BASH SCRIPTING"
echo "CURRENTLY IN:"
pwd
echo "Here is a list of the contents of this directory:"
ls -lt
```

As you may have noticed, you may already be familiar with these commands and perhaps have typed 
them in your terminal before. A bash script is just a text file (`bashMain.sh` in this example) that contains these commands so you don't have to type them each time. Instead, you just execute all the commands at once by writing `./bashMain.sh` or `bash bashMain.sh` in a terminal.


## Variables

You can define variables in bash by assigning a value to its reference:

```bash
STR="The value of a bash variable can be any data type.";
printf "%s\n" "$STR"
```
Here, we have defined a bash variable named STR, which contains *"The value of a bash variable"* as its value. We can use this variable by attaching a `$` to the beginning of it, hence in the second line `$STR` will be replaced by the value of STR variable.  
Note that we have used `printf` function instead of `echo` to print. This is another way of prining in bash specially when you need a formatted output.  

## If statement
Often times, one needs to check that certain criteria are valid before proceeding; for example, you may want to check whether certain directory or file exists before creating a new one. Bash conditional statement can handle such tasks. The following sturtures are availble in Bash:
```bash
if [ condition ]; then
        excecute some expression
fi
```

```bash
if [ condition ]; then
        excecute expression 1
else
        excecute expression 2
fi
```

```bash
if [ condition 1 ]; then
    excecute expression 1
else if [ condition 2 ]; then
    excecute expression 2
else
    excecute expression 3
fi
```

Note that we have placed a `space` after `[` and before `]`. If you do not add this space, bash will produce an error.  

As an example, I can check whether the file `bashMain.sh` exist.
```bash
FILE="bashMain.sh"
if [ -f  $FILE ]; then  
    echo "$FILE exists."  
else  
    echo "$FILE does not exist."  
fi
```

## Loops
Bash uses the following syntax for the `for` and `while` loops:


```bash
EMAIL_LIST=(
'Stats285 Stanford <stats285.stanford@gmail.com>'
'Hatef Monajemi <monajemi@stanfxxx.edu>'
'David Donoho <donoho@stanfxxx.edu>'
'Vardan Papayan <vardanp91@gmail.com>'
)

for EMAIL in "${EMAIL_LIST[@]}" ; do
echo "$EMAIL"
done;


COUNTER=0;
while [ $COUNTER -lt 3 ] ; do
echo "${EMAIL_LIST[$COUNTER]}"
let COUNTER+=1;
done;

```

## File manipulation
Bash provides many tools to manipulate files. Here we review how you can read, modify and write files. 

### Read/Write

### Changing file content


[back](../notes)
