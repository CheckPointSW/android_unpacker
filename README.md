# Android Unpacker

A (hopefully) generic unpacker for packed Android apps.

##### How does it work?
The tool is a patched version of AOSP with some additional scripts.
The scripts executes the emulator and installs the APK. Following execution, it
dumps the unpacked version of the DEX using different hooks. The result is two
files, one of them should be the real dumped version of the DEX file, depending
on how the targeted packer works.

Presented in DEF CON 25 (2017) by:
* Slava Makkaveev
* Avi Bashan

## How to build?

1. Clone the AOSP project using the [following instructions](https://source.android.com/source/downloading).
Use the `android-6.0.1_r65`.
2. Apply ```unpacker.patch``` over ```<aosp folder>/art``` using ```$ git apply``` (Please note, your cwd should be ```<aosp dir>/art```)
3. Build the AOSP source using
```$ lunch full-eng```

## Usage
Execute the following command

``` $ ./unpacker.sh <aosp folder> <apk>```

The unpacked DEX file will be created in the current working dir.


## License
Released under "Apache 2.0" license.
