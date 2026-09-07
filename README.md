# AnesTRACE

AnesTRACE is a text-only batch inference runner for the Level Two
`B5_complete_plan` intraoperative anesthesia decision task. It supports
Chinese and English prompts, strict eight-section response extraction,
resumable JSONL output, and sequential evaluation of multiple local models.

The runner sends only `patient_information` as case-specific model input. It
does not read or send waveform images, media paths, answers, ground truth,
review metadata, or sample identifiers.

## Repository contents

- `run_inference.py`: single-model inference and response extraction.
- `scripts/run_batch.sh`: sequential multi-model and bilingual runner.
- `prompts/`: canonical Chinese and English prompt templates.
- `tests/`: input, parser, routing, resume, and shell orchestration tests.
- `data/README.md`: expected dataset contract; datasets are not tracked.

Checkpoints, clinical datasets, and generated outputs are deliberately
excluded from version control.

## Installation

Python 3.10 or newer and a CUDA-compatible PyTorch installation are
recommended.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

The tested setup used NVIDIA H100 GPUs, BF16, Transformers 5.x, and
`device_map=auto`.

## Data

Authorized datasets can be placed at:

```text
data/Level_two_B5_v2_zh.jsonl
data/Level_two_B5_v2_en.jsonl
```

Alternatively, pass the JSONL path as the positional `input` argument or set
`ANESTRACE_DATA_DIR`. See [data/README.md](data/README.md) for the required
record fields.

## Single-model inference

Run one Chinese smoke-test item:

```bash
python run_inference.py \
  --model-path /path/to/local/model \
  --language zh \
  --limit 1
```

Run an explicit English dataset:

```bash
python run_inference.py /path/to/Level_two_B5_v2_en.jsonl \
  --model-path /path/to/local/model \
  --language en \
  --output outputs/model-name/b5-text-only-en.jsonl
```

The default generation mode disables thinking and uses deterministic greedy
decoding. Use `--enable-thinking` to enable supported model templates.

## Sequential batch inference

Model paths are intentionally explicit and may be repeated:

```bash
./scripts/run_batch.sh \
  --model-path /path/to/model-a \
  --model-path /path/to/model-b \
  --language both
```

For `--language both`, each model runs English first and Chinese second in
separate Python processes. If one run fails, later runs continue; the script
prints a final failure summary and returns the first failed exit status.
Interrupt and termination signals still stop immediately.

Arguments after `--` are forwarded to `run_inference.py`:

```bash
./scripts/run_batch.sh \
  --model-path /path/to/model \
  --language en \
  -- --split test --limit 10
```

Batch size defaults to `1`. Increase it gradually for each checkpoint until the
GPU memory limit is approached; longer prompts and higher `--max-new-tokens`
require more KV-cache memory. For example:

```bash
./scripts/run_batch.sh --model-path /path/to/model -- --batch-size 4
```

## Supported model protocols

The runner reads each local `config.json` and supports:

| Model type | Loading path |
| --- | --- |
| `qwen2`, `qwen3` | `AutoTokenizer + AutoModelForCausalLM` |
| `qwen3_5`, `qwen3_5_moe` | `AutoProcessor + AutoModelForImageTextToText`, text only |
| `gpt_oss` | `AutoTokenizer + AutoModelForCausalLM`, eager attention |
| `gemma3_text` | `AutoTokenizer + AutoModelForCausalLM` |

This covers the tested Qwen, DeepSeek-R1-Distill-Qwen, HuatuoGPT, Morpheus,
gpt-oss, MedGemma text, and Fleming-R1 checkpoints.

## Output

Default outputs are:

```text
outputs/<model-name>/b5-text-only.jsonl
outputs/<model-name>/b5-text-only-en.jsonl
```

Each successful row contains the raw decoded text, final text after supported
reasoning-channel removal, eight named sections, `prediction.b1` through
`prediction.b4`, token counts, timing, model metadata, format validation,
and truncation status. A neighboring `.config.json` records generation
settings and the prompt SHA-256.

Existing usable rows are skipped on rerun. Invalid responses and errors are
retried unless `--no-retry-errors` is specified.

## Tests

```bash
python -m py_compile run_inference.py
bash -n scripts/run_batch.sh
python -m unittest discover -s tests -v
```

## Clinical-data safety

Do not commit patient datasets, generated clinical outputs, credentials, or
local model weights. The included `.gitignore` blocks the standard locations,
but contributors must still review `git status` before every commit.

This software is intended for research evaluation and must not be used as a
substitute for qualified clinical judgment.
