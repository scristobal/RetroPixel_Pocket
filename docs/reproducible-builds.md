# Reproducible RPPOCKET Builds

This project can be built in a pinned container so the host operating system
does not provide the compiler, build tools, Perl modules, or other package
dependencies.

## Build The Container

The pinned build environment is defined in the repository's main `Dockerfile`.

```sh
make docker-image-build
```

By default this creates:

```text
retropixel-build:ubuntu20.04-20260427
```

Override the image name if needed:

```sh
DOCKER_IMAGE=retropixel-build:local make docker-image-build
```

## Build RPPOCKET

```sh
make docker-RPPOCKET
```

This mounts the current checkout at the same path inside the container and runs:

```sh
make RPPOCKET
```

The generated release files are written back into the checkout under:

```text
release/aarch64/RPPOCKET/
```

## Offline Source Check

If all required source artifacts are already present under `sources/` and
`extpackage/`, force the build to fail instead of downloading anything:

```sh
VENDORED_SOURCES_ONLY=yes make docker-RPPOCKET
```

This is useful for verifying that a build uses only local source inputs.

## Source Manifest

Generate provenance and cache status:

```sh
DISTRO=RetroPixel PROJECT=Rockchip DEVICE=RPPOCKET ARCH=aarch64 \
  scripts/vendor_manifest > docs/vendor-manifest.tsv
```

The manifest records package name, version or commit, source handler, local
path, declared checksum, local checksum, upstream URL, and upstream site.

## Limits

This setup makes host dependencies reproducible. It does not by itself guarantee
byte-for-byte identical output because the build still embeds generated version
and date values. For stricter reproducibility, also make build dates and version
strings explicit through environment variables.
