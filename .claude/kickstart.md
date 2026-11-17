# Kickstart: project specifics

Deliverable: 24 images + 24 audio clips, every run recorded in a results table.

## Models

- Images: `stable-diffusion-v1-5/stable-diffusion-v1-5` via diffusers (the mirror; the `runwayml` repo no longer exists), in fp16, with the safety checker off (`safety_checker=None`).
- Audio: `facebook/musicgen-small` via transformers, at its default precision (float32).
- Add attention slicing or CPU offload only if VRAM actually runs out.

## Notebooks

`images.ipynb` and `audio.ipynb`, with the same cell order:

1. `EXPERIMENTS` list: the baseline run, plus one commented-out example entry.
2. Setup: imports (including `helpers.py`), model load.
3. Run loop: shows each run's output right under it (images inline, audio as players), for new and skipped runs alike.

`helpers.py` sits next to the notebooks and is shared by both. It holds every function: the parameter hash, the output filename, and the CSV append. It loads no models and knows nothing about images or audio.

## EXPERIMENTS list

- Each run is one dict in the `EXPERIMENTS` list at the top of the notebook, with every parameter written out: group, prompt, negative prompt, seed, steps, CFG, resolution, scheduler (images); group, prompt, seed, duration, temperature, guidance, top_k (audio). No hidden defaults.
- Each run seeds itself, so results never depend on run order.
- Changing any parameter makes it a new run.

## Baseline values

| | Images | Audio |
|---|---|---|
| seed | 42 | 42 |
| steps | 30 | - |
| CFG / guidance | 7.5 | 3.0 |
| size / duration | 512x512 | 10 s |
| scheduler | PNDM | - |
| temperature | - | 1.0 |
| top_k | - | 250 |
| negative prompt | "" (empty, but written out) | - |
| group | "baseline" | "baseline" |

## Theme and placeholder prompts

Theme: lakeside cabin at sunset. Vlad will rewrite both prompts in his own words.

- Image: `wooden cabin, red canoe on the left shore, two pine trees, mountains reflected in the lake, golden sunset light, no people, no text`
  (deliberately checkable: object count, colors, left/right, reflection. Keep those properties if asked to adjust it.)
- Audio: `calm lakeside evening ambient music, slow tempo around 60 BPM, soft piano and strings, atmospheric`

## Results CSV and re-runs

- Each entry gets a short hash of all its `EXPERIMENTS` keys. The hash is part of the output filename, so the filename identifies the run.
- A run is already done if its output file exists. The loop then prints SKIPPED with the filename, shows the existing output, and adds no row. This is the only check; the CSV is never read to decide anything.
- Otherwise the run is NEW: the loop generates, saves the file, and appends one row.
- `results/images.csv` and `results/audio.csv` are plain results logs, only ever appended to: every parameter, the hash, output filename, rating (1-5), notes. A missing CSV is created with its header row. Vlad may delete a CSV at any time to start a clean log.
- Plain comma-separated UTF-8. Vlad fills in rating and notes by hand in VS Code.
- The loop ends with "N new, M skipped".
- Outputs go to `outputs/images/` and `outputs/audio/`. A filename is the group plus the hash, for example `baseline_a3f9c21b.png`.

## Implementation notes

- Download the model weights into the project's `models/` folder (`cache_dir="models"`). Before the first download, add `models/` to `.gitignore` and check with `git status` that the folder does not show up. Never commit weights.
- Scheduler names in `EXPERIMENTS` are plain strings mapped to diffusers classes in the setup cell; include a few common ones (PNDM, DDIM, Euler, Euler a, DPM++ 2M).
- MusicGen: duration is set through `max_new_tokens` (duration x the model's frame rate); temperature needs `do_sample=True`; `generate` takes no generator, so reseed torch right before each call. Clips are saved as WAV exactly as the model outputs them, with no conversion.

## Build task (one-time)

Build the two baseline notebooks.

- Each notebook must run top to bottom at baseline and produce exactly one output and one CSV row. Run it to check, then run it again to confirm the second pass prints SKIPPED and adds no row.
- Do not run any other experiments and do not change any baseline value.
- When done, report: what was verified, what was not, and the list of parameters he can change in each notebook with a one-line meaning for each. Then stop.
