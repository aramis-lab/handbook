POETRY ?= poetry

.PHONY: all
all: install docs

.PHONY: clean
clean:
	@$(RM) -rf docs/_build

.PHONY: docs
docs: clean
	@$(POETRY) run jupyter-book build docs

.PHONY: install
install:
	@$(POETRY) install