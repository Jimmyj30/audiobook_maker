FROM nvcr.io/nvidia/cuda:12.0.0-runtime-ubuntu22.04

# Specify a workdir, to better organize your files inside the container. 
WORKDIR /audiobook_maker

# Update package lists and install required packages
RUN apt-get update && \
    apt-get install -y wget software-properties-common gnupg2 winbind xvfb


# ************ Wine Setup ************

# Add Wine repository and install Wine
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    apt-get update && \
    apt-get install -y winehq-stable

# Install additional packages and configure Wine
RUN apt-get install -y winetricks && \
    winetricks msxml6

# Cleanup unnecessary files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV WINEDEBUG=fixme-all


# Setup python
RUN apt-get update && \
    apt-get install -y python3-pip python3-venv 


#  Setup other packages
RUN apt-get update && \
    apt-get install -y git ffmpeg p7zip


COPY . . 

