#!/bin/sh -l
set -e

APPLICATION_ID=$1
API_KEY=$2
FILE=$3

#File changes in documentation repository
ADDED=$4
REMOVED=$5
UPDATED=$6
# build from the main source repository
git clone https://github.com/vtexdocs/docsearch-scraper.git

cd docsearch-scraper/

# install pipenv
pip3 install pipenv==2018.11.26

# download chromedriver

chromedriverStableVersion=$(curl -s 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE')

wget -q "https://chromedriver.storage.googleapis.com/${chromedriverStableVersion}/chromedriver_linux64.zip"

unzip chromedriver_linux64.zip
chown root:root chromedriver
chmod +x chromedriver

# create the .env file for docsearch
echo "APPLICATION_ID=${APPLICATION_ID}
API_KEY=${API_KEY}
CHROMEDRIVER_PATH=/github/workspace/docsearch-scraper/chromedriver
ADDED_FILES=${ADDED}
REMOVED_FILES=${REMOVED}
UPDATED_FILES=${UPDATED}
" > .env

PIPENV_VENV_IN_PROJECT=true pipenv install

echo "Update webclient.py"
cp ./utils/webclient.py ./.venv/lib/python3.6/site-packages/scrapy/core/downloader/

pipenv run ./docsearch run $FILE

echo "errors=$(cat ./outputs/errors.txt)" >> "$GITHUB_OUTPUT"

echo "🚀 Successfully indexed and uploaded the results to Algolia"