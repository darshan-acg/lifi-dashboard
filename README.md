# Underwater Li-Fi Command Dashboard

Text, voice, image and video command dashboard for the underwater Li-Fi link, backed by Firebase Realtime Database.

**Live dashboard:** https://darshan-acg.github.io/lifi-dashboard/

## Why this is hosted instead of shared as a file

The dashboard uses the browser microphone (Web Speech API). Browsers only allow the
microphone on a **secure origin** — `https://` or `http://localhost`.

Sending `ks5623.html` through WhatsApp or copying it to another laptop does not work:

| How the page is opened | Address the browser sees | Microphone |
|---|---|---|
| GitHub Pages link | `https://…github.io/…` | works |
| Local test server | `http://localhost:8000` | works |
| Double-clicked file | `file:///C:/…` | blocked — permission cannot be stored |
| Opened from WhatsApp on Android | `content://com.whatsapp.provider.media/…` | blocked — no Allow dialog exists |

So share **the link**, never the file.

## Commands

| Number | Command |
|---|---|
| 1 | Hello |
| 2 | Need Help |
| 3 | Emergency |
| 4 | Move Forward |
| 5 | Move Backward |
| 6 | Stop |

Speech is matched in four steps — exact name, alias table (`hi`, `sos`, `halt`, `reverse`…),
command inside a longer sentence, then a fuzzy match — so ordinary speech still maps onto
the six fixed commands.

## Firebase nodes

Everything lives under `/LiFi_underwater` and every value is a number.

- **Text mode** writes `Type = 1`, `Text = <number>`, `Audio = 0`
- **Voice mode** writes `Type = 2`, `Text = 0`, `Audio = 0`, waits 5 seconds, polls `LDR`,
  and once `LDR = 1` writes `Audio = <number>`

- **Image mode** writes `Type = 3`, clears Text/Audio and both media nodes' flags,
  waits 5 seconds after Firebase confirms the write, then sets `Image/tx = 1` and `Image/rx = 1` together.
- **Video mode** follows the same sequence with `Type = 4` and `Video/tx = 1`, `Video/rx = 1`.
- Image and video modes accept one matching, non-empty file through the file picker or drag-and-drop,
  with a local preview. Only numeric control flags are sent; file contents are not uploaded.
- **Reset All Send Nodes** clears Type/Text/Audio and Image/Video tx/rx without changing LDR.

## Updating the published dashboard

Edit `ks5623.html` in the project folder, then run `publish.bat` from this folder.
It copies the file to `index.html`, commits and pushes; GitHub Pages redeploys in about a minute.

## Offline alternative

`ks5623.py` in the project folder runs the same dashboard with speech recognition and
text-to-speech inside Python, so it needs no hosting and no browser microphone permission:

```
pip install SpeechRecognition pyttsx3 requests pyaudio
python ks5623.py
```
