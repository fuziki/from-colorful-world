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
	@sed \
		-e "s/GIST_ID/$(GIST_ID)/" \
		-e "s/APP_APPLE_ID/$(APP_APPLE_ID)/" \
		-e "s/USAGE_PAGE_URL/$(USAGE_PAGE_URL)/" \
		-e "s/CREATE_QRCODE_ON_PC_PAGE_URL/$(CREATE_QRCODE_ON_PC_PAGE_URL)/" \
		-e "s/CONTACT_US_FORM_ID/$(CONTACT_US_FORM_ID)/" \
		-e "s/CONTACT_US_ENV_ENTRY_ID/$(CONTACT_US_ENV_ENTRY_ID)/" \
		from-colorful-world/Modules/Sources/Assets/Token/_AppToken.swift \
		> from-colorful-world/Modules/Sources/Assets/Token/AppToken.swift
	echo "Applied environment"

download-audio:
	mkdir -p tmp
	@curl -o tmp/SE.zip -LO "$(AUDIO_FILE_URI)"
	echo "Downloaded zip"
	rm -rf from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	mkdir -p from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	unzip -o tmp/SE.zip -d from-colorful-world/Modules/Sources/Assets/ResourceFiles/Audio/SE
	rm -rf tmp

install-test: environment download-audio swiftgen mock

install: environment download-audio swiftgen mock license

run-sev:
	cd web-contents; npm run dev

update-marketing-version:
	sh scripts/update-marketing-version.sh \
		${NEW_VERSION} \
		from-colorful-world/from-colorful-world/xcconfig/from-colorful-world.Shared.xcconfig
