# We assume 'ubuntu:17.04' has been loaded locally via 'docker load'
FROM ubuntu:17.04

# --- Dependency Installation from Local Files ---

# Copy our complete set of pre-downloaded .deb files into the image.
COPY debs/ /debs/

# Install them all using dpkg. This is now fully offline.
# The dos2unix package is now included in this installation step.
RUN dpkg -i /debs/*.deb

# --- Build ezthumb from Local Source ---

WORKDIR /usr/src/app

# Copy the pre-downloaded ezthumb source code into the image
COPY source/ezthumb-3.6.7.tar.bz2 .

# Extract, configure, compile, and install
RUN tar -xvjf ezthumb-3.6.7.tar.bz2 && \
    rm ezthumb-3.6.7.tar.bz2
WORKDIR /usr/src/app/ezthumb-3.6.7
RUN ./configure CPPFLAGS="-I/usr/include/freetype2" && make && make install
RUN rm -rf /usr/src/app


# --- Final Configuration ---

# Copy and set up our process.sh script
COPY process.sh /usr/local/bin/process.sh

# The dos2unix command is now available from the .deb packages we installed above.
# We no longer need to use apt-get to install it here.
RUN dos2unix /usr/local/bin/process.sh && \
    chmod +x /usr/local/bin/process.sh

WORKDIR /data
ENTRYPOINT ["process.sh"]