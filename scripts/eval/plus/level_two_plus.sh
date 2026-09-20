#!/usr/bin/env bash
set -euo pipefail

cd /home/huangziwei/workspace/AnesBench

gold_path="level_two/Level_two_B5_v3_en_evidence.jsonl"

for model_name in \
  Fleming-R1-7B
do
  prediction_path="outputs/level_two/${model_name}/level-two-b5-text-only-en.jsonl"
  output_path="outputs/level_two/${model_name}/level-two-b5-text-only-en.v3.local_judge.jsonl"
  summary_path="outputs/level_two/${model_name}/level-two-b5-text-only-en.v3.judge_summary.json"

  CUDA_VISIBLE_DEVICES=0 \
  /home/huangziwei/.conda/envs/anesagent/bin/python \
    scripts/eval/evaluate_level_two.py \
    --gold "${gold_path}" \
    --predictions "${prediction_path}" \
    --output "${output_path}" \
    --summary-output "${summary_path}" \
    --device-map auto \
    --device cuda:0 \
    --dtype bfloat16 \
    --batch-size 4 \
    --candidate-invalid-policy record_zero \
    --resume
done
