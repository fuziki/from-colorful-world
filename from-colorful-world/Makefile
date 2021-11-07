format:
	xcrun --sdk macosx swift run --package-path ../tools swiftlint autocorrect --format
	xcrun --sdk macosx swift run --package-path ../tools swiftlint

update-version:
	/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:DefaultValue ${MARKETING_VERSION}(${CURRENT_PROJECT_VERSION})" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/Settings.bundle/Root.plist"

license:
	xcrun --sdk macosx swift run --package-path ../tools license-plist \
		--force --suppress-opening-directory \
		--config-path from-colorful-world/resources/licenses/licenseplist-config.yml \
		--output-path from-colorful-world/resources/Settings.bundle

swiftgen:
	xcrun --sdk macosx swift run --package-path ../tools swiftgen
