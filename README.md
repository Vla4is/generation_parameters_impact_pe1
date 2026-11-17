# LAB1: Prompt engineering and generation parameters

We tested how prompt wording and generation parameters change the output of local models, changing one parameter at a time from a baseline. Runs are listed in the notebooks, and the results are in `results/`.

- **Stable Diffusion 1.5 (images):** simple scenes came out well, but it kept missing objects in multi-object prompts and mostly ignored negative prompts.
- **Parler-TTS Mini v1 (speech):** it follows only the voice attributes it was trained on, and works best at temperature 0.9–1.0 with top_k 50.
- **Wav2Vec2 (evaluation):** transcribes each speech clip so it can be checked against the requested text.
- **MusicGen Small (music):** dropped because it can't produce vocals and music quality was too subjective to judge.

## Installation (Windows)

1. Install an NVIDIA driver (CUDA 12.8+), [Python 3.12](https://www.python.org/downloads/) and [Git](https://git-scm.com/download/win).
2. Clone the repo and run the installer, which sets up `.venv`, the packages and the models:
   ```powershell
   git clone https://github.com/Vla4is/generation_parameters_impact_pe1.git
   cd generation_parameters_impact_pe1
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```
3. Open `images.ipynb` or `speech.ipynb`, select the `.venv` kernel and run all cells.
