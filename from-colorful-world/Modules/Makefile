TARGET=$(shell xcrun xctrace list devices 2>&1 | grep -m 1 -o -E "iPhone[0-9|A-z| ]*Simulator \([0-9|.]+\)")
NAME=$(shell echo "${TARGET}" | grep -o -E "iPhone [0-9|A-z]+")
OS=$(shell echo "${TARGET}" | grep -o -E "[0-9|.]+" | tail -n 1)

test:
	echo name = $(NAME), OS = $(OS)
	xcodebuild -scheme AppMain test -destination "name=${NAME},OS=${OS}"
