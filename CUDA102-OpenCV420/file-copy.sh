#!/bin/bash


set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


FILE=Video_Codec_SDK_9.1.23.zip

if [ ! -f ~/$FILE ]; then
    echo "File not found!"
    cp /media/$USER/CUDA/CUDAFILES/$FILE ~/
fi

