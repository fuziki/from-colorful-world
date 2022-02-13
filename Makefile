-include .env

test:
	make $@ -C from-colorful-world/Modules

format:
	make $@ -C from-colorful-world

license:
	make $@ -C from-colorful-world

swiftgen:
	make $@ -C from-colorful-world

mock:
	make $@ -C from-colorful-world

environment:
	@sed -e "s/GIST_ID/$(GIST_ID)/" \
		from-colorful-world/Modules/Sources/Assets/Token/_AppToken.swift \
		> from-colorful-world/Modules/Sources/Assets/Token/AppToken.swift
	echo "Applied environment"

download-audio:
	mkdir -p tmp
	curl -o tmp/SE.zip -LO "$(AUDIO_FILE_URI)"
	rm -rf from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	mkdir -p from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	unzip -o tmp/SE.zip -d from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	rm -rf tmp

install-test: environment download-audio swiftgen mock

install: environment download-audio swiftgen mock license
