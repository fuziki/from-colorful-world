format:
	make spm-install product=swiftlint -C ../tools
	../tools/export/swiftlint/swiftlint autocorrect --format
	../tools/export/swiftlint/swiftlint

update-version:
	/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:DefaultValue ${MARKETING_VERSION}(${CURRENT_PROJECT_VERSION})" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/Settings.bundle/Root.plist"

license:
	xcrun --sdk macosx swift run --package-path ../tools license-plist \
		--force --suppress-opening-directory \
		--swift-package-paths ../tools/Package.swift \
		--output-path from-colorful-world/resources/Settings.bundle

swiftgen:
	mkdir -p Modules/Sources/Assets/Generated
	make swiftgen-pre-script -C ../tools
	make spm-install product=swiftgen -C ../tools
	make swiftgen-post-script -C ../tools
	time ../tools/export/swiftgen/swiftgen

mock:
	mkdir -p Modules/Tests/AppMainTests/Mock
	touch Modules/Tests/AppMainTests/Mock/Mock.generated.swift
	make spm-install product=mockolo -C ../tools
	time ../tools/export/mockolo/mockolo \
		-s Modules/Sources \
		-d Modules/Tests/AppMainTests/Mock/Mock.generated.swift \
		-i AppMain
