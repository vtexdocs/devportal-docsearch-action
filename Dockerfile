FROM python:3.6

COPY entrypoint.sh /entrypoint.sh

USER root
CMD /bin/bash


RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add

RUN apt-get update
RUN apt-get -y install software-properties-common

RUN curl -s 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' > root/tmp_file

RUN sed -i "/^# deb.*universe/ s/^# //" /etc/apt/sources.list

RUN apt-get update
RUN VARIABLE=$(cat /root/tmp_file); wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${VARIABLE}-1_amd64.deb \
  && apt-get install -y -f /tmp/chrome.deb \
  && rm /tmp/chrome.deb

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]