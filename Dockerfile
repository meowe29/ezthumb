# Stage 1: Use the required Ubuntu 17.04 base image
FROM ubuntu:17.04

# --- Dependency Installation (from local files) ---

# We no longer need to edit sources.list or run apt-get update!
# We just need to install the tools to unpack our local packages.
RUN apt-get update && apt-get install -y dpkg-dev

# Copy our pre-downloaded .deb files into the image
COPY debs/ /debs/

# Install all the .deb packages using dpkg.
# This is more robust than a simple `dpkg -i *.deb`. It will handle dependency order.
WORKDIR /debs
RUN dpkg -i *.deb || apt-get -f install -y && rm -rf /var/lib/apt/lists/*


# --- Download and Build (from local files) ---

# Set a working directory for the build
WORKDIR /usr/src/app

# Copy the pre-downloaded ezthumb source code into the image
COPY source/ezthumb-3.6.7.tar.bz2 .

# Extract, configure, compile, and install (same as before)
RUN tar -xvjf ezthumb-3.6.7.tar.bz2 && \
    rm ezthumb-3.6.7.tar.bz2
WORKDIR /usr/src/app/ezthumb-3.6.7
RUN ./configure CPPFLAGS="-I/usr/include/freetype2" && make && make install
RUN rm -rf /usr/src/app


# --- Final Configuration ---

# Copy, fix, and set up our process.sh script (same as before)
COPY process.sh /usr/local/bin/process.sh
RUN chmod +x /usr/local/bin/process.sh && dos2unix /usr/local/bin/process.sh
WORKDIR /data
ENTRYPOINT ["process.sh"]