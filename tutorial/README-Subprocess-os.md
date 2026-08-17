# Subprocess and OS Tutorial

Welcome to the Subprocess and OS tutorial.

Python provides built-in modules for interacting with the operating system and executing command-line tools. The subprocess module allows Python programs to execute command-line programs and compose command-line workflows, while the os module provides functions for interacting with the filesystem and operating system.

This tutorial introduces the core Python features needed for the study tasks:

- Running Shell Commands in Python
- Using Shell Output in Python
- More Shell Operators
- Using Python Output in Shell Commands
- Documentation and Man Pages

# Modules Used in This Study

This study primarily uses two Python modules for interacting with the
operating system:

- `subprocess` — execute Shell commands and connect their input/output.
- `os` — perform common filesystem and operating-system operations.

Import them using:

```python
import subprocess
import os
```

# 1. Running Shell Commands in Python

Python can execute command-line programs using the `subprocess` module.

Use `subprocess.run()` to execute a simple command:

```Python
subprocess.run(["mkdir", "./results"])
```

This is equivalent to running the following command in a terminal:

```Bash
mkdir ./results
```

Each element in the list represents one part of the command:
```python
["mkdir", "./results"]
```

## Shell Commands with Flags

Flags are also passed as separate elements:

```python
subprocess.run(["ls", "-l"])
```

is equivalent to:

```bash
ls -l
```

The command `ls -l` is a normal shell command where `ls` is the command, `-l` is a flag that changes the behaviour of the command.
The `-l` flag tells `ls` to produce a detailed (long) listing that includes information such as file permissions, ownership, size, and modification time.

Example Shell output:
```bash
-rw-r--r--  1 user staff   1200 Jul 24 10:30 server.log
-rw-r--r--  1 user staff    450 Jul 24 10:31 config.yaml
-rw-r--r--  1 user staff   2300 Jul 24 10:32 data.csv
```

## Running Standalone Shell Commands

In addition to using shell commands to produce output that can be processed by Python, Python also allows shell commands to be executed for their side effects using the `subprocess` module.

For example, you can directly execute:

```python
import subprocess

subprocess.run(["mkdir", "./folder"])
```

This is equivalent to running the following command in a terminal:
```bash
mkdir ./folder
```

Similarly:

```python
subprocess.run(["cd", ".."])
```

is equivalent to the following in shell:

```bash
cd ..
```

However, commands such as cd behave differently when executed through subprocess. 
Each subprocess.run() call normally runs in a separate process, so changing the working directory with cd does not change the working directory of the Python program.

To change the Python program's working directory, use os.chdir() instead:

```python
import os
os.chdir("<folder-name>")
```

For commands whose output you do not need to process in Python, you can simply execute them with subprocess.run():

```python
import subprocess

subprocess.run(["mkdir", "./results"])
subprocess.run(["chmod", "755", "./script.sh"])
```
These commands are being executed for their side effects. No command output is being stored in a Python variable.

For commands whose output you want to process in Python, capture the output:

```python
import subprocess

result = subprocess.run(
    ["ls"],
    capture_output=True,
    text=True,
    check=True
)

files = result.stdout.splitlines()
```

### Mental Model

```
Shell command with no output needed
-----------------------------------
subprocess.run(["mkdir", "./results"])

Shell runs
     |
     v
Side effect occurs
     |
     v
No Python value is created
```

```
Shell command with output
-------------------------
result = subprocess.run(..., capture_output=True)

Shell runs
     |
     v
Output
     |
     v
result.stdout
     |
     v
Python code processes the output
```

# 2. Using Shell Output in Python

Shell commands often produce output that you want to use in your Python program.

The subprocess module allows you to capture command output using capture_output=True:

```python
import subprocess

result = subprocess.run(
    ["ls"],
    capture_output=True,
    text=True
)
```

The command's output is stored in `result.stdout`.

For example, if the directory contains:

```text
main.py
data.csv
results.txt
```

then `result.stdout` contains:

```text
main.py
data.csv
results.txt
```
as a Python `str`.

If you want to work with individual lines, use `splitlines()`:

```python
files = result.stdout.splitlines()
```

Now `files` is:

```python
[
    "main.py",
    "data.csv",
    "results.txt"
]
```

It can be iterated through like any other Python list:

```python
for file in files:
    print(file)
```
## Checking for Errors

You can use `check=True` to make Python raise an error if the command fails:

```python
result = subprocess.run(
    ["ls", "./server_snapshot"],
    capture_output=True,
    text=True,
    check=True
)
```

# 3. More Shell Operators

Python can use the `subprocess` module to reproduce common Shell operators such as pipes, output redirection, and append redirection.
Subprocess provides mechanisms for connecting processes and files.

## Pipelines

In a traditional Shell, the pipe operator (`|`) passes the output of one command as the input to another command.

For example:
```bash
cat data.txt | grep ERROR
```

with `subprocess`, use the input field and `.stdout` to pass data along the pipe: 
```python
import subprocess

cat = subprocess.run(
    ["cat", "data.txt"],
    capture_output=True,
    text=True
)

grep = subprocess.run(
    ["grep", "ERROR"],
    input=cat.stdout,
    capture_output=True,
    text=True
)

errors = grep.stdout
```

The output from `cat` is passed directly to `grep`.

Pipelines can contain multiple commands. For example:

```bash
cat server.log | grep WARNING | sort
```

can be written as:
```python
import subprocess

cat = subprocess.run(
    ["cat", "server.log"],
    stdout=subprocess.PIPE,
    text=True
)

grep = subprocess.run(
    ["grep", "WARNING"],
    input=cat.stdout,
    stdout=subprocess.PIPE,
    text=True
)

sort = subprocess.run(
    ["sort"],
    input=grep.stdout,
    capture_output=True,
    text=True
)

warnings = sort.stdout
```

Here, the data flow through the pipeline is:

```
cat
 |
 v
grep
 |
 v
sort
 |
 v
Python
```

## Output Redirection

The shell output redirection operator (>) writes the output of a Shell command to a file:
```bash
ls > files.txt
```

with `subprocess`, open the file and pass it as the command's `stdout`:
```python
import subprocess

with open("files.txt", "w") as f:
    subprocess.run(
        ["ls"],
        stdout=f,
        check=True
    )
```

This runs ls and writes its output to files.txt.
If file.txt does not exist then this creates the file first. 

## Append Redirection

The shell append redirection operator (>>) adds output to the end of an existing file instead of overwriting it:
```bash
echo "ERROR" >> errors.txt
```

with `subprocess`, open the file using append mode:
```python
import subprocess

with open("errors.txt", "a") as f:
    subprocess.run(
        ["echo", "ERROR"],
        stdout=f,
        check=True
    )
```

The important difference is the file mode:
```python
open("file.txt", "w")
```
overwrites the file.

While,
```python
open("file.txt", "a")
```
appends to the file.

### Mental Model

```
Shell:
command | command > file

Python:
subprocess.PIPE
       |
       v
connect processes
       |
       v
stdout=file
```

# 4. Using Python Output in Shell

Python values can be passed to Shell commands using `subprocess`. This allows Python code to prepare data and then pass it to command-line tools.

## Python variables as Shell Arguments

A Python variable can be passed as an argument to a Shell command:
```python
import subprocess

var = "hi"

subprocess.run(["echo", var])
```

This is equivalent to running:
```bash
echo "hi"
```

Each argument should be a separate element in the list:
```python
subprocess.run(["chmod", "755", filename])
```

Here:

- "chmod" is the command
- "755" is an argument
- filename is a Python variable whose value is passed as another argument

## Python value as Shell Input

Python values can also be passed to a command through its standard input.

For example:

```python
import subprocess

messages = [
    "ERROR: database failed",
    "INFO: server started",
    "ERROR: timeout"
]

text = "\n".join(messages)

result = subprocess.run(
    ["grep", "ERROR"],
    input=text,
    capture_output=True,
    text=True
)
```

The Shell receives:
```text
ERROR: database failed
INFO: server started
ERROR: timeout
```

and grep produces:
```
ERROR: database failed
ERROR: timeout
```

## Formatting Python Values
When passing Python data to a Shell command, it is important to format the data in the way the command expects.

For example, a Python list:
```python
messages = [
    "ERROR: database failed",
    "ERROR: timeout"
]
```
is not automatically converted into separate lines.

Instead, convert it to text explicitly:
```python
text = "\n".join(messages)
```
Then pass the resulting string to the command:
```python
subprocess.run(
    ["grep", "ERROR"],
    input=text,
    text=True
)
```


### Mental Model

```
Python value
     |
     v
Format as text
     |
     v
subprocess
     |
     v
Shell command
```

Python variables can therefore be used both as Shell command arguments and as input to Shell processes.


# 5. Documentation and Man Pages

The subprocess and os modules provide Python interfaces for interacting with the operating system, but many of the commands used in the study are standard Linux commands.

Existing Shell documentation can therefore be used when writing Python programs with subprocess.

For commonly used Linux commands, manual pages (man pages) provide detailed documentation about a command, including its purpose, available flags, arguments, and examples.
Man pages are available online through websites such as:

- https://man7.org/linux/man-pages/
- https://manpages.ubuntu.com/

To look up a command, search for the command name on the website.

For example, to learn about the `grep` command:

1. Open the man pages website.
2. Search for:

```text
grep
```

3. Open the manual page for `grep`. (Almost always the first link)

The page describes:

- what the command does
- the command syntax
- available flags
- examples of usage

For example, the documentation shows that the `-r` flag makes `grep` search recursively through directories.

Using this information, we can write:

```bash
grep -r "ERROR" logs/
```
where:  
- `grep` is the command  
- `-r` is a flag that changes the search behavior  
- `"ERROR"` is the text pattern to search for  
- `logs/` is the directory to search  

The equivalent Python code using subprocess is:

```python
import subprocess

subprocess.run(
    ["grep", "-r", "ERROR", "logs/"]
)
```
























































