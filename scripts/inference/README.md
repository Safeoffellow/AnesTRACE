# AnesBench inference entrypoints

This directory is the canonical home for runnable inference entrypoints. The legacy repository-root Python files and `scripts/run_*.sh` commands are compatibility wrappers only.

## Workflows

- Level One TEE: `./scripts/inference/run_level_one_tee.sh`
- Level One Waveform: `./scripts/inference/run_level_one_waveform.sh`
- Level Two text-only: `./scripts/inference/run_level_two.sh`
- Level Two paired-image MLLM: `./scripts/inference/run_level_two_mllm.sh`
- Level Three history ablation: `./scripts/inference/run_level_three_ablation.sh`
- Level Three Agent server: `./scripts/inference/start_level_three_agent_server.sh`
- Level Three Agent benchmark: `./scripts/inference/run_level_three_agent.sh`

Each shell resolves the repository root independently of the current working directory. Use `--help` for workflow-specific options and `--` where documented to forward Python arguments.

## Python entrypoints

- `run_level_one.py` handles the Level One TEE and Waveform tasks.
- `run_level_two.py` handles bilingual text-only B5 inference.
- `run_level_two_mllm.py` handles English B5 inference with trend and waveform images.
- `run_level_three_ablation.py` handles current-only and longitudinal ablations.
- `run_level_three_agent.py` launches the installable implementation under `AnesTRACE-Agent`.

Datasets, prompts, checkpoints, and output schemas are unchanged by this reorganization.
