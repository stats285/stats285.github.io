---
layout: default
---

_This tutorial is contributed by Hatef Monajemi (@monajemi)_

The following tutorial is intended to familiarize you with writing Bash scripts. 
We will review the core elements of Bash scripting that you will be
using frequently in this class.  

# Table of Contents
- [Bash](#bash)
- [Variables](#variable) 
- [If statement](#if-statement)
- [For loop](#for-loop)
- [Changing file contents](#change-file-content)
- ...

## [](#bash) Bash

Bash scripting is a great way to automate your computational tasks
and is used regularly by System Admins, Programmers, Data Scientists and many others to 
reduce the pain of having to do certain task many times.

Here is how a Bash script may look like:

```bash
#!/bin/bash
# File: bashMain.sh
# STATS 285, 2017

# Write some commands to be executed
echo "I am bash scripting"
echo "I am currently in:"
pwd
echo "Here is a list of the contents of this directory:"
ls -lt
```

As you may have noticed, you are already familiar with these commands and perhaps have typed 
them in your terminal before. A bash script is just a text file (`bashMain.sh` in this example) that contains these commands
so you don't have to type them each time. Instead, you just execute all the commands at once by 
writing `./bashMain.sh` or `bash bashMain.sh` in a terminal.


## [](#variables) Variables

## [](#if-statement) If statement

## [](#for-loop) For loop

## [](#change-file-content) Changing file content



[back](./)
