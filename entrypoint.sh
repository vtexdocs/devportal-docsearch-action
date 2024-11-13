#!/bin/sh -l
set -e

APPLICATION_ID=$1
API_KEY=$2
FILES=$3

# File changes in documentation repository
ADDED=$4
REMOVED=$5
UPDATED=$6
RENAMED=$7

# Build from the main source repository
git clone https://github.com/vtexdocs/docsearch-scraper.git

cd docsearch-scraper/

# Install pipenv
pip3 install pipenv==2018.11.26

# Download ChromeDriver
chromedriverStableVersion=$(curl -s 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE')
wget -q "https://chromedriver.storage.googleapis.com/${chromedriverStableVersion}/chromedriver_linux64.zip"

unzip chromedriver_linux64.zip
chown root:root chromedriver
chmod +x chromedriver

# Create the .env file for docsearch
echo "APPLICATION_ID=${APPLICATION_ID}
API_KEY=${API_KEY}
CHROMEDRIVER_PATH=/github/workspace/docsearch-scraper/chromedriver
ADDED_FILES=${ADDED}
REMOVED_FILES=${REMOVED}
UPDATED_FILES=${UPDATED}
RENAMED_FILES=${RENAMED}
" > .env

PIPENV_VENV_IN_PROJECT=true pipenv install --python 3.6

echo "Update webclient.py"
cp ./utils/webclient.py ./.venv/lib/python3.6/site-packages/scrapy/core/downloader/

# Loop through each file and run the scraper
for FILE in $(eval echo "$FILES"); do
  echo "🔍 Running scraper for $FILE"
  
  # Run the scraper and check if it was successful
  if yes | pipenv run ./docsearch run $FILE; then
    # Print success message only if the file was processed successfully
    echo "✅ Successfully indexed and uploaded the results for $FILE to Algolia"
  else
    # Print error message if the scraper failed for the file
    echo "❌ Failed to index and upload results for $FILE"
  fi
done

# Capture errors (if any) and append to output
if [ -f ./outputs/errors.txt ]; then
  errors=$(cat ./outputs/errors.txt)
  echo "errors=$errors" >> "$GITHUB_OUTPUT"
fi