# Specific Documentation Resources Required for this Task

This page contains links to documentation that may be useful while completing this PEPPER tasks.

## Shell Command Documentation

### chmod

The `chmod` command changes the permissions of files and directories.
`chmod` takes a single file as an argument. For example:

```bash
chmod 755 file1.sh
```

Man page:

https://man7.org/linux/man-pages/man1/chmod.1.html

---

### find

The `find` command searches for files and directories based on conditions such as name, type, or permissions.

Man page:

https://man7.org/linux/man-pages/man1/find.1.html

Example: Find all Python files in the current directory.

```bash
find . -type f -name "*.py"
```
Example: Find files with specific permissions.

```bash
find . -type f -perm 777
```
---

### cat

The `cat` command displays the contents of files or combines multiple files.

Man page:

https://man7.org/linux/man-pages/man1/cat.1.html

---

### sort

The `sort` command sorts lines of text files or command output.
On its own with no arguments, `sort` arranges lines in alphabetical order by comparing characters left to right.

Example:

list.txt is:

```text
apple
aapple
banana
10
2
```

Then `sort list.txt` returns:

```text
10
2
aapple
apple
banana
```

`10` comes before `2` because sort by default treats them as text in which case `1` (from `10`) comes before `2`.


Man page:

https://man7.org/linux/man-pages/man1/sort.1.html

---

### mkdir

The `mkdir` command creates new directories.

Man page:

https://man7.org/linux/man-pages/man1/mkdir.1.html

---

### echo

The command `echo` displays a line of text.

Man page:

https://man7.org/linux/man-pages/man1/echo.1.html

---

### grep 

The command `grep` prints lines that match patterns.

Man page:

https://man7.org/linux/man-pages/man1/grep.1.html 




