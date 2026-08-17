import math
import subprocess
import os
# ---------------- Python Functions ----------------


def severity_score(error_count, response_time):
    """
    Calculates a severity score for a server.
    """

    return error_count * 2 + math.log(response_time + 1)


def classify(score):
    """
    Convert a severity score into a category.
    """

    if score > 50:
        return "CRITICAL"
    elif score > 20:
        return "WARNING"
    else:
        return "NORMAL"



# ---------------- START CODING FROM HERE; DO NOT CHANGE THE CODE ABOVE THIS LINE ----------------


# TODO 1: The monitoring team wants to analyze warning events instead of error events. Modify the script to process WARNING log entries instead of ERROR entries.

# TODO 2: The team wants to ignore logs from test, dev and other servers. Add a filtering step to the existing pipeline in logs so only production servers are analyzed. 
# Production servers contain the keyword server=prod such as: 
# server=prod-db1.


# Find log files


find_result = subprocess.run(
    ["find", "./logs", "-name", "*.log"],
    capture_output=True,
    text=True,
    check=True
)

log_files = find_result.stdout.splitlines()

logs_as_args = " ".join(log_files)


# Extracts ERROR log entries


grep_result = subprocess.run(
    ["grep", "WARNING", *log_files],
    capture_output=True,
    text=True,
    check=False
)


grep_prod = subprocess.run(
    ["grep", "server=prod"],
    input=grep_result.stdout,
    capture_output=True,
    text=True
)

logs = grep_prod.stdout.splitlines()


# ------------------------ DO NOT CHANGE THESE LINE -----------------------------------------------
output_path = os.path.join(
    os.environ["PYTHON_STUDY"],
    "task-1",
    "outputs",
    "logs.txt"
)

with open(output_path, "a") as output_file:
    for log in logs:
        output_file.write(log + "\n")
# -------------------------------------------------------------------------------------------------


# Parse shell output


incidents = []

for line in logs:

    if line == "":
        continue

    # Example:
    # ERROR server=prod-db1 latency=2500

    parts = line.split()

    server = parts[1].split("=")[1]

    latency = int(parts[2].split("=")[1])

    severity = severity_score(
        1,
        latency
    )

    incidents.append({

        "server": server,
        "severity": severity,
        "category": classify(severity)

    })


# Generate report


report = ""

for incident in incidents:

    report += (

        f"{incident['server']} "
        f"{incident['category']} "
        f"{incident['severity']:.2f}\n"

    )


# Sort report


sort_result = subprocess.run(
    ["sort"],
    input=report,
    capture_output=True,
    text=True,
    check=True
)

sorted_report = sort_result.stdout.splitlines()

# ------------------------ DO NOT CHANGE THESE LINE -------------------------------------------------------
output_path2 = os.path.join(
    os.environ["PYTHON_STUDY"],
    "task-1",
    "outputs",
    "sorted_report.txt"
)
with open(output_path2, "a") as output_file:
    for rep in sorted_report:
        output_file.write(rep + "\n")
# ----------------------------------------------------------------------------------------------------------


# TODO 3: The operations team wants generated reports organized.
# Create a directory called archive/
# Move every .txt report from the outputs/ directory into archive/. 
# Leave other files (such as JSON reports) unchanged.

subprocess.run(["mkdir", "./archive"])
subprocess.run(['mv', './outputs/logs.txt', './archive/'])
subprocess.run(['mv', './outputs/sorted_report.txt', './archive/'])
