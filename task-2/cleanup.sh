if [ -f ./outputs/images.txt ]; then
    rm ./outputs/images.txt
fi

if [ -f ./outputs/all_files.txt ]; then
    rm ./outputs/all_files.txt
fi

if [ -f ./outputs/report.txt ]; then
    rm ./outputs/report.txt
fi

if [ -d ./filtered_images ]; then
    rm -rf ./filtered_images
fi

if [ ! -d "./outputs" ]; then
    mkdir "./outputs"
fi