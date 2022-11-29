# Algolia Docsearch Action

This action runs the docsearch scraper and updates an index.

## Inputs

### `algolia_application_id`
**Required** Algolia docsearch `APPLICATION_ID`

### `algolia_api_key`
**Required** Algolia docsearch `API_KEY`

### `file`
**Required** File to specify the location of the scraper config. Select mdx or openapi config.

## Example usage

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    name: Scraper mdx files running
    steps:
    - uses: actions/checkout@v2
    - uses: vtexdocs/devportal-docsearch-action@main
      with:
        algolia_application_id: 'XXXXXXXXX'
        algolia_api_key: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx123'
        file: './configs/scraper_md.json'
```