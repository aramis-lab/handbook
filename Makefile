POETRY ?= poetry
CONDA ?= conda

all: install docs

.PHONY: check-lock
check-lock:
	@$(POETRY) lock --check

.PHONY: clean
clean:
	@$(RM) -rf docs/_build

.PHONY: docs
docs: clean
	@$(POETRY) run jupyter-book build docs

.PHONY: install
install: check-lock
	@$(POETRY) install

.PHONY: update
update:
	@$(POETRY) update
