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
