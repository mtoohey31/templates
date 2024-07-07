%.pdf: %.typ
	typst compile $< $@

.PHONY: clean
clean: *.typ
	rm -f $(foreach typ,$^,$(basename $(typ)).pdf)
