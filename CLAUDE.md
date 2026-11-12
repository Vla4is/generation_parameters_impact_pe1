# LAB1: prompt engineering and generation parameters

@.claude/kickstart.md
@.claude/open-questions.md

University lab: how prompt wording and generation parameters change image quality and audio quality. Vlad does the experiments, ratings, analysis and presentation himself.

This file covers the machine and how we work. Project specifics (models, notebooks, parameters, results format) are in `.claude/kickstart.md`.

## Machine

- Local RTX 3060 Ti, 8 GB VRAM. CUDA/PyTorch are already set up; no install help unless asked. No paid APIs.
- Environment: everything lives in `LAB1/.venv` (Python 3.12.10). PyTorch 2.11.0 built for CUDA 12.8 (`+cu128`); driver supports CUDA 13.4. Pinned in `requirements.txt`, you don't need to use it because its installed but its for the users that need to reproduce.

## Dependencies

- Install only into `LAB1/.venv` (`.venv\Scripts\python -m pip install ...`), never system Python.
- Right after any successful install or upgrade, update `requirements.txt` in the same step: add or change that package with its exact installed version (`pkg==x.y.z`), keeping the existing pins and the `+cu128` torch line untouched.
- Never run a bare `pip freeze > requirements.txt`; it would overwrite the CUDA torch pin and dump transitive packages.
- Say which line you added or changed when you report back.

## Code style

- Jupyter notebooks only.
- Short and simple: no classes, minimal functions, comments only where they help.

## Working rules

Claude recommends, Vlad decides.

- When asked, suggest which parameter and values to try next, what to keep fixed, and what to look for. Vlad will mostly choose, edit and run, but you are welcome to do so yourself if you need, but not for the results.
- Never change the `EXPERIMENTS` list unasked.
- Never rate or judge outputs (Claude can't reliably assess image or audio quality) and never invent results.
- Never rewrite, reorder or delete existing results rows, output files or ratings. The rating and notes columns are Vlad's alone.
- Fine when asked: explaining parameters, fixing errors, organizing Vlad's ratings into comparisons.
- Experiment rule: change one parameter at a time, everything else at baseline.
