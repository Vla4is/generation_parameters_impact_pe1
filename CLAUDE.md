# LAB1: prompt engineering and generation parameters

@.claude/kickstart.md

University lab: how prompt wording and generation parameters change image quality and audio quality. Deliverable: 24 images + 24 audio clips, every run recorded in a results table. Vlad does the experiments, ratings, analysis and presentation himself.

## Hardware and models

- Local RTX 3060 Ti, 8 GB VRAM. CUDA/PyTorch are already set up; no install help unless asked. No paid APIs.
- Environment: everything lives in `LAB1/.venv` (Python 3.12.10). PyTorch 2.11.0 built for CUDA 12.8 (`+cu128`); driver supports CUDA 13.4. Pinned in `requirements.txt`, you don't need to use it because its installed but its for the users that need to reproduce.
- Images: `stable-diffusion-v1-5/stable-diffusion-v1-5` via diffusers (the mirror; the `runwayml` repo no longer exists).
- Audio: `facebook/musicgen-small` via transformers, plus Python post-processing (resampling to change the sampling rate, simple EQ filter).
- fp16. Add attention slicing or CPU offload only if VRAM actually runs out.

## Dependencies

- Install only into `LAB1/.venv` (`.venv\Scripts\python -m pip install ...`), never system Python.
- Right after any successful install or upgrade, update `requirements.txt` in the same step: add or change that package with its exact installed version (`pkg==x.y.z`), keeping the existing pins and the `+cu128` torch line untouched.
- Never run a bare `pip freeze > requirements.txt`; it would overwrite the CUDA torch pin and dump transitive packages.
- Say which line you added or changed when you report back.

## Code style

- Jupyter notebooks only: `images.ipynb`, `audio.ipynb`.
- Short and simple: no classes, minimal functions, comments only where they help.

## EXPERIMENTS list

- Each run is one dict in the `EXPERIMENTS` list at the top of the notebook, with every parameter written out: group, prompt, negative prompt, seed, steps, CFG, resolution, scheduler (images); group, prompt, seed, duration, temperature, guidance, sampling rate (audio). No hidden defaults.
- Audio post-processing runs (resample / EQ) are their own entries that reference a source clip's output file.
- Each run seeds itself, so results never depend on run order.
- Changing any parameter makes it a new run.

## Results CSV and re-runs

- `results/images.csv` and `results/audio.csv` are the single source of truth: every parameter, model name and library version, output filename, rating (1-5), notes.
- Plain comma-separated UTF-8. Vlad fills in rating and notes by hand in VS Code; those two columns are his alone.
- A run is already done if the CSV has a row with identical parameters (compared by value) and its output file exists. The loop then does not regenerate: it prints SKIPPED with the row number and filename, shows the existing output, and adds no row.
- A duplicate entry inside `EXPERIMENTS` gets a warning and is skipped.
- A new run prints NEW and appends one row. Append mode only: never rewrite, reorder or delete existing rows, output files or ratings.
- The loop ends with "N new, M skipped".
- Outputs go to `outputs/images/` and `outputs/audio/`. Filenames are descriptive and unique: group, the key parameters, and a short hash of all parameters.

## Working rules

Claude recommends, Vlad decides.

- When asked, suggest which parameter and values to try next, what to keep fixed, and what to look for. Vlad will mostly choose, edit and run, but you are welcome to do so yourself if you need, but not for the results.
- Never change the `EXPERIMENTS` list unasked.
- Never rate or judge outputs (Claude can't reliably assess image or audio quality) and never invent results.
- Fine when asked: explaining parameters, fixing errors, organizing Vlad's ratings into comparisons.
- Experiment rule: change one parameter at a time, everything else at baseline.
