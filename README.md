Experimental Docker image providing JPEG-XL tools
=================================================

# Building

## LibJXL

```
docker buildx build -t ghcr.io/cmahnke/jpeg-xl-action:latest .
```

## ImageMagick

```
docker buildx build -t ghcr.io/cmahnke/jpeg-xl-action/imagemagick:latest -f docker/imagemagick/Dockerfile .
```


# Usage

See [JPEG XL Docs](https://gitlab.com/wg1/jpeg-xl/-/tree/master/doc/man)
