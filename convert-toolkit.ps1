if (Get-Command ffmpeg -ErrorAction SilentlyContinue){

}
else{
    Write-Host "No instance of ffmpeg found" -ForegroundColor Red
    Write-Host "Please use 'winget install ffmpeg' or 'choco install ffmpeg'" 
    exit 0
}


function Convert-OpusToMp3 {
    param(
        [int]$Depth = 1,
        [string]$Item
    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a libmp3lame -b:a 320k (Join-Path $file.DirectoryName "$($file.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.opus' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libmp3lame -b:a 320k (Join-Path $_.DirectoryName "$($file.BaseName).mp3")
            }
    }
}

function Convert-Mp3ToOpus {
    <#
    .SYNOPSIS
        Converts a specified MP3 file  of searches a directory for MP3 files and converts them to Opus using FFmpeg
    .PARAMETER Item
        Path to a single MP3 file. If ommited, -Directory is searched
    .PARAMETER Directory
        Directory to search for MP3 files. Defaults to the current directory.
    .PARAMETER Depth
        Amount of subdirectories to search, (default)0 = top level only. 
    .PARAMETER Bitrate
        Opus bitrate. Defaults to 128k.
    .NOTES
        Outputs files using a 128 kbps bitrate
    
    #>
    param(
        [string]$Item,
        [int]$Depth = 0,
        [string]$Directory = ".",
        [string]$Bitrate = "128k"

    )
    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $_.FullName -c:a libopus -b:a $Bitrate(Join-Path $file.DirectoryName "$($file.BaseName).opus")
    } else {
        Get-ChildItem -Depth $Depth -Path $Directory |
            Where-Object { $_.Extension -eq '.mp3' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libopus -b:a $Bitrate(Join-Path $_.DirectoryName "$($file.BaseName).opus")
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
        ffmpeg.exe -i $file.FullName -c:a libmp3lame -q:a 2 -ac 2(Join-Path $file.DirectoryName "$($file.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.mp4' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libmp3lame -q:a 2 -ac 2(Join-Path $_.DirectoryName "$($file.BaseName).mp3")
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
