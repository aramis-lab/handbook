# The Aramis Lab Handbook

## Getting started

This project requires [Poetry](https://python-poetry.org).

You can generate a Conda environment with Poetry with:

```console
make env
```

And activate it with:

```console
conda activate ./.venv
```

## Contributing

Add or edit an article under the `docs` folder.

To submit a new article, add it to `docs/_toc.yml`.

Build the documentation with:

```console
make
```

Browse the generated documentation at `docs/_build/html/index.html`.
