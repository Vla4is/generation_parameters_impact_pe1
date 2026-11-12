# Kickstart: project specifics

Deliverable: 24 images + 24 audio clips, every run recorded in a results table.

## Models

- Images: `stable-diffusion-v1-5/stable-diffusion-v1-5` via diffusers (the mirror; the `runwayml` repo no longer exists), in fp16.
- Audio: `facebook/musicgen-small` via transformers, at its default precision (float32).
- Add attention slicing or CPU offload only if VRAM actually runs out.

## Notebooks

`images.ipynb` and `audio.ipynb`, with the same cell order:

1. `EXPERIMENTS` list: the baseline run, plus one commented-out example entry.
2. Setup: imports, model load, done-check helper.
3. Run loop.
4. Gallery: every output listed in the CSV, shown with its parameters (images inline, audio as players).

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

- `results/images.csv` and `results/audio.csv` are the single source of truth: every parameter, model name and library version, output filename, rating (1-5), notes.
- Plain comma-separated UTF-8. Vlad fills in rating and notes by hand in VS Code.
- A run is already done if the CSV has a row with identical parameters (compared by value) and its output file exists. The loop then does not regenerate: it prints SKIPPED with the row number and filename, shows the existing output, and adds no row.
- "Identical parameters" means the `EXPERIMENTS` keys only. Model name and library versions are recorded in the row but never make a run new.
- A duplicate entry inside `EXPERIMENTS` gets a warning and is skipped.
- A new run prints NEW and appends one row, in append mode only.
- The loop ends with "N new, M skipped".
- Outputs go to `outputs/images/` and `outputs/audio/`. Filenames are descriptive and unique: group, the key parameters, and a short hash of all parameters.

## Implementation notes

- Download the model weights into the project's `models/` folder (`cache_dir="models"`). Before the first download, add `models/` to `.gitignore` and check with `git status` that the folder does not show up. Never commit weights.
- Scheduler names in `EXPERIMENTS` are plain strings mapped to diffusers classes in the setup cell; include a few common ones (PNDM, DDIM, Euler, Euler a, DPM++ 2M).
- MusicGen: duration is set through `max_new_tokens` (duration x the model's frame rate); temperature needs `do_sample=True`; `generate` takes no generator, so reseed torch right before each call.

## Build task (one-time)

Build the two baseline notebooks.

- Each notebook must run top to bottom at baseline and produce exactly one output and one CSV row. Run it to check, then run it again to confirm the second pass prints SKIPPED and adds no row.
- Do not run any other experiments and do not change any baseline value.
- When done, report: what was verified, what was not, and the list of parameters he can change in each notebook with a one-line meaning for each. Then stop.

## Cleanup

Finish by reminding Vlad: once he confirms both notebooks work, delete this file and the `@.claude/kickstart.md` line in `CLAUDE.md`.
