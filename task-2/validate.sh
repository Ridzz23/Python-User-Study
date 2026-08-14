#!/bin/bash

# =========================================================
# Strict Diff/Validation Script for Image Processing Task
# =========================================================

# --- Step 1: Run Cleanup ---
if [ -f "./cleanup.sh" ]; then
    bash ./cleanup.sh
else
    echo "[WARNING] 'cleanup.sh' not found. Skipping cleanup."
    echo "--------------------------------------------------"
fi

# --- Step 2: Run Python Script ---
PyPepper pepper_template.py

echo " "
echo "Running validations..."
echo "--------------------------------------------------"

# Define paths
SOLUTION_DIR="../pepper/Checks/outputs/coding_task"
OUTPUT_DIR="./outputs"
FILTERED_DIR="./filtered_images"


# --- Validate TODO 1: Directory creation ---
if [ -d "$FILTERED_DIR" ]; then
    echo "[PASS] TODO 1: Directory 'filtered_images' exists."
else
    echo "[FAIL] TODO 1: Directory 'filtered_images' does NOT exist."
fi

# --- Validate TODO 2: File listings (images.txt & all_files.txt) ---
if [ -f "$OUTPUT_DIR/images.txt" ]; then
    MATCH_FOUND=0

    # diff -b -B ignores changes in whitespace amount and ignores blank lines/extra newlines
    if [ -f "$SOLUTION_DIR/images1.txt" ] && diff -b -B -u "$OUTPUT_DIR/images.txt" "$SOLUTION_DIR/images1.txt" > /dev/null; then
        MATCH_FOUND=1
    fi

    if [ -f "$SOLUTION_DIR/images2.txt" ] && diff -b -B -u "$OUTPUT_DIR/images.txt" "$SOLUTION_DIR/images2.txt" > /dev/null; then
        MATCH_FOUND=1
    fi

    if [ $MATCH_FOUND -eq 1 ]; then
        echo "[PASS] TODO 2: 'images.txt' matches solution exactly."
    else
        echo "[FAIL] TODO 2: 'images.txt' differs from solution."
    fi
else
    echo "[FAIL] TODO 2: Missing 'outputs/images.txt' for comparison."
fi

if [ -f "$OUTPUT_DIR/all_files.txt" ] && [ -f "$SOLUTION_DIR/all_files.txt" ]; then
    if diff -b -B -u "$OUTPUT_DIR/all_files.txt" "$SOLUTION_DIR/all_files.txt" > /dev/null; then
        echo "[PASS] TODO 2: 'all_files.txt' matches solution exactly."
    else
        echo "[FAIL] TODO 2: 'all_files.txt' differs from solution."
    fi
else
    echo "[FAIL] TODO 2: Missing 'outputs/all_files.txt' for comparison."
fi

# --- Validate Processed Images ---
if [ -d "$FILTERED_DIR" ] && [ -d "$SOLUTION_DIR/filtered_images" ]; then
    DIFF_IMAGES_FAILED=0
    for img in "$SOLUTION_DIR/filtered_images"/*.jpg; do
        filename=$(basename "$img")
        if [ -f "$FILTERED_DIR/$filename" ]; then
            if ! cmp -s "$FILTERED_DIR/$filename" "$img"; then
                echo "       [MISMATCH] $filename does not match solution image."
                DIFF_IMAGES_FAILED=1
            fi
        else
            echo "       [MISSING] $filename missing from '$FILTERED_DIR'."
            DIFF_IMAGES_FAILED=1
        fi
    done

    if [ $DIFF_IMAGES_FAILED -eq 0 ]; then
        echo "[PASS] Processed images in 'filtered_images' match solution images exactly."
    else
        echo "[FAIL] Processed images do not match solution."
    fi
else
    echo "[FAIL] Directory 'filtered_images' is missing for image validation."
fi


# --- Validate TODO 3: Report generation ---
if [ -f "$OUTPUT_DIR/report.txt" ] && [ -f "$SOLUTION_DIR/report.txt" ]; then
    if diff -b -B -u "$OUTPUT_DIR/report.txt" "$SOLUTION_DIR/report.txt" > /dev/null; then
        echo "[PASS] TODO 3: 'report.txt' matches solution exactly."
    else
        echo "[FAIL] TODO 3: 'report.txt' differs from solution."
    fi
else
    echo "[FAIL] TODO 3: Missing 'outputs/report.txt' for comparison."
fi

echo "--------------------------------------------------"
echo "Validation complete."
echo " "