-include .env

test:
	make $@ -C from-colorful-world/Modules

license:
	make $@ -C from-colorful-world

format:
	make $@ -C from-colorful-world

swiftgen:
	make $@ -C from-colorful-world

environment:
	sed -e "s/GIST_ID/$(GIST_ID)/" \
		from-colorful-world/Modules/Sources/Assets/Token/_AppToken.swift \
		> from-colorful-world/Modules/Sources/Assets/Token/AppToken.swift

install: environment
