POETRY ?= poetry

.PHONY: clean
clean:
	@$(RM) -rf book/_build

.PHONY: install
install:
	@$(POETRY) install

.PHONY: book
book: clean
	@$(POETRY) run jupyter-book build ./book
