xcodeproj:
	xcodegen && xed .

test-ios:
	set -o pipefail && \
	xcodebuild test \
		-scheme SwiduxWatchmen_iOS \
		-destination platform="iOS Simulator,name=iPhone XR,OS=12.1" \
