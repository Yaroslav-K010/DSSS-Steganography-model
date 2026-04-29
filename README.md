# DSSS Audio Steganography (MATLAB)

## Overview

This project implements an audio steganography system based on **Direct Sequence Spread Spectrum (DSSS)**.
The algorithm embeds a hidden text message into an audio signal by modulating it with a pseudo-random sequence.

The approach provides:

* Low perceptibility of embedded data
* Resistance to simple signal analysis
* Key-based embedding for basic security

---

## Features

* Embedding text messages into audio signals
* Extraction of hidden messages
* Signal-to-Noise Ratio (SNR) analysis
* Pseudo-random sequence generation using a key
* MATLAB-based implementation for DSP experimentation

---

## Algorithm Description

### Embedding Process

1. Read input audio signal
2. Convert message into binary sequence
3. Divide audio into segments
4. Generate pseudo-random sequence (PSP) for each bit
5. Modulate signal using:

```
stego = signal + α · b · PSP
```

Where:

* `α` — embedding strength
* `b` — message bit mapped to {-1, +1}
* `PSP` — pseudo-random sequence

---

### Extraction Process

1. Split stego signal into segments
2. Regenerate PSP using the same key
3. Compute correlation between signal and PSP
4. Recover bits based on sign of correlation
5. Reconstruct original message

---

## Requirements

* MATLAB (R2020+ recommended)
* Signal Processing Toolbox (optional but useful)

---

## Usage

### 1. Prepare input data

Place files into the `input/` folder:

* `original.wav` — audio container
* `message.txt` — text message

---

### 2. Run embedding

Open MATLAB and run:

```
Main
```

Output:

* `output/stego.wav`

---

### 3. Run extraction

```
Extract
```

Recovered message will be displayed or saved.

---

### 4. Analyze signal quality

```
Analyze
```

Displays:

* SNR (Signal-to-Noise Ratio)
* Signal comparison

---

## Parameters

| Parameter   | Description                                                      |
| ----------- | ---------------------------------------------------------------- |
| `alpha`     | Embedding strength (trade-off between robustness and distortion) |
| `stego_key` | Seed for pseudo-random sequence                                  |
| `N`         | Segment length per bit                                           |

---

## Example Output

* Input message: `"Hello"`
* Output: Embedded into audio file
* SNR: typically **20–40 dB** depending on `alpha`

---

## Notes

* Too large `alpha` → noticeable distortion
* Too small `alpha` → weak extraction reliability
* Key must match for correct extraction

---

## Future Improvements

* Add GUI interface
* Support stereo audio
* Improve robustness against compression (MP3)
* Implement adaptive embedding
* Port to C++

---

## Author

Yaroslav Kurochkin
Student, Infocommunication Technologies and Communication Systems

---

## License

This project is for educational purposes.
