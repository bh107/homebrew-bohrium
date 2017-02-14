# Bohrium

This is the home for the Homebrew (https://brew.sh) package for Bohrium (https://github.com/bh107/bohrium)

## How to install

You can install Bohrium with

```
$ brew install bh107/homebrew-bohrium/bohrium
```

## Caveats

You cannot build this with a different compiler, so we cannot support `clang-omp` which gives OpenMP support to `clang`.
If you need OpenMP support, you'll have to build Bohrium yourself.
