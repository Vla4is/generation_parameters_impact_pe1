# Sets up LAB1 from scratch: the .venv, the packages, and all three models (saved into models/).
# Needs Python 3.12, git and an NVIDIA GPU. Run from the LAB1 folder:
#   powershell -ExecutionPolicy Bypass -File install.ps1

if (-not (Test-Path .venv)) { py -3.12 -m venv .venv }

# parler-tts fetches one dependency through git; this lets git use the Windows certificate store
$env:GIT_CONFIG_COUNT = "1"
$env:GIT_CONFIG_KEY_0 = "http.sslBackend"
$env:GIT_CONFIG_VALUE_0 = "schannel"

.venv\Scripts\python -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) { Write-Host "Package install failed."; exit 1 }

# Download with the same calls the notebooks use, so exactly the files they need end up in models/
@'
import torch
from diffusers import StableDiffusionPipeline
from transformers import AutoTokenizer, pipeline
from parler_tts import ParlerTTSForConditionalGeneration

StableDiffusionPipeline.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5", torch_dtype=torch.float16, variant="fp16",
    safety_checker=None, requires_safety_checker=False, cache_dir="models")
AutoTokenizer.from_pretrained("parler-tts/parler-tts-mini-v1", cache_dir="models")
ParlerTTSForConditionalGeneration.from_pretrained("parler-tts/parler-tts-mini-v1", cache_dir="models")
# speech recognition check (recognize_all in helpers.py)
pipeline("automatic-speech-recognition", model="facebook/wav2vec2-large-960h-lv60-self",
         model_kwargs={"cache_dir": "models"})
print("Done: all three models are in models/. CUDA available:", torch.cuda.is_available())
'@ | .venv\Scripts\python -
if ($LASTEXITCODE -ne 0) { Write-Host "Model download failed."; exit 1 }
