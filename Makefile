POETRY ?= poetry

all: install clean docs

.PHONY: clean
clean:
	@$(RM) -rf docs/_build

.PHONY: docs
docs: clean
	@$(POETRY) run jupyter-book build docs

.PHONY: install
install:
	@$(POETRY) install