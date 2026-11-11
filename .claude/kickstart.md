# Kickstart (temporary, one-time task)

Build the two baseline notebooks, `images.ipynb` and `audio.ipynb`. Nothing else.

## Cell order (both notebooks)

1. `EXPERIMENTS` list: the baseline run, plus one commented-out example entry.
2. Setup: imports, model load, done-check helper.
3. Run loop.
4. Gallery: every output listed in the CSV, shown with its parameters (images inline, audio as players).

In `audio.ipynb` the commented-out example is a post-processing run (resample or EQ) that points at the baseline clip's output file. The post-processing code must be in place even though the baseline doesn't use it.

## Baseline values

| | Images | Audio |
|---|---|---|
| seed | 42 | 42 |
| steps | 30 | - |
| CFG / guidance | 7.5 | 3.0 |
| size / duration | 512x512 | 10 s |
| scheduler | PNDM | - |
| temperature | - | 1.0 |
| sampling rate | - | 32000 Hz (MusicGen native) |
| negative prompt | "" (empty, but written out) | - |
| group | "baseline" | "baseline" |

## Theme and placeholder prompts

Theme: lakeside cabin at sunset. Vlad will rewrite both prompts in his own words.

- Image: `wooden cabin, red canoe on the left shore, two pine trees, mountains reflected in the lake, golden sunset light, no people, no text`
  (deliberately checkable: object count, colors, left/right, reflection. Keep those properties if asked to adjust it.)
- Audio: `calm lakeside evening ambient music, slow tempo around 60 BPM, soft piano and strings, atmospheric`

## Implementation notes

- Download the model weights into the project's `models/` folder (`cache_dir="models"`). Before the first download, add `models/` to `.gitignore` and check with `git status` that the folder does not show up. Never commit weights.
- Scheduler names in `EXPERIMENTS` are plain strings mapped to diffusers classes in the setup cell; include a few common ones (PNDM, DDIM, Euler, Euler a, DPM++ 2M).
- MusicGen: duration is set through `max_new_tokens` (duration x the model's frame rate); temperature needs `do_sample=True`; `generate` takes no generator, so reseed torch right before each call.
- Post-processing: `scipy.signal` only (polyphase resampling; Butterworth low-pass / high-pass with a cutoff in Hz).

## Rules for this task

- Each notebook must run top to bottom at baseline and produce exactly one output and one CSV row. Run it to check, then run it again to confirm the second pass prints SKIPPED and adds no row.
- Do not run any other experiments and do not change any baseline value.
- When done, report: what was verified, what was not (the post-processing path stays untested until Vlad enables a run), and the list of parameters he can change in each notebook with a one-line meaning for each. Then stop.

## Cleanup

Finish by reminding Vlad: once he confirms both notebooks work, delete this file and the `@.claude/kickstart.md` line in `CLAUDE.md`.
