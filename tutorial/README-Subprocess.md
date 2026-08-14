Welcome to the Subprocess and OS tutorial.

Python provides built-in modules for interacting with the operating system and executing command-line tools. The subprocess module allows Python programs to execute command-line programs and compose command-line workflows, while the os module provides functions for interacting with the filesystem and operating system.

This tutorial introduces the core Python features needed for the study tasks:

- Running Shell Commands in Python
- Using Shell Output in Python
- Using Pipes and Redirection
- Using Python Output in Shell Commands
- Using os for Filesystem Operations
- Documentation and Man Pages

# Running Shell Commands in Python

Python can execute command-line programs using the `subprocess` module.

import the module and use `subprocess.run()` to execute a simple command:

```Python
import subprocess
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
os.chdir("..")
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










































