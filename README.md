# kowairo

A Flutter project for Kowairo.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## 📦 Whisper GGML Model Setup

This project uses **whisper_ggml** for offline voice transcription.
The Whisper models (`.bin` files) are **not stored in Git** because of their size.
Please download them manually before running the app.

### 1. Create the folder

```
assets/ggml/
```

### 2. Download the Whisper models

#### Tiny model (recommended for mobile)

```
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin -O assets/ggml/ggml-tiny.bin
```

#### Base model

```
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin -O assets/ggml/ggml-base.bin
```

Or download manually:

* [https://huggingface.co/ggerganov/whisper.cpp/tree/main](https://huggingface.co/ggerganov/whisper.cpp/tree/main)
