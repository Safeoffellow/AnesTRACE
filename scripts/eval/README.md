# AnesBench evaluation entrypoints

This directory contains the canonical evaluators for benchmark predictions. Evaluator training and data-construction utilities remain under `scripts/eval_training_process`.

## Workflows

- Level One: `./scripts/eval/evaluate_level_one.sh`
- Level Two: `./scripts/eval/evaluate_level_two.sh`
- Level Three: `./scripts/eval/evaluate_level_three.sh`

Level One uses deterministic structured and ClinicalFact metrics for TEE and Waveform predictions. Level Two uses the local AnesTRACE-Eval judge for B1-B4. Level Three evaluates turn-level and trajectory-level answers and reports direct Agent metrics.

Level Three defaults to both Judge scopes. To run only turn-level evaluation:

```bash
./scripts/eval/evaluate_level_three.sh \
  --predictions /path/to/predictions.jsonl \
  --evaluation-level turn \
  --batch-size 8 \
  --disable-thinking
```

The legacy `eval/evaluate_jsonl.py`, Level Two/Three local evaluator paths, and existing evaluation shell commands remain compatibility wrappers.
## Local evaluation assets

L2/L3 evaluation defaults read gold answers and judge prompts from the local
`evaluation_data/` directory at the repository root. This directory is ignored
by Git because it contains benchmark answers and the large SFT prompt template.
Provision the following files locally before running the evaluators:

- `evaluation_data/gold/Level_two_B5_v2_en_evidence.jsonl`
- `evaluation_data/gold/Level_two_B5_v2_en_evidence_refined.jsonl`
- `evaluation_data/gold/Level_two_B5_v3_en_evidence.jsonl`
- `evaluation_data/gold/Level_three_v3_en_agent.jsonl`
- `evaluation_data/prompts/anestrace_eval_overall_system_en.txt`
- `evaluation_data/prompts/anestrace_eval_turn_system_en.txt`
- `evaluation_data/prompts/anestrace_eval_trajectory_system_en.txt`
- `evaluation_data/prompts/AnesTRACE-Eval-Data.jsonl`

Use `--gold`, `--template`, or the system-prompt options to override these
local defaults when evaluating another approved data release.
