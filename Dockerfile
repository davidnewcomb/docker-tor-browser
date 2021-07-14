FROM jlesage/baseimage-gui:ubuntu-18.04

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ bionic main" >>  /etc/apt/sources.list
RUN > /var/lib/dpkg/statoverride

# Set environment variables
ENV TOR_VERSION=10.5.2
ENV APP_NAME="Tor Browser ${TOR_VERSION}" \
    TOR_BINARY=https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    TOR_SIGNATURE=https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
    TOR_FINGERPRINT=0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 \
    PATH="/app/host/bin:${PATH}" \
    DEBIAN_FRONTEND=noninteractive

# Install Tor onion icon
RUN install_app_icon.sh "https://github.com/DomiStyle/docker-tor-browser/raw/master/icon.png"

# Add wget and Tor browser dependencies
RUN apt-get update && \
    sed 's/ messagebus / root /' /var/lib/dpkg/statoverride > tmp && \
    mv tmp /var/lib/dpkg/statoverride && \
    apt-get install -y wget gpg libdbus-glib-1-2 libgtk-3-0 pulseaudio vlc p7zip-full p7zip-rar vim xclip  && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download binary and signature
RUN wget $TOR_BINARY && \
    wget $TOR_SIGNATURE

# Verify GPG signature
RUN gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org && \
    gpg --output ./tor.keyring --export $TOR_FINGERPRINT && \
    gpgv --keyring ./tor.keyring "${TOR_SIGNATURE##*/}" "${TOR_BINARY##*/}"

# Extract browser & cleanup
RUN tar --strip 1 -xvJf "${TOR_BINARY##*/}" && \
    chown -R ${USER_ID}:${GROUP_ID} /app && \
    rm "${TOR_BINARY##*/}" "${TOR_SIGNATURE##*/}"

# Copy browser cfg
COPY browser-cfg /browser-cfg

COPY pulse-client.conf /etc/pulse/client.conf

# Using as a client only at the moment
#COPY pulse-default.pa /etc/pulse/default.pa

# Add start script
COPY startapp.sh /startapp.sh
