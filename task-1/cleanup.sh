
if [ -f ./outputs/sorted_report.txt ]; then
    rm ./outputs/sorted_report.txt
fi

if [ -f ./outputs/logs.txt ]; then
    rm ./outputs/logs.txt
fi

if [ -d ./archive ]; then
    rm -r ./archive
fi

if [ ! -d "./outputs" ]; then
    mkdir "./outputs"
fi