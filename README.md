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

## Sending messages

- **Quick commands:** Hello, Need Help, Emergency, Move Forward, Move Backward, Stop
- **Custom text:** type any message and press *Send Text* (or Enter)
- **Voice:** say anything. Recognised commands are sent in their clean form
  (e.g. "go forward" -> "Move Forward"); any other phrase is sent exactly as spoken.

Every send uses the **MessageID** shown on the page: a random 5-digit number by default,
or one you type. A fresh random ID is picked after each send.

## Firebase nodes

Everything lives under `/LiFi`. Text and Audio are strings.

- **Text mode** writes `Type = 1`, `Text = "<message>"`, `Audio = ""`, `Complete = 0`, `MessageID = <id>`
- **Voice mode** writes `Type = 2`, `Text = ""`, `Audio = ""`, `Complete = 0`, waits 5 seconds, polls `LDR`,
  and once `LDR = 1` writes `Audio = "<message>"` and `MessageID = <id>`
- `LDR`, `Laser`, `PartialText` and `RecievedText` are only read and shown, never written.

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
