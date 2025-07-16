# Original Code
[BitCrack](https://github.com/brichard19/BitCrack/tree/master)

# BitCrack OpenCL - Simplified Version

This is a simplified, OpenCL-only version of BitCrack, a Bitcoin private key brute-force tool. This version has been refactored to:

- Use only OpenCL (no CUDA support)
- Have a simplified folder structure
- Be easier to build and maintain

## Project Structure

```
Bitcrack/
├── include/          # Header files
├── src/              # Source files
│   ├── core/         # Core functionality (secp256k1, crypto, etc.)
│   ├── opencl/       # OpenCL device implementation
│   ├── main/         # Main application files
│   └── *.cl          # OpenCL kernel files
├── bin/              # Build output (executables)
├── build/            # Build artifacts
├── Makefile          # Build configuration
├── CMakeLists.txt    # Alternative CMake build
├── build.bat         # Windows build script
└── README_SIMPLIFIED.md
```

## Prerequisites

1. **OpenCL SDK**: Install the OpenCL SDK Light from AMD or Intel
   - Default path: `C:/Program Files (x86)/OCL_SDK_Light/`
   - Update paths in Makefile if installed elsewhere

2. **C++ Compiler**: GCC or compatible compiler with C++11 support

3. **Make**: GNU Make for building

## Building

### Windows
```bash
# Run the build script
build.bat
```

### Linux/macOS
```bash
# Build using make
make clean
make all
```

### Using CMake (Alternative)
```bash
mkdir build
cd build
cmake ..
make
```

## Usage

```bash
# Basic usage
./bin/bitcrack.exe [OPTIONS] [TARGETS]

# List available devices
./bin/bitcrack.exe --list-devices

# Search for a specific address
./bin/bitcrack.exe 1FshYsUh3mqgsG29XpZ23eLjWV8Ur3VwH

# Search with specific keyspace
./bin/bitcrack.exe --keyspace 80000000:ffffffff 1FshYsUh3mqgsG29XpZ23eLjWV8Ur3VwH
```

## Options

- `-d, --device ID`: Use device with ID
- `-b, --blocks N`: Number of OpenCL work groups
- `-t, --threads N`: Threads per work group
- `-p, --points N`: Points per thread
- `-c, --compressed`: Search compressed addresses
- `-u, --uncompressed`: Search uncompressed addresses
- `--keyspace START:END`: Specify key range to search
- `--list-devices`: List available OpenCL devices
- `-i, --in FILE`: Read addresses from file
- `-o, --out FILE`: Write results to file

## What Was Removed

This simplified version removes:

- All CUDA-related code and directories
- Complex multi-directory structure
- Unnecessary utility programs
- Complex build system with multiple Makefiles

## What Was Kept

- Core secp256k1 elliptic curve operations
- OpenCL device implementation
- Main key search functionality
- Address generation and validation
- Cryptographic utilities (SHA256, RIPEMD160)
- Command-line interface

## Performance

Performance depends on your OpenCL device:
- AMD GPUs: Generally good performance
- NVIDIA GPUs: Good performance with OpenCL
- Intel GPUs: May have compatibility issues
- CPUs: Slower but functional

## Troubleshooting

1. **OpenCL not found**: Check that OpenCL SDK is installed and paths are correct
2. **Build errors**: Ensure C++11 compiler is available
3. **Runtime errors**: Check OpenCL driver installation
4. **Poor performance**: Adjust `-b`, `-t`, and `-p` parameters for your device
