PREFIX  ?= /usr
CHANGEME = build/exec/CHANGEME

$(CHANGEME): changeme.ipkg $(shell find src -type d -o -name '*.idr')
	idris2 --build

.PHONY: install
install: $(CHANGEME)
	mkdir -p $(PREFIX)/bin
	cp -r $< $<_app $(PREFIX)/bin

.PHONY: clean
clean:
	rm -rf build/ result
