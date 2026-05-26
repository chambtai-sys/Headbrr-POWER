<#
.SYNOPSIS
    Headbrr POWER - Studio-grade headphone tester for PowerShell.

.DESCRIPTION
    A pure PowerShell implementation of the Headbrr audio engine. 
    Allows testing of frequency response, channel balance, and phase without external dependencies.

.EXAMPLE
    Start-Headbrr
#>

function New-WavStream {
    param(
        [double]$Frequency = 440,
        [double]$Duration = 1.0,
        [string]$Channel = "Both", # "Left", "Right", "Both"
        [string]$Type = "Sine",    # "Sine", "WhiteNoise", "OutPhase"
        [double]$StartFreq = 20,
        [double]$EndFreq = 20000,
        [double]$Amplitude = 0.3
    )

    $sampleRate = 44100
    $channels = 2
    $bitsPerSample = 16
    $totalSamples = [int]($sampleRate * $Duration)
    $blockAlign = $channels * ($bitsPerSample / 8)
    $byteRate = $sampleRate * $blockAlign
    $dataSize = $totalSamples * $blockAlign

    $ms = New-Object System.IO.MemoryStream
    $bw = New-Object System.IO.BinaryWriter($ms)

    # WAV Header
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
    $bw.Write([int32](36 + $dataSize))
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
    $bw.Write([int32]16)
    $bw.Write([int16]1) # PCM
    $bw.Write([int16]$channels)
    $bw.Write([int32]$sampleRate)
    $bw.Write([int32]$byteRate)
    $bw.Write([int16]$blockAlign)
    $bw.Write([int16]$bitsPerSample)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
    $bw.Write([int32]$dataSize)

    $maxAmp = [int16]::MaxValue

    for ($i = 0; $i -lt $totalSamples; $i++) {
        $t = $i / $sampleRate
        $left = 0.0
        $right = 0.0

        if ($Type -eq "Sine") {
            $val = [Math]::Sin(2 * [Math]::PI * $Frequency * $t) * $Amplitude
            if ($Channel -eq "Left" -or $Channel -eq "Both") { $left = $val }
            if ($Channel -eq "Right" -or $Channel -eq "Both") { $right = $val }
        }
        elseif ($Type -eq "Sweep") {
            # Exponential Sweep
            $currentFreq = $StartFreq * [Math]::Pow(($EndFreq / $StartFreq), ($t / $Duration))
            $val = [Math]::Sin(2 * [Math]::PI * $currentFreq * $t) * $Amplitude
            $left = $right = $val
        }
        elseif ($Type -eq "WhiteNoise") {
            $val = ((Get-Random -Minimum -100 -Maximum 101) / 100.0) * $Amplitude
            $left = $right = $val
        }
        elseif ($Type -eq "OutPhase") {
            $val = [Math]::Sin(2 * [Math]::PI * $Frequency * $t) * $Amplitude
            $left = $val
            $right = -$val # Invert right channel
        }

        $bw.Write([int16]([Math]::Round($left * $maxAmp)))
        $bw.Write([int16]([Math]::Round($right * $maxAmp)))
    }

    $bw.Flush()
    $ms.Position = 0
    return $ms
}

function Play-WavStream {
    param($Stream)
    $player = New-Object System.Media.SoundPlayer
    $player.Stream = $Stream
    $player.PlaySync()
    $Stream.Dispose()
}

function Start-Headbrr {
    Clear-Host
    Write-Host "`n  ██╗  ██╗███████╗ █████╗ ██████╗ ██████╗ ██████╗ ██████╗ " -ForegroundColor Cyan
    Write-Host "  ██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗" -ForegroundColor Cyan
    Write-Host "  ███████║█████╗  ███████║██║  ██║██████╔╝██████╔╝██████╔╝" -ForegroundColor Cyan
    Write-Host "  ██╔══██║██╔══╝  ██╔══██║██║  ██║██╔══██╗██╔══██╗██╔══██╗" -ForegroundColor Cyan
    Write-Host "  ██║  ██║███████║██║  ██║██████║██████║██║  ██║██║  ██║" -ForegroundColor Cyan
    Write-Host "  ╚═╝  ╚═╝╚═══════╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝" -ForegroundColor Cyan
    Write-Host "  PowerShell Edition // v1.0.0 // PURE SIGNAL`n" -ForegroundColor Gray
    
    while ($true) {
        Write-Host "  [1] Channel Check (L -> R)"
        Write-Host "  [2] Exponential Sweep (20Hz - 20kHz)"
        Write-Host "  [3] Sub-Bass Pulse (30Hz)"
        Write-Host "  [4] Mid-Range Clarity (1kHz)"
        Write-Host "  [5] Treble / Air (15kHz)"
        Write-Host "  [6] White Noise (Isolation/Burn-in)"
        Write-Host "  [7] Phase Check (In-Phase vs Out-Phase)"
        Write-Host "  [q] Exit"
        Write-Host ""
        $choice = Read-Host "  Select target"

        switch ($choice) {
            "1" {
                Write-Host "  [LEFT]" -ForegroundColor Yellow
                Play-WavStream (New-WavStream -Channel "Left" -Duration 1.5)
                Write-Host "  [RIGHT]" -ForegroundColor Yellow
                Play-WavStream (New-WavStream -Channel "Right" -Duration 1.5)
            }
            "2" {
                Write-Host "  [SWEEPING 20Hz -> 20kHz]" -ForegroundColor Cyan
                Play-WavStream (New-WavStream -Type "Sweep" -Duration 10)
            }
            "3" {
                Write-Host "  [SUB-BASS 30Hz]" -ForegroundColor Red
                Play-WavStream (New-WavStream -Frequency 30 -Duration 3)
            }
            "4" {
                Write-Host "  [MIDS 1kHz]" -ForegroundColor Green
                Play-WavStream (New-WavStream -Frequency 1000 -Duration 3)
            }
            "5" {
                Write-Host "  [AIR 15kHz]" -ForegroundColor Blue
                Play-WavStream (New-WavStream -Frequency 15000 -Duration 3)
            }
            "6" {
                Write-Host "  [WHITE NOISE]" -ForegroundColor White
                Play-WavStream (New-WavStream -Type "WhiteNoise" -Duration 5)
            }
            "7" {
                Write-Host "  [IN-PHASE] (Sound should be CENTERED)" -ForegroundColor Green
                Play-WavStream (New-WavStream -Type "Sine" -Frequency 440 -Duration 3)
                Write-Host "  [OUT-PHASE] (Sound should be HOLLOW/WIDE)" -ForegroundColor Red
                Play-WavStream (New-WavStream -Type "OutPhase" -Frequency 440 -Duration 3)
            }
            "q" { return }
        }
    }
}

# Add built-in alias
if (-not (Get-Alias hb -ErrorAction SilentlyContinue)) {
    New-Alias -Name hb -Value Start-Headbrr
}

Write-Host "  Headbrr POWER loaded! Type 'hb' to start testing." -ForegroundColor Gray
