# ⚡ Headbrr POWER

**The definitive studio-grade headphone tester for Microsoft PowerShell.**

![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

Headbrr POWER is the high-performance, terminal-native port of the [Headbrr](https://github.com/chambtai-sys/Headbrr) audio engine. Built entirely in PowerShell, it generates high-fidelity PCM audio streams in memory to test your gear with zero external dependencies.

## ✨ Features

- **🎯 Pure PCM Synthesis**: High-fidelity 16-bit/44.1kHz audio generation.
- **📡 Advanced Sweeps**: 10-second exponential frequency sweeps (20Hz - 20kHz).
- **⚖️ Stereo Diagnostics**: Isolated channel checks and phase polarity verification.
- **🌫️ Noise Generation**: Pure white noise for burn-in and isolation testing.
- **⚡ Ultra-Light**: Single script, zero installation, no external files.
- **⌨️ Built-in Alias**: Launch instantly with the `hb` command.

## 🛠️ Quick Start

1. **Clone the repository**:
   ```powershell
   git clone https://github.com/chambtai-sys/Headbrr-POWER.git
   cd Headbrr-POWER
   ```

2. **Import and Run**:
   ```powershell
   . ./Headbrr-POWER.ps1
   hb
   ```

## 🚀 Commands

| Task | Description |
|---|---|
| **Channel Check** | Verify Left/Right driver separation. |
| **Exp. Sweep** | Find rattles or frequency dips with a smooth sweep. |
| **Sub-Bass Check** | Test driver control at 30Hz. |
| **Phase Check** | Detect wiring issues using In-Phase/Out-of-Phase tones. |

## 📁 Structure

```text
Headbrr-POWER/
├── Headbrr-POWER.ps1  # The core audio engine script
├── README.md          # Documentation
└── LICENSE            # MIT License
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
