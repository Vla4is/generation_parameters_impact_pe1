"""Shared by images.ipynb and audio.ipynb: run hash, output filename, results log."""
import csv
import hashlib
import json
from pathlib import Path


def run_hash(params):
    """Short code for one EXPERIMENTS entry: same parameters, same code."""
    text = json.dumps(params, sort_keys=True)
    return hashlib.sha1(text.encode("utf-8")).hexdigest()[:8]


def output_path(params, folder, ext):
    """Where this run's output lives, e.g. outputs/images/baseline_a3f9c21b.png"""
    return Path(folder) / f"{params['group']}_{run_hash(params)}.{ext}"


def append_row(csv_path, params, filename):
    """Append one row to the results log; write the header first if the file is new."""
    csv_path = Path(csv_path)
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    row = {**params, "hash": run_hash(params), "filename": filename, "rating": "", "notes": ""}
    is_new = not csv_path.exists()
    with open(csv_path, "a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(row))
        if is_new:
            writer.writeheader()
        writer.writerow(row)
