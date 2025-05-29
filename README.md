# **File Part Utility for PowerShell**

## **Overview**

The File Part Utility is a set of PowerShell scripts designed to help you manage large files by splitting them into smaller, more manageable parts and then recombining those parts back into the original file.

This utility is useful for:

* Transferring large files over networks with size limitations.  
* Storing large files on media with smaller capacity.  
* Breaking down large files for easier backup or distribution.

## **Features**

* **Split Mode**:  
  * Divides a large file into smaller segments (parts).  
  * Specify part sizes in Kilobytes (KB) or Megabytes (MB).  
  * Defaults to 10MB parts if no size is specified.  
  * Outputs parts to a specified directory with a clear naming convention (`<OriginalBaseName>.<PartNumber>.part`).  
* **Recombine Mode**:  
  * Merges previously split parts back into a single, complete file.  
  * Automatically determines the correct order of parts.  
  * Allows specifying a custom output file name and extension.  
  * Supports `-WhatIf` and `-Confirm` parameters for safer operations (e.g., overwriting existing files).   
* **Verbose Output**: Provides detailed information about operations, progress, and errors.  
* **Error Handling**: Includes checks for common issues like file not found, directory creation failure, and I/O errors.

## **Requirements**

* **PowerShell**: Version 5.1 or later (the `Get-FileHash` cmdlet used in `Compare-FileChecksums.ps1` was introduced in PowerShell 4.0, but the main script has been developed with 5.1+ in mind).

## **Setup**

1. **Download the Scripts**:  
   * `FilePartUtil.ps1` (the main splitting/recombining script)  
   * `Compare-FileChecksums.ps1` (the checksum comparison script)  
2. **Save** the **Scripts**: Place both `.ps1` files in a directory on your system.

**Execution Policy**: Ensure your PowerShell execution policy allows running local scripts. You might need to run:  
```powershell
Set-ExecutionPolicy RemoteSigned \-Scope CurrentUser
```
3. 

   (Use with caution and understand the security implications).

## **Usage**

### **`FilePartUtil.ps1` - Splitting and Recombining**

Open a PowerShell terminal and navigate to the directory where you saved `FilePartUtil.ps1`.

#### **Splitting a File**

**Syntax:**
```powershell
.\FilePartUtil.ps1 -Mode Split -Path <InputFilePath> -OutputDirectory <PartsDirectoryPath> [-PartSizeMB <SizeInMB> | -PartSizeKB <SizeInKB>]
```
**Parameters for Split Mode:**

* `-Mode Split`: (Mandatory) Specifies the operation mode.  
* `-Path <InputFilePath>`: (Mandatory) Full path to the large file you want to split.  
* `-OutputDirectory <PartsDirectoryPath>`: (Mandatory) Path to the directory where the split parts will be saved. The script will attempt to create this directory if it doesn't exist.  
* `-PartSizeMB <SizeInMB>`: (Optional) Size of each part in Megabytes (e.g., `50`). If not specified and `-PartSizeKB` is also not specified, defaults to `10` (10MB).  
* `-PartSizeKB <SizeInKB>`: (Optional) Size of each part in Kilobytes (e.g., `2048` for 2MB).

**Split Examples:**

Split `MyArchive.zip` into 50MB parts:  
```powershell
.\FilePartUtil.ps1 -Mode Split -Path "C:\\LargeFiles\\MyArchive.zip" -OutputDirectory "C:\\PartsFolder" -PartSizeMB 50
```
1. 

Split `ResearchPaper.docx` into 2048KB (2MB) parts:  
```powershell
.\FilePartUtil.ps1 -Mode Split -Path "D:\Docs\ResearchPaper.docx" -OutputDirectory "D:\Docs\PaperParts" -PartSizeKB 2048
```
2. 

Split `Installer.iso` into default 10MB parts:  
```powershell
.\FilePartUtil.ps1 -Mode Split -Path "C:\Software\Installer.iso" -OutputDirectory "C:\ISO_Parts"
```
3. 

#### **Recombining File Parts**

**Syntax:**
```powershell
.\FilePartUtil.ps1 -Mode Recombine -InputDirectory <PartsDirectoryPath> [-OutputFileName <BaseName>] [-OutputExtension <Extension>] [-WhatIf] [-Confirm]
```
**Parameters for Recombine Mode:**

* `-Mode Recombine`: (Mandatory) Specifies the operation mode.  
* `-InputDirectory <PartsDirectoryPath>`: (Mandatory) Path to the directory containing the file parts (e.g., `MyDocument.1.part`, `MyDocument.2.part`).  
* `-OutputFileName <BaseName>`: (Optional) Desired base name for the recombined file (without extension). If not provided, the script derives it from the part file names.  
* `-OutputExtension <Extension>`: (Optional) Desired extension for the recombined file (e.g., "zip", "iso", without a leading dot).  
* `-WhatIf`: (Optional) Shows what actions would be taken without actually performing them.  
* `-Confirm`: (Optional) Prompts for confirmation before performing actions that modify the file system (like overwriting or creating files).

**Recombine Examples:**

Recombine parts from `C:\PartsFolder` into `MyRestoredArchive.zip`:  
```powershell
.\FilePartUtil.ps1 -Mode Recombine -InputDirectory "C:\PartsFolder" -OutputFileName "MyRestoredArchive" -OutputExtension "zip"
```
1. 

Recombine parts from `D:\Docs\PaperParts`, deriving the name and setting extension to `docx`:  
```powershell
.\FilePartUtil.ps1 -Mode Recombine -InputDirectory "D:\Docs\PaperParts" -OutputExtension "docx"
```
2. 

Recombine parts and see what would happen without making changes:  
```powershell
.\FilePartUtil.ps1 -Mode Recombine -InputDirectory "C:\ISO_Parts" -WhatIf
```
3. 

Recombine parts and confirm before overwriting the output file if it exists:  
```powershell
.\FilePartUtil.ps1 -Mode Recombine -InputDirectory "C:\ISO_Parts" -Confirm
```
4. 

## **Important Notes**

* **Disk Space**: Ensure you have sufficient free disk space in the output/input directories, especially when dealing with very large files. For splitting, you'll need space for the parts. For recombining, you'll need space for the final recombined file.  
* **Overwrite Behavior**:  
  * In `Split` mode, if part files with the same name already exist in the output directory, they will be overwritten without warning by default (consider adding `SupportsShouldProcess` to `Split-File` for better control).  
  * In `Recombine` mode, if the target output file already exists, the script will prompt for confirmation if `-Confirm` is used, or show the intended action if `-WhatIf` is used. Without these, it will warn and then overwrite (if `ShouldProcess` allows).  
* **Part File Naming**: The script expects part files to be named `<BaseName>.<PartNumber>.part` (e.g., `MyFile.1.part`, `MyFile.2.part`). The `Recombine` mode relies on this pattern to correctly identify and order parts. Ensure all parts for a single recombination operation are in the specified input directory and follow this naming convention.  
* **File Integrity**: While the `Recombine` mode is designed to faithfully reconstruct the original file, it's highly recommended to use a checksum utility to verify the integrity of critical files after recombination.  
* **Single File Set for Recombination**: The `Recombine` mode expects all part files in the `InputDirectory` to belong to a single original file. If you have parts from multiple different split operations in the same directory, process them separately by moving one set out temporarily.

## **Troubleshooting**

* **"Multiple base names detected..." error during Recombine**: This usually means that the part files in the `InputDirectory` do not have a consistent base name prefix before the `.N.part` suffix, or there are part files from different original files mixed together. Carefully check the filenames in the input directory.  
* **Permission Errors**: Ensure PowerShell has the necessary read/write permissions for the input and output directories and files.  
* **Script Execution Blocked**: If you see an error about scripts being disabled on the system, refer to the "Execution Policy" section under "Setup".
