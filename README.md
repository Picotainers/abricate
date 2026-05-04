# abricate
Source-installed `abricate` container.

## Quick Usage

```bash
# Pull the image
docker pull docker.io/picotainers/abricate:latest

# Run the tool
docker run --rm docker.io/picotainers/abricate:latest abricate --help
```

## Additional Example

```bash
docker run --rm -v "$(pwd):/data" docker.io/picotainers/abricate:latest abricate --help
```
