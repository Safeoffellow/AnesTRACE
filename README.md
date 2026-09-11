# AnesTRACE

AnesTRACE contains two deliberately separate inference tracks for the AnesBench
intraoperative anesthesia benchmark:

- **Level Two** is the repository-root text-only `B5_complete_plan` runner.
- **Level Three** is the tool-using, multi-turn LangGraph agent under
  [`level_three_agent/`](level_three_agent/README.md).

Level Two supports Chinese and English prompts, strict eight-section response
extraction, resumable JSONL output, and sequential evaluation of local models.
Level Three is currently English-only and evaluates autonomous case-context
acquisition, knowledge-tool use, Episode memory, and sequential decisions.

The runner sends only `patient_information` as case-specific model input. It
does not read or send waveform images, media paths, answers, ground truth,
review metadata, or sample identifiers.

## Repository contents

- `run_inference.py`: Level Two single-model inference and extraction.
- `scripts/run_batch.sh`: Level Two multi-model and bilingual runner.
- `prompts/`: Level Two Chinese and English prompt templates.
- `tests/`: Level Two tests.
- `data/README.md`: Level Two dataset contract.
- `level_three_agent/`: independent Level Three package, CLI, tools, configs,
  schema, documentation, and tests.

Checkpoints, clinical datasets, and generated outputs are deliberately
excluded from version control.

## Which runner should I use?

| | Level Two | Level Three |
| --- | --- | --- |
| CLI | `python run_inference.py` | `anestrace-l3` |
| Input | One B5 patient context | One multi-turn Atomic Episode |
| Runtime | Transformers | LangGraph + OpenAI-compatible model server |
| Tools | None | 6 case-context + 4 knowledge tools |
| Memory | None | Episode-scoped |
| Language | Chinese or English | English only |

For Level Three installation, knowledge-source requirements, data schema, and
commands, read [level_three_agent/README.md](level_three_agent/README.md).

## Level Two installation

Python 3.10 or newer and a CUDA-compatible PyTorch installation are
recommended.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

The tested setup used NVIDIA H100 GPUs, BF16, Transformers 5.x, and
`device_map=auto`.

## Level Two data

Authorized datasets can be placed at:

```text
data/Level_two_B5_v2_zh.jsonl
data/Level_two_B5_v2_en.jsonl
```

Alternatively, pass the JSONL path as the positional `input` argument or set
`ANESTRACE_DATA_DIR`. See [data/README.md](data/README.md) for the required
record fields.

## Level Two single-model inference

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

## Level Two sequential batch inference

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

## Level Two supported model protocols

The runner reads each local `config.json` and supports:

| Model type | Loading path |
| --- | --- |
| `qwen2`, `qwen3` | `AutoTokenizer + AutoModelForCausalLM` |
| `qwen3_5`, `qwen3_5_moe` | `AutoProcessor + AutoModelForImageTextToText`, text only |
| `gpt_oss` | `AutoTokenizer + AutoModelForCausalLM`, eager attention |
| `gemma3_text` | `AutoTokenizer + AutoModelForCausalLM` |

This covers the tested Qwen, DeepSeek-R1-Distill-Qwen, HuatuoGPT, Morpheus,
gpt-oss, MedGemma text, and Fleming-R1 checkpoints.

GPT-OSS MXFP4 inference requires the compatible dependency pair declared in
`requirements.txt` (`transformers>=5.14,<5.15` and
`kernels>=0.15.2,<0.16.0`). The runner rejects missing or incompatible kernels
instead of falling back to BF16 dequantization. The first load may fetch signed
MXFP4 kernel artifacts from Hugging Face, so warm the cache before offline use.

## Level Two output

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

Existing `ok` and `invalid_response` rows are skipped on rerun; only inference
errors are retried unless `--no-retry-errors` is specified. Outputs are
atomically rewritten after every batch in dataset order with only the latest
record for each `qa_id`, so a completed full B5 run contains exactly 500 rows.


## Tests

```bash
python -m py_compile run_inference.py
bash -n scripts/run_batch.sh
python -m unittest discover -s tests -v
```

Run the independent Level Three tests with:

```bash
cd level_three_agent
PYTHONPATH=src python -m pytest
bash -n scripts/start_vllm_qwen35.sh scripts/run_agent.sh
```

## Clinical-data safety

Do not commit patient datasets, generated clinical outputs, credentials, or
local model weights. The included `.gitignore` blocks the standard locations,
but contributors must still review `git status` before every commit.

This software is intended for research evaluation and must not be used as a
substitute for qualified clinical judgment.
