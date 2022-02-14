format:
	xcrun --sdk macosx swift run --package-path ../tools swiftlint autocorrect --format
	xcrun --sdk macosx swift run --package-path ../tools swiftlint

update-version:
	/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:DefaultValue ${MARKETING_VERSION}(${CURRENT_PROJECT_VERSION})" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/Settings.bundle/Root.plist"

license:
	xcrun --sdk macosx swift run --package-path ../tools license-plist \
		--force --suppress-opening-directory \
		--swift-package-paths ../tools/Package.swift \
		--output-path from-colorful-world/resources/Settings.bundle

swiftgen:
	mkdir -p Modules/Sources/Assets/Generated
	xcrun --sdk macosx swift run --package-path ../tools swiftgen

mock:
	mkdir -p Modules/Tests/AppMainTests/Mock
	touch Modules/Tests/AppMainTests/Mock/Mock.generated.swift
	xcrun --sdk macosx swift run --package-path ../tools mockolo \
		-s Modules/Sources \
		-d Modules/Tests/AppMainTests/Mock/Mock.generated.swift \
		-i AppMain
