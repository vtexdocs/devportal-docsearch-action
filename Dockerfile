FROM python:3.6

COPY entrypoint.sh /entrypoint.sh

USER root
CMD /bin/bash

RUN apt-get update -y && apt-get install -yq \
  unzip \
  xvfb \
  libxi6 \
  libgconf-2-4 \
  default-jdk \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatspi2.0-0 \
  libcups2 \
  libdbus-glib-1-2 \
  libgbm1 \
  libnspr4 \
  libnss3 \
  libxss1 \
  xdg-utils 

# https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable for references around the latest versions
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
# Download and unzip specific Chrome version
# For more information, see https://developer.chrome.com/docs/chromedriver/downloads/version-selection?hl=pt-br
# and https://stackoverflow.com/questions/54927496/how-to-download-older-versions-of-chrome-from-a-google-official-site

RUN apt-get update -y && apt-get install -yq \
    wget \
    unzip \
    && wget -q -O /tmp/chrome-linux.zip https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/1146059/chrome-linux.zip \
    && unzip /tmp/chrome-linux.zip -d /opt \
    && ln -s /opt/chrome-linux/chrome /usr/bin/google-chrome \
    && rm /tmp/chrome-linux.zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
