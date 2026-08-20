import os
from PIL import Image
from config import BASE_DIR
import subprocess


# ---------------- Python Functions ----------------

def heat_map(folder_in, folder_out, img_name):
    """
    Applies a simple heat-map filter to a JPEG image.

    Input:
    - folder_in: directory containing the original images
    - folder_out: directory where the processed images are saved
    - img_name: image filename

    The filter recolors each pixel based on its intensity:
    - dark pixels    -> blue
    - medium pixels  -> yellow
    - bright pixels  -> red

    Returns:
    - image width
    - image height
    """
    filename = os.path.basename(img_name)

    file_in = os.path.join(folder_in, filename)
    file_out = os.path.join(folder_out, filename)

    img = Image.open(file_in).convert("RGB")
    pixels = img.load()

    for y in range(img.height):
        for x in range(img.width):
            r, g, b = pixels[x, y]
            intensity = (r + g + b) // 3

            if intensity < 80:
                new_pixel = (0, 0, 255)       # blue
            elif intensity < 160:
                new_pixel = (255, 255, 0)     # yellow
            else:
                new_pixel = (255, 0, 0)       # red

            pixels[x, y] = new_pixel

    img.save(file_out)

    return img.width, img.height


# ---------------- START CODING FROM HERE; DO NOT CHANGE THE CODE ABOVE THIS LINE ----------------


# TODO 1: create a new directory called filtered_images. 
# This directory should be located within the task-2 directory and outside the images directory.

os.chdir("./images")


# TODO 2: find all the files that end with .jpg in the images folder
# and store it in a python List variable called images.
# Similarly store a list of all the files in the directory in a python variable called all_files.
# both lists should be sorted in alphabetical/ascending order.
# Example file path:
# ./example.jpg

images = []

all_files = []

# ---------------- DO NOT CHANGE THESE LINES -------------------------------------------------------------------
ouptut_path = os.path.join(
    os.environ["PYTHON_STUDY"],
    "task-2",
    "outputs",
    "images.txt"
)
with open(ouptut_path, "a") as images_file:
    for imag in images:
        images_file.write(imag + "\n")

all_files_path = os.path.join(
    os.environ["PYTHON_STUDY"],
    "task-2",
    "outputs",
    "all_files.txt"
)
with open(all_files_path, "a") as all_files_file:
    for file in all_files:
        all_files_file.write(file + "\n")
# ---------------------------------------------------------------------------------------------------------------


folder_images_path = "./"
folder_filtered_images_path = "../filtered_images/"

imgs_height_sum = 0
imgs_width_sum = 0
num_img_files_processed = 0

for img in images:
    img_width, img_height = heat_map(folder_images_path, folder_filtered_images_path, img)
    imgs_height_sum += img_height
    imgs_width_sum += img_width
    num_img_files_processed += 1


# ---------------- Report Generation ----------------


# TODO 3: Calculate the total number of files in the images folder
# and then write report_str to the file report.txt.
#
# The file report.txt should be located outside the images folder
# and should be in the given outputs folder.


tot_files = 0  # TODO

skipped = tot_files - num_img_files_processed

if num_img_files_processed != 0:
    avg_height = imgs_height_sum / num_img_files_processed
    avg_width = imgs_width_sum / num_img_files_processed
else:
    avg_height = 0
    avg_width = 0

report_str = (
    "Image Processing Report \n"
    "==========================\n"
    "Total files found: %d \n"
    "Image files processed: %d \n"
    "Files skipped: %d \n"
    "Average image width: %.2f \n"
    "Average image height: %.2f\n"
) % (
    tot_files,
    num_img_files_processed,
    skipped,
    avg_width,
    avg_height,
)
