#!/bin/bash

# =========================================================
# Validation Script for Server Incident Analyzer Task
# =========================================================

# --- Step 1: Run Cleanup ---
if [ -f "./cleanup.sh" ]; then
    bash ./cleanup.sh
else
    echo "[WARNING] 'cleanup.sh' not found. Skipping cleanup."
    echo "--------------------------------------------------"
fi

# --- Step 2: Run Python Script ---
python3.13 python_template.py

# --- Step 3: Run Validations ---
echo " "
echo "Running validations..."
echo "--------------------------------------------------"

SOLUTION_DIR="../Python-runtime/Checks/outputs/reading_task"
OUTPUT_DIR="./outputs"
ARCHIVE_DIR="./archive"

# Helper function: Returns the file path if it exists in archive or outputs, prioritizing archive
find_file() {
    local filename="$1"
    if [ -f "$ARCHIVE_DIR/$filename" ]; then
        echo "$ARCHIVE_DIR/$filename"
    elif [ -f "$OUTPUT_DIR/$filename" ]; then
        echo "$OUTPUT_DIR/$filename"
    else
        echo ""
    fi
}

# --- Validate Tasks 1 & 2 (logs.txt & sorted_report.txt) ---

# Check logs.txt (accepts either ./archive or ./outputs)
ERROR_LOGS_PATH=$(find_file "logs.txt")

if [ -n "$ERROR_LOGS_PATH" ]; then
    # Check if it matches complete solution (Task 1 AND 2)
    if [ -f "$SOLUTION_DIR/logs.txt" ] && diff -b -B -u "$ERROR_LOGS_PATH" "$SOLUTION_DIR/logs.txt" > /dev/null; then
        echo "[PASS] Tasks 1 & 2: 'logs.txt' matches final solution (found at $ERROR_LOGS_PATH)."
    elif [ -f "$SOLUTION_DIR/logs-other-2.txt" ] && diff -b -B -u "$ERROR_LOGS_PATH" "$SOLUTION_DIR/logs-other-2.txt" > /dev/null; then
        echo "[PASS] Tasks 1 & 2: 'logs.txt' matches final solution (found at $ERROR_LOGS_PATH)."
    # Check if it matches partial solution (Task 1 ONLY)
    elif [ -f "$SOLUTION_DIR/logs1.txt" ] && diff -b -B -u "$ERROR_LOGS_PATH" "$SOLUTION_DIR/logs1.txt" > /dev/null; then
        echo "[PASS] Task 1: 'logs.txt' matches Task 1 solution."
        echo "[FAIL] Task 2: 'logs.txt' is incomplete (does not match full Task 2 solution)."
    elif [ -f "$SOLUTION_DIR/logs-other-1.txt" ] && diff -b -B -u "$ERROR_LOGS_PATH" "$SOLUTION_DIR/logs-other-1.txt" > /dev/null; then
        echo "[PASS] Task 1: 'logs.txt' matches Task 1 solution."
        echo "[FAIL] Task 2: 'logs.txt' is incomplete (does not match full Task 2 solution)."
    else
        echo "[FAIL] Tasks 1 & 2: 'logs.txt' differs from solutions."
    fi
else
    echo "[FAIL] Tasks 1 & 2: Missing 'logs.txt' in both '$OUTPUT_DIR' and '$ARCHIVE_DIR'."
fi

# --- Validate Task 3 (Archive Existence & File Locations) ---

if [ -d "$ARCHIVE_DIR" ]; then
    # Check if both required files exist inside archive/
    if [ -f "$ARCHIVE_DIR/logs.txt" ] && [ -f "$ARCHIVE_DIR/sorted_report.txt" ]; then
        # Ensure no .txt files are left behind in outputs/
        TXT_IN_OUTPUTS=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.txt" 2>/dev/null | wc -l)
        
        if [ "$TXT_IN_OUTPUTS" -eq 0 ]; then
            echo "[PASS] Task 3: 'archive/' exists with 'logs.txt' and 'sorted_report.txt', and 'outputs/' is clean."
        else
            echo "[FAIL] Task 3: Found $TXT_IN_OUTPUTS .txt file(s) remaining in '$OUTPUT_DIR' (expected 0)."
        fi
    else
        echo "[FAIL] Task 3: 'archive/' directory exists, but is missing 'logs.txt' or 'sorted_report.txt'."
    fi
else
    echo "[FAIL] Task 3: Directory '$ARCHIVE_DIR' does not exist."
fi

echo "--------------------------------------------------"
echo "Validation complete."
echo " "