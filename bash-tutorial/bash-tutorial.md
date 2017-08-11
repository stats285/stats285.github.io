---
layout: default
---

_This tutorial is contributed by Hatef Monajemi (@monajemi)_

The following tutorial is intended to familiarize you with writing Bash scripts. 
We will review the core elements of Bash scripting that you will be
using frequently in this class.  

# Table of Contents
- [Bash](#bash)
- [Variables](#variables) 
- [If statement](#if-statement)
- [For loop](#for-loop)
- [Changing file content](#changing-file-content)
- ...

## Bash

Bash scripting is a great way to automate your computational tasks
and is used regularly by System Admins, Programmers, Data Scientists and many others to 
reduce the pain of having to do certain task manually many times.

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
STR="This is a bash variable";
printf "%s\n" "$STR"
```
Here, we have defined a bash variable named STR, which contains *This is a bash variable* as its value. We can use this variable by attaching a `$` to the beginning of it, hence in the second line `$STR` will be replaced by the value of STR variable.  
Note also that I have used `printf` function instead of `echo` to print. This is another way of prining in bash specially when you need a formatted output.  

## If statement

## For loop

## Changing file content



[back](../notes)
