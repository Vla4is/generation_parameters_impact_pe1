# Open questions before implementation

Do not start building the notebooks while any question below is open. When Vlad decides one, write the decision into `kickstart.md` and delete the question here. When the list is empty, delete this file and its `@` line in `CLAUDE.md`.

## 1. How the loop decides a run is already done

`kickstart.md` currently says: a run is done if the CSV has a row with identical parameters (compared by value) and its output file exists. Comparing by value is fragile, because the CSV stores text (`7.5` against `"7.5"`), and the rule does not say what happens when the row exists but the file was deleted.

Proposal (Claude recommends):

- Each entry gets a short hash of all its parameters. The hash is part of the output filename, so the filename identifies the run.
- Two independent checks per entry: does the output file exist, and is the filename in the CSV.
- File missing: generate and save. Row missing: append one row.

| File | Row | What happens | Printed |
|---|---|---|---|
| missing | missing | generate, add a row | NEW |
| exists | exists | nothing | SKIPPED |
| missing | exists | generate again to the same filename, no new row | REGENERATED |
| exists | missing | add the row, no generation | ROW ADDED |

Catch: the hash depends on exactly what is typed, so `30` and `30.0` count as different runs.

Already decided by Vlad: a deleted file is re-run, and the logic must stay simple.

## 2. Stable Diffusion safety checker

- Off (`safety_checker=None`): one argument; no black image on a false positive. Claude recommends this.
- On: the library default; loads an extra model.

Either way the weights download once into `models/` and are reused on every later run.

## 3. What happens to `kickstart.md` after the build

Its Cleanup section says to delete the whole file once both notebooks work, but the file now holds the model choices, parameters and CSV rules.

- Keep the file and delete only its "Build task" and "Cleanup" sections. Claude recommends this.
- Delete the whole file and let the notebooks be the only record.

## 4. Two small defaults to confirm

- Audio clips are saved as WAV at MusicGen's native 32000 Hz.
- Sampling rate is not a column in `results/audio.csv`.
