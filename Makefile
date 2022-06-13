POETRY ?= poetry

.PHONY: clean
clean:
	@$(RM) -rf docs/_build

.PHONY: install
install:
	@$(POETRY) install

.PHONY: book
book: clean
	@$(POETRY) run jupyter-book docs ./book
