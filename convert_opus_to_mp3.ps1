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
    param(
        [int]$Depth = 1,
        [string]$Item
    )

    if ($Item) {
        $file = Get-Item $Item -ErrorAction Stop
        ffmpeg.exe -i $file.FullName -c:a libopus -b:a 128k(Join-Path $file.DirectoryName "$($file.BaseName).opus")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.mp3' } |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName c:a libopus -b:a 128k(Join-Path $_.DirectoryName "$($file.BaseName).opus")
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
                ffmpeg.exe -i $_.FullName c:a libmp3lame -q:a 2 -ac 2(Join-Path $_.DirectoryName "$($file.BaseName).mp3")
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
                ffmpeg.exe -i $_.FullName c:a pcm_s16le -ar 44100 -ac 2(Join-Path $_.DirectoryName "$($file.BaseName).wav")
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
        ffmpeg.exe -i $file.FullName -c:a libmp3lame -q:a 2 2(Join-Path $file.DirectoryName "$($file.BaseName).mp3")
    } else {
        Get-ChildItem -Depth $Depth |
            Where-Object { $_.Extension -eq '.wav'} |
            ForEach-Object {
                ffmpeg.exe -i $_.FullName -c:a libmp3lame -q:a 2(Join-Path $_.DirectoryName "$($file.BaseName).mp3")
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