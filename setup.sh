#!/bin/bash
chmod +x tst
if [ -z `which tst | grep "/"` ]; then
    cp tst ~/.local/bin/tst
    exit 1
elif [ ! -z `find -path "*.local/bin/tst"` ]; then
    read -p "tst is exist in ~/.local/bin, do you want to replace it? [y/n]: " answer
    if [ $answer == "y" ]; then
        cp tst ~/.local/bin/tst
        exit 1
    else
        exit 1
    fi
else
    echo -e "\033[31mERROR:\033[0m"
    echo "tst is already exist in PATH but not in ~/.local/bin"
    echo "Continuing can cause conflict, exiting..."
    exit 1
fi