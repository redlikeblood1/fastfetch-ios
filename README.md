**Fork note:** this fork fixes the OS line on iPads – it shows
"iPadOS" instead of "iPhone OS". Only `patches/004-ios-os.sh` differs
from upstream ([seph3421/fastfetch-ios](https://github.com/seph3421/fastfetch-ios)).
Prebuilt rootful and rootless .debs: see [Releases](../../releases).

# Fastfetch iOS / iPadOS

An unofficial native iOS port of [Fastfetch](https://github.com/fastfetch-cli/fastfetch), modified to run natively on 
jailbroken Apple mobile devices.

Add my repo to: [Sileo](https://tinyurl.com/478v5n2k)

Checkout the repo page [seph3421's repo](https://seph3421.github.io)

This project builds Fastfetch as an ARM64 or ARM (Rootless or Rootful) Debian package (`.deb`) for installation through a jailbreak package manager
such as Sileo.

## Screenshots
<details>
<summary><strong>Show Screenshots</strong></summary>

<br>

<p>
<img src="https://seph3421.github.io/depictions/com.seph3421.fastfetch/screenshots/screenshot1.PNG" width="800">
</p>

<p>
<img src="https://seph3421.github.io/depictions/com.seph3421.fastfetch/screenshots/screenshot2.PNG" width="800">
</p>

<p>
<img src="https://seph3421.github.io/depictions/com.seph3421.fastfetch/screenshots/screenshot3.PNG" width="800">
</p>

<p>
<img src="https://seph3421.github.io/depictions/com.seph3421.fastfetch/screenshots/screenshot4.PNG" width="800">
</p>

</details>

## Tested Devices

The current build has been successfully tested on:

| Device            | SoC              | Jailbreak               |
| ----------------- | ---------------- | ----------------------- |
| iPad Air 2        | Apple A8X        | palera1n / rootless     |
| iPad Pro 9.7"     | Apple A9X        | palera1n / rootless     |
| iPhone 11         | Apple A13 Bionic | Dopamine 3.0 / rootless |
| iPhone 12 Pro Max | Apple A14 Bionic | Dopamine 3.0 / rootless |
| iPad mini 2.      | Apple A7.        | Amethyst.    / rootful  |

The device detection code identifies Apple hardware using the `hw.machine` identifier exposed through `sysctl`.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Features

The iOS port currently provides native detection for several modules that are normally unavailable or implemented 
differently on Apple's mobile operating systems.

Current custom detection includes:

* CPU
* GPU
* Host / device model
* OS
* Display resolution
* Local IP address
* Shell
* Terminal
* Packages
* Other standard Fastfetch modules that remain compatible with iOS

The host, CPU, and GPU detectors identify individual Apple device identifiers rather than simply reporting generic `iPhone` or `iPad` values.

For example:

-------------------------------------------
Host:        iPad Pro (9.7-inch)
CPU:         Apple A9X
GPU:         PowerVR Series7XT (12-cluster)
-------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Requirements

### Build machine

The build script is intended to run on **macOS**.(tested on Sequoia +)

You need:

* macOS
* Xcode
* Xcode iPhoneOS SDK
* Git
* CMake
* Python 3
* dpkg / dpkg-deb
* ldid/codesign as a fallback(included with Xcode) 

Xcode is required because the project is cross-compiled against Apple's iPhoneOS SDK using Apple's Clang toolchain.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Homebrew

If Homebrew is not already installed, install it from:

https://brew.sh/

Then install the required command-line tools:

Minimal brew list
```bash
brew install cmake git python dpkg
```

Full brew list(Needed for Rootful)
```bash
brew install cmake git python dpkg ldid-procursus
```

Verify them:
```bash
git --version
cmake --version
python3 --version
dpkg-deb --version
```
(Optional/Needed for Rootful)
```bash
which ldid
```
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Verify iPhone SDK
Verify that Xcode's iPhoneOS SDK is available:
```bash
xcrun --sdk iphoneos --show-sdk-path
```

This should return a path similar to:


/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk


If `xcrun` cannot locate the SDK, make sure Xcode is installed and selected:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Then run:
```bash
xcrun --sdk iphoneos --show-sdk-path
``` 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Building

Move To Documents:
```bash
cd ~/Documents
```
Clone the repository:
https://github.com/seph3421/fastfetch-ios.git

```bash
git clone https://github.com/seph3421/fastfetch-ios.git
```
```bash
cd fastfetch-ios
```
Move to Rootless/Rootful:
```bash
cd fastfetch-ios-Rootless
```
```bash
cd fastfetch-ios-Rootful
```

Make the build script executable:
```bash
chmod +x build.sh
```

Run it:
```bash
./build.sh
```

The script will:

1. Create a temporary build directory.
2. Clone the upstream Fastfetch source.
3. Apply the iOS-specific patches.
4. Replace unsupported Apple/macOS implementations with iOS-compatible implementations or stubs.
5. Add the custom iOS CPU detector.
6. Add the custom iOS GPU detector.
7. Add the custom iOS/iPadOS host detector.
8. Add the custom display detector.
9. Configure CMake for ARM64 and the iPhoneOS SDK.
10. Cross-compile Fastfetch.
11. Place the resulting binary into the jailbreak filesystem layout.
12. Sign the Mach-O binary.
13. Package everything into a Debian `.deb`.
14. Preserve the complete build workspace.

The resulting package will be created in the project directory as:

fastfetch_2.67.1_iphoneos-arm.deb

fastfetch_2.67.1_iphoneos-arm64.deb

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Package Layout

The package installs Fastfetch into the Rootless jailbreak environment under:

```bash
/var/jb/usr/local/bin/fastfetch
```

Presets are installed under:

```bash
/var/jb/usr/local/share/fastfetch/
```

The package installs Fastfetch into the Rootful jailbreak environment under:

```bash
/usr/local/bin/fastfetch
```

Presets are installed under:

```bash
/usr/local/share/fastfetch/
```

The package contains the normal Debian control directory:


DEBIAN/
└── control

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Installation

Transfer the resulting `.deb` to the jailbroken device.

For example, copy it into the device's Downloads directory and install it using Sileo or another Debian-compatible
jailbreak package manager.

After installation:


fastfetch

If `/var/jb/usr/local/bin` or `/usr/local/bin` is already in your shell's `PATH`, Fastfetch can be launched directly.


You can also test the Rootless binary directly:
```bash
/var/jb/usr/local/bin/fastfetch
```

You can also test the Rootful binary directly:
```bash
/usr/local/bin/fastfetch
```

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## iOS Compatibility

This is a jailbreak-oriented command-line build.

It is **not** intended to run as a normal App Store application or standalone iOS application bundle.

The executable is compiled for:
ARM64
ARM

against Apple's:
iPhoneOS 18.5 SDK.

The package is intended for Rootless jailbroken environments where `/var/jb` is available.

The package is intended for Rootful jailbroken environments where `/usr/local/` is available.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Rootless Jailbreaks

The current build has been successfully tested in rootless jailbreak environments.

The package installs into the jailbreak prefix:
```bash
/var/jb/
```

rather than modifying Apple's sealed system filesystem.

Tested rootless environments include:

* Dopamine
* palera1n rootless

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Rootful Jailbreaks

The current build has been successfully tested in rootful jailbreak environments.

The package installs into the System prefix:
```bash
/usr/local/
```

Tested rootless environments include:

* Amethyst
* Checkra1n
* Any checkm8 or Odysseyra1n bootstrap

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Device Detection

The iOS hardware detection uses:
sysctlbyname("hw.machine", ...)

This provides Apple's hardware identifier, for example:

iPhone12,1
or:
iPad6,3

The project maps these identifiers to human-readable Apple hardware names.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Host

The host detector maps Apple identifiers to device names including iPhones and iPads.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
### CPU

The CPU detector maps the hardware identifier to the corresponding Apple SoC, including:

* A4
* A5
* A5X
* A6
* A6X
* A7
* A8
* A8X
* A9
* A9X
* A10 Fusion
* A10X Fusion
* A11 Bionic
* A12 Bionic
* A12X Bionic
* A12Z Bionic
* A13 Bionic
* A14 Bionic
* A15 Bionic
* A16
* A17 Pro
* M1
* M2
* M3
* M4
* M5

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
### GPU

The GPU detector similarly maps Apple hardware identifiers to the corresponding GPU family.

Older PowerVR-based devices use their known PowerVR GPU names, while newer Apple-designed GPUs are identified 
by their corresponding Apple SoC generation.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Unsupported Apple Components

Several Fastfetch components are designed around macOS APIs or hardware that does not exist or is not publicly 
available in the same form on iOS.

The iOS build therefore disables or stubs components including various:

* macOS-only frameworks
* IOKit functionality
* CoreWLAN
* IOBluetooth
* DisplayServices
* MediaRemote
* AppKit
* OpenGL macOS functionality
* macOS window manager functionality
* macOS AppleScript functionality
* macOS-specific disk and power-management APIs

Unsupported modules return an appropriate "not supported on iOS" result rather than preventing Fastfetch from building.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Project Structure

The build script clones the upstream Fastfetch source into a temporary directory and applies these modifications during the build.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Upstream Project

This project is based on Fastfetch:

https://github.com/fastfetch-cli/fastfetch

Fastfetch is a maintained, feature-rich system information tool written primarily in C. The upstream project supports multiple 
operating systems and uses CMake for building.

This repository adds an unofficial iOS/iPadOS target and device-specific detection on top of the upstream project.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Version

Current packaged version:
2.67.1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Disclaimer

This is an unofficial port and is not affiliated with or endorsed by:

* Apple
* Fastfetch
* Dopamine
* palera1n
* Sileo

Use this software at your own risk.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## License

Fastfetch is distributed under the MIT License.

See the upstream project for the complete license:

https://github.com/fastfetch-cli/fastfetch

