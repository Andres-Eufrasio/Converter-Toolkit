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
        By default it does not replace the original file, and the bitrate is 192k.
    .PARAMETER Item
        Path to a single Opus file. If omitted, -Directory is searched
    .PARAMETER Directory
        Directory to search for Opus files. Defaults to the current directory.
    .PARAMETER Depth
        Number of subdirectory levels to search, (default)0 = top level only.
    .PARAMETER Bitrate
        MP3 bitrate. Defaults to 192k.
    .PARAMETER Verbose
        Select to have verbose output.
    .PARAMETER Replace
        Select to replace the original files.
    .PARAMETER Overwrite
        Select if preexisting files should be overwritten.
        Uses arguments y and n, otherwise defaults to prompting per item.
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-OpusToMp3 -Item file.opus
        Converts file.opus to file.mp3
    .EXAMPLE
        Convert-OpusToMp3 -Directory ./opussoundkit -Depth 3
        Converts all Opus files in opussoundkit and up to 3 levels deeper to MP3.
    .EXAMPLE
        Convert-OpusToMp3 -Item file.opus -Replace -Bitrate 320k
        Converts file.opus into an MP3 file with a bitrate of 320kbps and removes the original file
    .EXAMPLE
        Convert-OpusToMp3 -Replace -Overwrite y
        Converts all Opus files to MP3 and,
        if any MP3 files with the same name already exist, overwrites them.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 0,
        [string]$Bitrate = "192k",
        [switch]$Replace,
        [ValidateSet("","y","n")]
        [string]$Overwrite = ""
    )
    if ($Overwrite -ne ""){
        $Overwrite = "-" + $Overwrite
    }
    $codec_lib = "libmp3lame"
    if ($Item){
        $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).mp3"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to MP3")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe $Overwrite -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }
            else{
                ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }

            if ($Replace -and $LASTEXITCODE -eq 0){
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
                    ffmpeg.exe $Overwrite -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
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
                    ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
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
        Converts a specified MP3 file or searches a directory for MP3 files and converts them to Opus using FFmpeg
    .DESCRIPTION
        Converts a specified MP3 file or searches a directory for MP3 files and converts them to Opus using FFmpeg
        By default it does not replace the original file, and the bitrate is 128k.
    .PARAMETER Item
        Path to a single MP3 file. If omitted, -Directory is searched
    .PARAMETER Directory
        Directory to search for MP3 files. Defaults to the current directory.
    .PARAMETER Depth
        Number of subdirectory levels to search, (default)0 = top level only.
    .PARAMETER Bitrate
        Opus bitrate. Defaults to 128k.
    .PARAMETER Verbose
        Select to have verbose output.
    .PARAMETER Replace
        Select to replace the original files.
    .PARAMETER Overwrite
        Select if preexisting files should be overwritten.
        Uses arguments y and n, otherwise defaults to prompting per item.
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-Mp3ToOpus -Item file.mp3
        Converts file.mp3 to file.opus
    .EXAMPLE
        Convert-Mp3ToOpus -Directory ./opussoundkit -Depth 3
        Converts all MP3 files in opussoundkit and up to 3 levels deeper to Opus.
    .EXAMPLE
        Convert-Mp3ToOpus -Item file.mp3 -Replace -Bitrate 192k
        Converts file.mp3 into an Opus file with a bitrate of 192kbps and removes the original file
    .EXAMPLE
        Convert-Mp3ToOpus -Replace -Overwrite y
        Converts all MP3 files to Opus and,
        if any Opus files with the same name already exist, overwrites them.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 0,
        [string]$Bitrate = "128k",
        [switch]$Replace,
        [ValidateSet("","y","n")]
        [string]$Overwrite = ""

    )
    if ($overwrite -ne ""){
        $overwrite = "-"+ $overwrite
    }
    $codec_lib = "libopus"
    if ($Item){
                $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).opus"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to Opus")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe $overwrite -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }
            else{
                ffmpeg.exe $overwrite -hide_banner -loglevel error -nostats -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }

            if ($Replace -and $LASTEXITCODE -eq 0){
                Remove-Item $file.FullName
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
                    ffmpeg.exe $overwrite -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
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
                    ffmpeg.exe $overwrite -hide_banner -loglevel error -nostats -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
    }
}



function Convert-Mp4ToMp3 {
    <#
    .SYNOPSIS
        Converts a specified MP4 file or searches a directory for MP4 files and converts them to MP3 using FFmpeg
    .DESCRIPTION
        Converts a specified MP4 file or searches a directory for MP4 files and converts them to MP3 using FFmpeg
        By default it does not replace the original file, and the bitrate is 192k.
    .PARAMETER Item
        Path to a single MP4 file. If omitted, -Directory is searched
    .PARAMETER Directory
        Directory to search for MP4 files. Defaults to the current directory.
    .PARAMETER Depth
        Number of subdirectory levels to search, (default)1 = one level below the top level.
    .PARAMETER Bitrate
        MP3 bitrate. Defaults to 192k.
    .PARAMETER Verbose
        Select to have verbose output.
    .PARAMETER Replace
        Select to replace the original files.
    .PARAMETER Overwrite
        Select if preexisting files should be overwritten.
        Uses arguments y and n, otherwise defaults to prompting per item.
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-Mp4ToMp3 -Item file.mp4
        Converts file.mp4 to file.mp3
    .EXAMPLE
        Convert-Mp4ToMp3 -Directory ./videos -Depth 3
        Converts all MP4 files in videos and up to 3 levels deeper to MP3.
    .EXAMPLE
        Convert-Mp4ToMp3 -Item file.mp4 -Replace -Bitrate 320k
        Converts file.mp4 into an MP3 file with a bitrate of 320kbps and removes the original file
    .EXAMPLE
        Convert-Mp4ToMp3 -Replace -Overwrite y
        Converts all MP4 files to MP3 and,
        if any MP3 files with the same name already exist, overwrites them.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 1,
        [string]$Bitrate = "192k",
        [switch]$Replace,
        [ValidateSet("","y","n")]
        [string]$Overwrite = ""
    )
    if ($Overwrite -ne ""){
        $Overwrite = "-" + $Overwrite
    }
    $codec_lib = "libmp3lame"
    if ($Item){
        $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).mp3"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to MP3")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe $Overwrite -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }
            else{
                ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $file.FullName -c:a $codec_lib -b:a $Bitrate $output
            }

            if ($Replace -and $LASTEXITCODE -eq 0){
                Remove-Item $file.FullName
            }
        }
    }
    else{
        if ($VerbosePreference -eq 'Continue'){
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).mp3"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to MP3")) {
                    ffmpeg.exe $Overwrite -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
        else{
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).mp3"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to MP3")) {
                    ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $_.FullName -c:a $codec_lib -b:a $Bitrate $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
    }
}

function Convert-Mp4ToWav {
    <#
    .SYNOPSIS
        Converts a specified MP4 file or searches a directory for MP4 files and converts them to WAV using FFmpeg
    .DESCRIPTION
        Converts a specified MP4 file or searches a directory for MP4 files and converts them to WAV using FFmpeg
        By default it does not replace the original file. The output is 16-bit PCM at a 44100 Hz sample rate.
    .PARAMETER Item
        Path to a single MP4 file. If omitted, -Directory is searched
    .PARAMETER Directory
        Directory to search for MP4 files. Defaults to the current directory.
    .PARAMETER Depth
        Number of subdirectory levels to search, (default)1 = one level below the top level.
    .PARAMETER Verbose
        Select to have verbose output.
    .PARAMETER Replace
        Select to replace the original files.
    .PARAMETER Overwrite
        Select if preexisting files should be overwritten.
        Uses arguments y and n, otherwise defaults to prompting per item.
    .PARAMETER WhatIf
        Shows what actions would be performed without executing them.
    .EXAMPLE
        Convert-Mp4ToWav -Item file.mp4
        Converts file.mp4 to file.wav
    .EXAMPLE
        Convert-Mp4ToWav -Directory ./videos -Depth 3
        Converts all MP4 files in videos and up to 3 levels deeper to WAV.
    .EXAMPLE
        Convert-Mp4ToWav -Item file.mp4 -Replace
        Converts file.mp4 into a WAV file and removes the original file
    .EXAMPLE
        Convert-Mp4ToWav -Replace -Overwrite y
        Converts all MP4 files to WAV and,
        if any WAV files with the same name already exist, overwrites them.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Item,
        [string]$Directory = ".",
        [int]$Depth = 1,
        [switch]$Replace,
        [ValidateSet("","y","n")]
        [string]$Overwrite = ""
    )
    if ($Overwrite -ne ""){
        $Overwrite = "-" + $Overwrite
    }
    $codec_lib = "pcm_s16le"
    if ($Item){
        $file = Get-Item $Item -ErrorAction Stop
        $output = Join-Path $file.DirectoryName "$($file.BaseName).wav"
        if ($PSCmdlet.ShouldProcess($output, "Convert '$($file.FullName)' to WAV")) {
            if ($VerbosePreference -eq 'Continue'){
                ffmpeg.exe $Overwrite -i $file.FullName -c:a $codec_lib -ar 44100 $output
            }
            else{
                ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $file.FullName -c:a $codec_lib -ar 44100 $output
            }

            if ($Replace -and $LASTEXITCODE -eq 0){
                Remove-Item $file.FullName
            }
        }
    }
    else{
        if ($VerbosePreference -eq 'Continue'){
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).wav"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to WAV")) {
                    ffmpeg.exe $Overwrite -i $_.FullName -c:a $codec_lib -ar 44100 $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
        }
        else{
            Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                $output = Join-Path $_.DirectoryName "$($_.BaseName).wav"
                if ($PSCmdlet.ShouldProcess($output, "Convert '$($_.FullName)' to WAV")) {
                    ffmpeg.exe $Overwrite -hide_banner -loglevel error -nostats -i $_.FullName -c:a $codec_lib -ar 44100 $output
                    if ($Replace -and $LASTEXITCODE -eq 0){
                        Remove-Item $_.FullName
                    }
                }
            }
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
