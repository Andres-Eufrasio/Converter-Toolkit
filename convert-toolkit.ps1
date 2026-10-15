if (Get-Command ffmpeg -ErrorAction SilentlyContinue){

}
else{
    Write-Host "No instance of ffmpeg found" -ForegroundColor Red
    Write-Host "Please use 'winget install ffmpeg' or 'choco install ffmpeg'" 
    exit 0
}


function Convert-OpusToMp3 {
    <#
    .SYNOPSIS
        Converts a specified Opus file or searches a directory for Opus files and converts them to MP3 using FFmpeg
    .DESCRIPTION
        Converts a specified Opus file or searches a directory for Opus files and converts them to MP3 using FFmpeg
        By default it does not replace the original file, and the bitrate is 320k.
    .PARAMETER Item
        Path to a single Opus file. If omitted, -Directory is searched
    .PARAMETER Directory
        Directory to search for Opus files. Defaults to the current directory.
    .PARAMETER Depth
        Amount of subdirectories to search, (default)0 = top level only.
    .PARAMETER Bitrate
        MP3 bitrate. Defaults to 192kbps.
    .PARAMETER Overwrite
        Removes the original Opus file after a successful conversion.
    .PARAMETER Verbose
        Select if to have the output be verbose
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-OpusToMp3 -Item file.opus
        Converts file.opus to file.mp3
    .EXAMPLE
        Convert-OpusToMp3 -Directory ./opussoundkit -Depth 3
        Converts all opus files in opussoundkit and up to 3 levels deeper to mp3.
    .EXAMPLE
        Convert-OpusToMp3 -Item file.opus -Overwrite -Bitrate 320k 
        Converts file.opus into an mp3 file with a bitrate of 320kbps and removes the original file
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 0,
        [string]$Bitrate = "192K",
        [switch]$Overwrite
    )
    if ($Item){
        $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).mp3"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to MP3")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe -i $file.FullName -c:a libmp3lame -b:a $Bitrate $output
            }
            else{
                ffmpeg.exe -hide_banner -loglevel error -nostats -i $file.FullName -c:a libmp3lame -b:a $Bitrate $output
            }

            if ($Overwrite -and $LASTEXITCODE -eq 0){
                Remove-Item $file.FullName
            }
        }
    }
    else{
        if ($VerbosePreference -eq 'Continue'){
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.opus' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).mp3"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to MP3")) {
                    ffmpeg.exe -i $_.FullName -c:a libmp3lame -b:a $Bitrate $output
                    if ($Overwrite -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
        else{
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.opus' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).mp3"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to MP3")) {
                    ffmpeg.exe -hide_banner -loglevel error -nostats -i $_.FullName -c:a libmp3lame -b:a $Bitrate $output
                    if ($Overwrite -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
    }
}

function Convert-Mp3ToOpus {
    <#
    .SYNOPSIS
        Converts a specified MP3 file  of searches a directory for MP3 files and converts them to Opus using FFmpeg
    .DESCRIPTION
        Converts a specified MP3 file  of searches a directory for MP3 files and converts them to Opus using FFmpeg
        By default it does not replace the default file, and the bitrate is 128k.
    .PARAMETER Item
        Path to a single MP3 file. If ommited, -Directory is searched
    .PARAMETER Directory
        Directory to search for MP3 files. Defaults to the current directory.
    .PARAMETER Depth
        Amount of subdirectories to search, (default)0 = top level only. 
    .PARAMETER Bitrate         Opus bitrate. Defaults to 128k.
    .PARAMETER Verbose
        Select if to have the output be verbose
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-Mp3ToOpus -Item file.opus
        Converts file.mp3 to file.opus
    .EXAMPLE
        Convert-Mp3ToOpus -Directory ./opussoundkit -Depth 3
        Converts all mp3 files in opussoundkit and up to 3 files deeper to opus.
    .EXAMPLE
        Convert-Mp3ToOpus -Input file.opus -Overwrite -Bitrate 192K
        Converts file.mp3 into a opus file with a bitrate of 192kbps and removes the orignial file
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 0,
        [string]$Bitrate = "128k",
        [switch]$Overwrite  
    )
    if ($Item){
        $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).opus"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to Opus")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe -i $file.FullName -c:a libopus -b:a $Bitrate $output
            }
            else{
                ffmpeg.exe -hide_banner -loglevel error -nostats -i $file.FullName -c:a libopus -b:a $Bitrate $output
            }

            if ($Overwrite -and $LASTEXITCODE -eq 0){
                Remove-Item $Item
            }
        }

    } 
    else{
        if ($VerbosePreference -eq 'Continue'){
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp3' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).opus"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to Opus")) {
                    ffmpeg.exe -i $_.FullName -c:a libopus -b:a $Bitrate $output
                    if ($Overwrite -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
        else{
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp3' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).opus"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to Opus")) {
                    ffmpeg.exe -hide_banner -loglevel error -nostats -i $_.FullName -c:a libopus -b:a $Bitrate $output
                    if ($Overwrite -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
    }
}

function Convert-Mp4ToMp3 {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a libmp3lame -q:a 2 -ac 0(Join-Path $file.DirectoryName "$($file.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libmp3lame -q:a 2 -ac 0(Join-Path $_.DirectoryName "$($file.BaseName).mp3")
            }
    }
}

function Convert-Mp4ToWav {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a pcm_s16le -ar 44100 -ac 2(Join-Path $file.DirectoryName "$($file.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a pcm_s16le -ar 44100 -ac 2(Join-Path $_.DirectoryName "$($file.BaseName).mp3")
            }
    }
}

function Convert-Mp3ToWav {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a pcm_s16le -ar 44100 -ac 2(Join-Path $file.DirectoryName "$($file.BaseName).wav")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.Mp3' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a pcm_s16le -ar 44100 -ac 2(Join-Path $_.DirectoryName "$($file.BaseName).wav")
            }
    }
} 

function Convert-WavToMp3 {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a libmp3lame -q:a 2 2(Join-Path $file.DirectoryName "$($_.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.wav'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libmp3lame -q:a 2(Join-Path $_.DirectoryName "$($_.BaseName).mp3")
            }
    }
} 

function Convert-WavToAiff {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a pcm_s16be -ar 44100(Join-Path $file.DirectoryName "$($file.BaseName).aiff")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.wav'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a pcm_s16be -ar 44100 (Join-Path $_.DirectoryName "$($file.BaseName).aiff")
            }
    }
} 

function Convert-AiffToWav {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a pcm_s16le -ar 44100(Join-Path $file.DirectoryName "$($file.BaseName).wav")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.aiff'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a pcm_s16le -ar 44100 (Join-Path $_.DirectoryName "$($file.BaseName).wav")
            }
    }
}

function Convert-AiffToWav {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a pcm_s16le -ar 44100(Join-Path $file.DirectoryName "$($file.BaseName).wav")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.aiff'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a pcm_s16le -ar 44100 (Join-Path $_.DirectoryName "$($file.BaseName).wav")
            }
    }
}


function Convert-M4aToWav {
     param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName (Join-Path $file.DirectoryName "$($file.BaseName).wav")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.m4a'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName (Join-Path $_.DirectoryName "$($file.BaseName).wav")
            }
    }   
}

function Convert-WavtoM4a {
     param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName (Join-Path $file.DirectoryName "$($file.BaseName).m4a")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.wav'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName (Join-Path $_.DirectoryName "$($file.BaseName).m4a")
            }
    }   
}
