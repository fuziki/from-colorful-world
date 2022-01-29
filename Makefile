-include .env

test:
	make $@ -C from-colorful-world/Modules

format:
	make $@ -C from-colorful-world

license:
	make $@ -C from-colorful-world

swiftgen:
	make $@ -C from-colorful-world

environment:
	@sed -e "s/GIST_ID/$(GIST_ID)/" \
		from-colorful-world/Modules/Sources/Assets/Token/_AppToken.swift \
		> from-colorful-world/Modules/Sources/Assets/Token/AppToken.swift
	echo "Applied environment"

install-test: environment swiftgen

install: environment swiftgen license
