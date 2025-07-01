# Ezthumb Docker Build

This project provides a self-contained, future-proof Docker environment for the powerful but legacy thumbnail generation tool, `ezthumb`. It's designed to solve dependency issues on modern systems and provide a stable, command-line interface for batch processing video files.

## The Problem
The original `ezthumb` is a fantastic tool, but as time has gone on, it has become increasingly difficult to use:

-   **Linux Dependency Issues:** Compiling it on modern Linux distributions is challenging due to its reliance on old libraries and dependencies that are no longer in standard repositories.
-   **Windows GUI Instability:** The official Windows GUI version can be unstable, often crashing when processing large, high-quality video files or large batches.

This project was born out of a determination to preserve and simplify the use of this tool, specifically for its excellent grid-based thumbnail generation.

## The Solution
This repository solves these problems by encapsulating the entire build and run environment for `ezthumb` version 3.6.7 inside a portable Docker container.

-   **No Dependency Hell:** All required Ubuntu 17.04 packages, build tools, and source code are included directly in this repository.
-   **Future-Proof:** The build process is **100% self-contained and offline**. It does not rely on any external Ubuntu archives or download links that might disappear in the future.
-   **Cross-Platform:** Works identically on any system that can run Docker, including modern Windows, macOS, and Linux.
-   **Stable & Powerful:** Provides access to the robust command-line version of `ezthumb`, perfect for batch scripting and processing large files without crashes.

## Prerequisites
Before you begin, you must have the following software installed on your computer:
1.  **Docker Desktop** (for Windows/macOS) or **Docker Engine** (for Linux).
2.  **Git**.

## Setup & Installation
Follow these steps once to get the application image built and ready to use.

**1. Clone the Repository**
First, clone this repository to your local machine.
```bash
git clone https://github.com/meowe29/ezthumb.git
cd ezthumb
````

**2. Load the Base Image into Docker**
This is a one-time setup step that "installs" the archived Ubuntu 17.04 image into your local Docker engine. This image is included in the repository.

```bash
docker load -i ubuntu-17.04.tar
```

**3. Build the `ezthumb` Application Image**
Now, build the final application image. This will use the locally loaded base image and the vendored dependencies from this repository.

```bash
docker build -t ezthumb .
```

You are now ready to generate thumbnails\!

## Usage

The container is designed to process videos located in a specific folder on your host machine.

#### Batch Processing an Entire Folder

This is the primary use case. The internal `process.sh` script will automatically find all video files (.mp4) in the folder you provide and generate a thumbnail grid for each one using default settings.

1.  Place all your video files into a single folder (e.g., `C:\Users\meowe29\Downloads\video_files`).
2.  Run the following command, replacing the path with the full path to your video folder.

**On Windows (PowerShell):**

```powershell
docker run --rm -v "C:\Users\meowe29\Downloads\video_files:/data" ezthumb
```

**On Linux or macOS:**

```bash
docker run --rm -v "/home/meowe29/videos:/data" ezthumb
```

The generated thumbnails (`.jpg` files) will appear in the same folder alongside your videos.

#### Generating a Single Thumbnail

If you only want to process one file from your mounted folder, you can specify its name.

```powershell
# Example for Windows
docker run --rm -v "C:\Users\meowe29\Downloads\video_files:/data" ezthumb "my_awesome_video.mp4"
```

#### Using Custom `ezthumb` Flags

If you want to override the default script and use your own `ezthumb` flags for a specific run, you can do so by overriding the container's entrypoint. This gives you full access to all of `ezthumb`'s power.

```powershell
# Example for Windows: Create a single thumbnail with a specific output name and canvas width
docker run --rm --entrypoint ezthumb -v "C:\Users\meowe29\Downloads\video_files:/data" -w /data ezthumb -i "my_movie.mp4" -o "custom_name.png" -w 1024
```

## License

This project is licensed under the **GPL-3.0 License**. Please see the `LICENSE` file for details.

