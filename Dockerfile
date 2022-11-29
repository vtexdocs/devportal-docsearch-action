FROM python:3.6

COPY entrypoint.sh /entrypoint.sh

RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -y && apt-get install -y google-chrome-stable

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]