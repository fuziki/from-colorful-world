# from-colorful-world

![Platform](https://img.shields.io/badge/platform-%20iOS%20-green.svg)
![Swift](https://img.shields.io/badge/language-Swift-green.svg)
![Xcode](https://img.shields.io/badge/xcode-Xcode13-green.svg)

## Requirements
* Xcode 13.1

## Setup

```
$ git close https://github.com/fuziki/from-colorful-world
$ cd from-colorful-world
$ make install
```

## Build iOS Application

```
$ cd from-colorful-world
$ open from-colorful-world.xcodeproj
```

* Build from-colorful-world for device

## Test
### Run local unit tests

```
$ make test
```

### GitHub Actions

[Test workflow](.github/workflows/test.yml)

## Format

* Use [SwiftLint](https://github.com/realm/SwiftLint)
* [.swiftlint.yml](from-colorful-world/.swiftlint.yml)

## License

* Use [LicensePlist](https://github.com/mono0926/LicensePlist)
* Run make

```
$ make license
```

* [license_plist.yml](from-colorful-world/license_plist.yml)

## Assets

* Use [SwiftGen](https://github.com/SwiftGen/SwiftGen)
* [swiftgen.yml](from-colorful-world/swiftgen.yml)

## Environment
### Use .env

* Make .env file

```
$ touch .env
```

* Adding the following line to .env

```
GIST_ID=hogehoge
APP_APPLE_ID=fugaufga
AUDIO_FILE_URI=example.com
```

* Run make

```
make environment
```

### Use Environment variable

```
GIST_ID=hogehoge APP_APPLE_ID=fugaufga make environment
```
