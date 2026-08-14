
# Introduction to Shell Commands

Subrpocess allows Python programs to call shell commands. 

A shell is a program that provides an interface for interacting with the operating system through commands.

For example, the `ls` command displays files in a directory.

Example directory:

```
project/
├── server.log
├── config.yaml
├── data.csv
└── README.md
```

Running:

```bash
ls
```

produces:

```
server.log
config.yaml
data.csv
README.md
```

One interesting observation is that everything in the Shell is a String ! The Shell has no data types which means that all output from all commands are string. 

---

## Common Shell Commands

### Listing files

```bash
ls
```

Returns the files in the current directory.

---

### Finding the current directory

```bash
pwd
```

Returns the current directory path.

Example:

```
/home/student/project
```

---

### Reading file contents

```bash
cat server.log
```

Cat displays the contents of a file (in this case server.log).

Example output:

```
INFO server started
ERROR database failed
```

As you can see shell commands follow the rough structure of:

Command Arguments

Commands we saw above were `ls`, `cat`, `pwd`.

Arguments are optional and in the example above `server.log` was an argument. 

---

### Searching text

```bash
grep ERROR server.log
```

Returns lines containing the text `ERROR`.

Example output:

```
ERROR database failed
ERROR timeout
```

Here we passed 2 arguments to grep: `ERROR` and `server.log`.

### Using Flags

Many shell commands accept **flags**, which modify how the command behaves.

The `-i` flag tells `grep` to ignore uppercase and lowercase differences.

```bash
grep -i error server.log
```

Example output:

```text
ERROR database failed
Error connection refused
error timeout
```

Here:

- `-i` is a flag. Note the spacing: `- i` would be invalid. 
- `error` is the text to search for.
- `server.log` is the file being searched.

## File Paths

Most shell commands operate on **paths**, which tell the shell where a file or directory is located.

### Relative Paths

A **relative path** is interpreted relative to your current working directory (the directory returned by `pwd`).

For example, if your current directory is:

```text
/home/alice/projects
```

then:

```bash
cat data/input.csv
```

refers to:

```text
/home/alice/projects/data/input.csv
```

Similarly:

```bash
cd scripts
```

moves into the `scripts` directory inside the current directory.

### Absolute Paths

An **absolute path** specifies the complete location of a file or directory, starting from the root directory (`/`).

For example:

```bash
cat /home/alice/projects/data/input.csv
```

always refers to the same file, regardless of your current working directory.

### Special Path Symbols

The shell also provides several useful shortcuts:

| Symbol | Meaning             |
| ------ | ------------------- |
| `.`    | Current directory   |
| `..`   | Parent directory    |
| `~`    | Your home directory |

Examples:

```bash
cd ..
```
Moves to the parent directory.

```bash
ls .
```
Lists the contents of the current directory.

```bash
cd ~/Downloads
```
Navigates to the `Downloads` folder inside your home directory.