<#
.SYNOPSIS
Splits a large file into smaller, more manageable parts or recombines these parts back into the original file.

.DESCRIPTION
The FilePartUtil.ps1 script provides two modes of operation: 'Split' and 'Recombine'.

'Split' Mode:
This mode allows you to take a large file and divide it into smaller segments (parts). You can specify the size of these parts in either kilobytes (KB) or megabytes (MB). If no size is specified, it defaults to 10MB per part. The parts are named using the original file's base name, followed by a part number and a '.part' extension (e.g., MyDocument.1.part, MyDocument.2.part). These parts are saved in a specified output directory.

'Recombine' Mode:
This mode takes previously split parts from an input directory and merges them back into a single, complete file. The script automatically determines the correct order of parts based on their numbering. You can specify a custom name and extension for the recombined file, or let the script derive them from the part names. The recombined file is saved in the same directory as the input parts.

The script includes error handling and provides verbose output to the console about its operations.

.PARAMETER Mode
Specifies the operation mode for the script.
- 'Split': To split a file into parts.
- 'Recombine': To merge parts back into a file.
This parameter is mandatory.
Type: String
Accepted Values: Split, Recombine
Position: Named
Default value: None

.PARAMETER Path
(Split Mode) The full path to the file that you want to split.
This parameter is mandatory for 'Split' mode.
Type: String
Position: Named
Default value: None
Parameter Set: SplitDefaultSet, SplitKBSet, SplitMBSet

.PARAMETER OutputDirectory
(Split Mode) The path to the directory where the split file parts will be saved.
If the directory does not exist, the script will attempt to create it.
This parameter is mandatory for 'Split' mode.
Type: String
Position: Named
Default value: None
Parameter Set: SplitDefaultSet, SplitKBSet, SplitMBSet

.PARAMETER PartSizeKB
(Split Mode) Specifies the size of each part in kilobytes (KB).
Use this parameter if you want to define part sizes in KB. Must be a positive integer.
This parameter is mandatory for the 'SplitKBSet' parameter set.
Type: Int32
Position: Named
Default value: None
Parameter Set: SplitKBSet

.PARAMETER PartSizeMB
(Split Mode) Specifies the size of each part in megabytes (MB).
Use this parameter if you want to define part sizes in MB. Must be a positive integer.
If neither PartSizeKB nor PartSizeMB is specified in 'Split' mode, PartSizeMB defaults to 10MB.
This parameter is mandatory for the 'SplitMBSet' parameter set.
Type: Int32
Position: Named
Default value: 10 (when using SplitDefaultSet)
Parameter Set: SplitDefaultSet, SplitMBSet

.PARAMETER InputDirectory
(Recombine Mode) The path to the directory containing the file parts that you want to recombine.
The script will search for files matching the '*.N.part' pattern in this directory.
This parameter is mandatory for 'Recombine' mode.
Type: String
Position: Named
Default value: None
Parameter Set: RecombineSet

.PARAMETER OutputFileName
(Recombine Mode) The desired base name for the recombined file (without extension).
If not provided, the script will use the common base name derived from the part files.
This parameter is optional for 'Recombine' mode.
Type: String
Position: Named
Default value: Derived from part names
Parameter Set: RecombineSet

.PARAMETER OutputExtension
(Recombine Mode) The desired extension for the recombined file (e.g., "txt", "zip", "exe", without a leading dot).
If not provided, the recombined file will not have an extension unless it's part of the OutputFileName or derived base name.
This parameter is optional for 'Recombine' mode.
Type: String
Position: Named
Default value: None
Parameter Set: RecombineSet

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Split -Path "C:\LargeFiles\MyArchive.zip" -OutputDirectory "C:\PartsFolder" -PartSizeMB 50
Description: This command splits the 'MyArchive.zip' file into parts of 50MB each. The parts will be saved in 'C:\PartsFolder'.

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Split -Path "D:\Docs\ResearchPaper.docx" -OutputDirectory "D:\Docs\PaperParts" -PartSizeKB 2048
Description: This command splits the 'ResearchPaper.docx' file into parts of 2048KB (2MB) each. The parts will be saved in 'D:\Docs\PaperParts'.

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Split -Path "C:\Software\Installer.iso" -OutputDirectory "C:\ISO_Parts"
Description: This command splits the 'Installer.iso' file into parts of the default size (10MB each) because neither -PartSizeMB nor -PartSizeKB was specified. The parts will be saved in 'C:\ISO_Parts'.

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Recombine -InputDirectory "C:\PartsFolder" -OutputFileName "MyRestoredArchive" -OutputExtension "zip"
Description: This command recombines the parts found in 'C:\PartsFolder'. The resulting file will be named 'MyRestoredArchive.zip' and saved in 'C:\PartsFolder'.

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Recombine -InputDirectory "D:\Docs\PaperParts" -OutputExtension "docx"
Description: This command recombines the parts from 'D:\Docs\PaperParts'. The output file name will be derived from the part files (e.g., 'ResearchPaper' if parts are named 'ResearchPaper.1.part'), and it will have the '.docx' extension. The file will be saved in 'D:\Docs\PaperParts'.

.EXAMPLE
PS C:\> .\FilePartUtil.ps1 -Mode Recombine -InputDirectory "C:\ISO_Parts"
Description: This command recombines the parts from 'C:\ISO_Parts'. The output file name will be derived from the part files (e.g., 'Installer' if parts are 'Installer.1.part') and will not have an explicit new extension (it will keep any extension that was part of the derived base name). The file will be saved in 'C:\ISO_Parts'.

.INPUTS
None. This script does not accept input from the pipeline.

.OUTPUTS
Primarily outputs messages to the PowerShell host console detailing the operations being performed, progress, success, or errors.
The script creates files (parts during 'Split' mode, or a recombined file during 'Recombine' mode) on the filesystem. It does not directly output System.IO.FileInfo objects for these files to the pipeline.

.NOTES
Version: 1.2
Author: AI-Generated (Modified by User)
Part File Naming Convention: When splitting, part files are named as `<InputFileNameWithoutExtension>.<PartNumber>.part`. For example, splitting `MyFile.txt` would result in `MyFile.1.part`, `MyFile.2.part`, etc.
Disk Space: Ensure sufficient free disk space in the output/input directory for splitting or recombining operations, especially with large files.
Error Handling: The script includes error handling for common issues like file not found, directory creation failure, and issues during file I/O.
Overwrite Behavior: In 'Recombine' mode, if the target output file already exists, the script will issue a warning and overwrite the existing file.
PowerShell Version: Developed and tested with PowerShell 5.1 and later. Functionality with older versions is not guaranteed.
File Integrity: This script does not currently include checksum validation for file integrity after recombination. For critical files, consider using a separate utility to verify checksums.
#>

[CmdletBinding(DefaultParameterSetName = 'SplitDefaultSet')]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Split', 'Recombine')]
    [string]$Mode,

    # Parameters for 'Split' Mode
    [Parameter(ParameterSetName='SplitDefaultSet', Mandatory=$true, HelpMessage="Path to the file to be split.")]
    [Parameter(ParameterSetName='SplitKBSet', Mandatory=$true, HelpMessage="Path to the file to be split.")]
    [Parameter(ParameterSetName='SplitMBSet', Mandatory=$true, HelpMessage="Path to the file to be split.")]
    [string]$Path,

    [Parameter(ParameterSetName='SplitDefaultSet', Mandatory=$true, HelpMessage="Directory where the parts will be saved.")]
    [Parameter(ParameterSetName='SplitKBSet', Mandatory=$true, HelpMessage="Directory where the parts will be saved.")]
    [Parameter(ParameterSetName='SplitMBSet', Mandatory=$true, HelpMessage="Directory where the parts will be saved.")]
    [string]$OutputDirectory,

    [Parameter(ParameterSetName='SplitKBSet', Mandatory=$true, HelpMessage="Size of each part in kilobytes. Must be a positive value.")]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$PartSizeKB,

    [Parameter(ParameterSetName='SplitMBSet', Mandatory=$true, HelpMessage="Size of each part in megabytes. Must be a positive value.")]
    [Parameter(ParameterSetName='SplitDefaultSet')] # When this set is active, $PartSizeMB will take its default value
    [ValidateRange(1, [int]::MaxValue)]
    [int]$PartSizeMB = 10, # Default value of 10MB specified here 

    # Parameters for 'Recombine' Mode
    [Parameter(ParameterSetName='RecombineSet', Mandatory=$true, HelpMessage="Directory where the part files are located.")]
    [string]$InputDirectory,

    [Parameter(ParameterSetName='RecombineSet', Mandatory=$false, HelpMessage="The desired base name for the recombined file.")]
    [string]$OutputFileName,

    [Parameter(ParameterSetName='RecombineSet', Mandatory=$false, HelpMessage="The desired extension for the recombined file (without a leading dot).")]
    [string]$OutputExtension
)

function Split-File {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$OutputDirectory,

        [Parameter(ParameterSetName='KB')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$PartSizeKB,

        [Parameter(ParameterSetName='MB', Mandatory=$true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$PartSizeMB = 10 
    )

    $fileStream = $null
    try {
        Write-Host "Initializing file splitting operation..."

        if (-not (Test-Path $Path -PathType Leaf)) {
            throw "Error: Input file not found at '$Path'. Please verify the file path."
        }
        $inputFile = Get-Item $Path
        if ($inputFile.Length -eq 0) {
            throw "Error: Input file '$($inputFile.FullName)' is 0 bytes. Cannot split an empty file."
        }

        $partSizeBytes = 0
        $sizeUnit = ""
        if ($PSBoundParameters.ContainsKey('PartSizeKB')) {
            if($PartSizeKB -le 0) { throw "Error: PartSizeKB must be a positive value." } # Redundant due to ValidateRange but good for explicit check
            $partSizeBytes = $PartSizeKB * 1024
            $sizeUnit = "$PartSizeKB KB"
        } else {
            if($PartSizeMB -le 0) { throw "Error: PartSizeMB must be a positive value." } # Redundant
            $partSizeBytes = $PartSizeMB * 1024 * 1024
            $sizeUnit = "$PartSizeMB MB"
        }
        
        if ($partSizeBytes -le 0) { # Should be caught by ValidateRange on param or above checks
            throw "Error: Part size must be greater than 0 bytes. Calculated part size: $partSizeBytes bytes."
        }

        Write-Host "Input file: '$($inputFile.FullName)' ($($inputFile.Length) bytes)"
        Write-Host "Target part size: $sizeUnit ($partSizeBytes bytes)"

        $inputFileBaseName = $inputFile.BaseName
        $partNumber = 1

        if (-not (Test-Path $OutputDirectory -PathType Container)) {
            try {
                Write-Host "Creating output directory '$OutputDirectory'..."
                New-Item -ItemType Directory -Path $OutputDirectory -ErrorAction Stop | Out-Null
                Write-Host "Output directory '$OutputDirectory' created successfully."
            } catch {
                throw "Error: Could not create output directory '$OutputDirectory'. Details: $($_.Exception.Message)"
            }
        } else {
            Write-Host "Output directory '$OutputDirectory' already exists."
        }
        
        Write-Host "Starting to split the file..."
        $fileStream = [System.IO.File]::OpenRead($inputFile.FullName)
        $buffer = New-Object byte[] $partSizeBytes # Can throw if partSizeBytes is too large for memory

        $totalBytesRead = 0
        while (($bytesRead = $fileStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $partFileName = Join-Path -Path $OutputDirectory -ChildPath "$($inputFileBaseName).$($partNumber).part"
            
            $outputBuffer = $buffer
            if ($bytesRead -lt $buffer.Length) {
                $outputBuffer = New-Object byte[] $bytesRead
                [System.Array]::Copy($buffer, 0, $outputBuffer, 0, $bytesRead)
            }

            [System.IO.File]::WriteAllBytes($partFileName, $outputBuffer)
            Write-Host "Created part: '$partFileName' ($bytesRead bytes)"
            $partNumber++
            $totalBytesRead += $bytesRead
        }

        if ($partNumber -eq 1) { # No parts created, means file was likely smaller than part size or empty (though empty is checked)
             Write-Warning "Input file was smaller than the part size. Only one part created, or no parts if the file was empty."
             if ($inputFile.Length -gt 0 -and $totalBytesRead -eq 0) { # File has content but nothing read, this case should not happen with current logic
                throw "Error: Failed to read from input file, though it is not empty."
             }
        }
        
        Write-Host "File splitting completed successfully."
        Write-Host "Total parts created: $($partNumber - 1) in directory '$OutputDirectory'."
        Write-Host "Total bytes processed: $totalBytesRead bytes."

    } catch {
        Write-Error "An error occurred during file splitting: $($_.Exception.Message)"
    } finally {
        if ($null -ne $fileStream) {
            $fileStream.Close()
            $fileStream.Dispose()
            Write-Host "Input file stream closed."
        }
    }
}

function CombineFiles {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(Mandatory=$true)]
        [string]$InputDirectory,

        [string]$OutputFileName,

        [string]$OutputExtension
    )

    $outputFileStream = $null
    $partFileStreams = New-Object System.Collections.Generic.List[System.IO.FileStream]

    try {
        Write-Host "Initializing file recombination process..."

        if (-not (Test-Path $InputDirectory -PathType Container)) {
            throw "Error: Input directory not found at '$InputDirectory'. Please verify the directory path."
        }
        Write-Host "Scanning for part files in '$InputDirectory'..."
        $partFiles = Get-ChildItem -Path $InputDirectory -Filter "*.part" | Where-Object {$_.Name -match '.*\.\d+\.part$'}
        if ($partFiles.Count -eq 0) {
            throw "Error: No part files found in '$InputDirectory' matching the pattern '*.N.part'. Please check the directory and file naming."
        }
        Write-Host "Found $($partFiles.Count) potential part file(s)."

        $groupedParts = $partFiles | Group-Object {
            $currentFileNameForGrouping = $_.Name
            $baseToGroupOn = $null
            $regexMatchGroup = [regex]::Match($currentFileNameForGrouping, '(\d+)\.part$')
            if ($regexMatchGroup.Success) {
                $partSuffixGroup = $regexMatchGroup.Groups[1].Value + ".part"
                $stringToFindGroup = ".$partSuffixGroup"
                $lastIdxGroup = $currentFileNameForGrouping.LastIndexOf($stringToFindGroup)
                if ($lastIdxGroup -ge 0) {
                    $baseToGroupOn = $currentFileNameForGrouping.Substring(0, $lastIdxGroup)
                } else { 
                    $baseToGroupOn = $currentFileNameForGrouping + "_ERROR_LASTINDEXOF_FAILED_IN_GROUP" 
                }
            } else { 
                 $baseToGroupOn = $currentFileNameForGrouping + "_ERROR_REGEX_FAILED_IN_GROUP"
            }
            $baseToGroupOn
        }
        
        # Get the actual number of groups created by Group-Object
        $actualNumberOfGroups = ($groupedParts | Measure-Object).Count

        if ($actualNumberOfGroups -eq 0) { # Should not happen if $partFiles is not empty
             throw "Critical Error: No groups were formed by Group-Object. Cannot determine common base name."
        }

        if ($actualNumberOfGroups -gt 1) {
            # This block should NOT be hit in your case now
            $allDistinctBaseNamesArray = $groupedParts | ForEach-Object { $_.Name } | Sort-Object -Unique
            $distinctBaseNamesString = ($allDistinctBaseNamesArray | ForEach-Object { "'$_'" }) -join ", "
            throw "Error: Multiple distinct base names seem to have been generated. Group-Object process resulted in $actualNumberOfGroups group object(s). Base name(s) from these groups (after Sort-Object -Unique): [$distinctBaseNamesString]. This implies an unexpected issue with filename consistency or the grouping logic. Please review any enabled debug output."
        }
        
        # If we reach here, $actualNumberOfGroups must be 1.
        # $groupedParts is a collection containing one GroupInfo object.
        # Access its 'Name' property (the common base name).
        $commonBaseName = $groupedParts[0].Name 
        Write-Host "Determined common base name for parts: '$commonBaseName'"

        # Filter $partFiles for those starting with the now correctly determined $commonBaseName
        # Although all should match if logic is correct up to this point.
        $relevantPartFiles = $partFiles | Where-Object {$_.Name.StartsWith($commonBaseName) -and $_.Name -match '\.\d+\.part$'}

        $sortedPartFiles = $relevantPartFiles | Sort-Object {[int]($_.Name -replace "^$([regex]::Escape($commonBaseName))\.(\d+)\.part$", '$1')}
        
        Write-Host "Part files sorted numerically for recombination: $($sortedPartFiles.Count) files."
        if ($sortedPartFiles.Count -ne $partFiles.Count) {
            Write-Warning "Mismatch in part file counts after sorting. Initial: $($partFiles.Count), Sorted for common base: $($sortedPartFiles.Count)"
        }


        $finalOutputBaseName = if ([string]::IsNullOrWhiteSpace($OutputFileName)) { $commonBaseName } else { $OutputFileName }
        $finalOutputName = $finalOutputBaseName
        if (-not [string]::IsNullOrWhiteSpace($OutputExtension)) {
            $finalOutputName += ".$($OutputExtension.TrimStart('.'))"
        }
        $outputFilePath = Join-Path -Path $InputDirectory -ChildPath $finalOutputName
        
        Write-Host "The recombined file will be saved as: '$outputFilePath'"
        if (Test-Path $outputFilePath -PathType Leaf) {
            Write-Warning "Warning: Output file '$outputFilePath' already exists and will be overwritten."
            try {
                Remove-Item $outputFilePath -Force -ErrorAction Stop
                Write-Host "Existing file '$outputFilePath' removed."
            } catch {
                throw "Error: Could not remove existing output file '$outputFilePath'. Details: $($_.Exception.Message)"
            }
        }

        Write-Host "Starting recombination..."
        $outputFileStream = [System.IO.File]::Create($outputFilePath)
        $totalBytesWritten = 0

        foreach ($partFile in $sortedPartFiles) {
            Write-Host "Processing part: '$($partFile.FullName)' ($($partFile.Length) bytes)"
            if($partFile.Length -eq 0){
                Write-Warning "Warning: Part file '$($partFile.FullName)' is empty. It will be skipped."
                continue
            }
            try {
                $currentPartStream = [System.IO.File]::OpenRead($partFile.FullName)
                $partFileStreams.Add($currentPartStream) 
                $currentPartStream.CopyTo($outputFileStream)
                $totalBytesWritten += $partFile.Length
            } catch {
                 Write-Error "Error processing part file '$($partFile.FullName)': $($_.Exception.Message)"
                 throw # Re-throw to trigger main catch and cleanup
            }
        }

        Write-Host "File recombination completed successfully."
        Write-Host "Output file: '$outputFilePath'"
        Write-Host "Total parts processed: $($sortedPartFiles.Count)."
        Write-Host "Total bytes written to output file: $totalBytesWritten bytes."

    } catch {
        Write-Error "An error occurred during file recombination: $($_.Exception.Message)"
        if ($null -ne $outputFileStream) {
            $outputFileStream.Close() 
            $outputFileStream.Dispose()
            if ($PSCmdlet.ShouldProcess($outputFilePath, "Remove partially created output file due to error")) {
                 if (Test-Path $outputFilePath -PathType Leaf) {
                    try {
                        Remove-Item $outputFilePath -Force -ErrorAction Stop
                        Write-Warning "Partial output file '$outputFilePath' has been removed due to the error."
                    } catch {
                        Write-Warning "Warning: Could not remove partial output file '$outputFilePath' after error. Details: $($_.Exception.Message)"
                    }
                }
            }
        }
    } finally {
        if ($null -ne $outputFileStream -and $outputFileStream.CanWrite) {
             try { $outputFileStream.Flush() } catch { Write-Warning "Could not flush output stream: $($_.Exception.Message)"}
        }
        if ($null -ne $outputFileStream) {
            try { $outputFileStream.Close() } catch { Write-Warning "Could not close output stream: $($_.Exception.Message)"}
            try { $outputFileStream.Dispose() } catch { Write-Warning "Could not dispose output stream: $($_.Exception.Message)"}
            Write-Host "Output file stream closed/disposed."
        }
        if ($partFileStreams.Count -gt 0) {
            Write-Host "Closing all part file streams..."
            foreach ($stream in $partFileStreams) {
                if ($null -ne $stream) {
                    try { $stream.Close() } catch { Write-Warning "Could not close a part stream: $($_.Exception.Message)"}
                    try { $stream.Dispose() } catch { Write-Warning "Could not dispose a part stream: $($_.Exception.Message)"}
                }
            }
            Write-Host "$($partFileStreams.Count) part file stream(s) closed/disposed."
        }
    }
}

# Main script execution logic
try {
    Write-Host "----------------------------------------------------"
    Write-Host "File Part Utility - Mode: $Mode"
    Write-Host "Parameter Set Name: $($PSCmdlet.ParameterSetName)"
    Write-Host "----------------------------------------------------"

    switch ($PSCmdlet.ParameterSetName) {
        'SplitDefaultSet' {
            Write-Host "Action: Splitting file '$Path' with default part size ($($PartSizeMB)MB)."
            Split-File -Path $Path -OutputDirectory $OutputDirectory -PartSizeMB $PartSizeMB
        }
        'SplitKBSet' {
            Write-Host "Action: Splitting file '$Path' with PartSizeKB = $PartSizeKB."
            Split-File -Path $Path -OutputDirectory $OutputDirectory -PartSizeKB $PartSizeKB
        }
        'SplitMBSet' {
            Write-Host "Action: Splitting file '$Path' with PartSizeMB = $PartSizeMB."
            Split-File -Path $Path -OutputDirectory $OutputDirectory -PartSizeMB $PartSizeMB
        }
        'RecombineSet' {
            Write-Host "Action: Recombining file parts from directory '$InputDirectory'."
            CombineFiles -InputDirectory $InputDirectory -OutputFileName $OutputFileName -OutputExtension $OutputExtension
        }
        default {
            # This case should ideally not be reached if CmdletBinding and ParameterSets are correctly defined.
            throw "Critical Error: Unrecognized parameter set or mode combination ('$($PSCmdlet.ParameterSetName)'). Please check script parameters."
        }
    }
    Write-Host "----------------------------------------------------"
    Write-Host "Operation completed."
    Write-Host "----------------------------------------------------"
} catch {
    Write-Error "A critical error occurred in the script: $($_.Exception.Message)"
    Write-Host "----------------------------------------------------"
    Write-Host "Operation failed."
    Write-Host "----------------------------------------------------"
} finally {
    # Any global cleanup if needed in the future
    Write-Host "Script execution finished."
}
