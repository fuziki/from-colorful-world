license:
	cd from-colorful-world; \
	swift run --package-path ../tools license-plist \
	--force --suppress-opening-directory \
	--config-path from-colorful-world/resources/licenses/licenseplist-config.yml \
	--output-path from-colorful-world/resources/Settings.bundle
