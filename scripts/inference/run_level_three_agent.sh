#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
AGENT_ROOT="${PROJECT_ROOT}/AnesTRACE-Agent"
PYTHON_BIN="${ANESBENCH_L3_AGENT_PYTHON_BIN:-/home/huangziwei/.conda/envs/anesagent/bin/python}"
INPUT_FILE="${ANESTRACE_INPUT_FILE:-${PROJECT_ROOT}/level_three/Level_three_v3_en_agent.jsonl}"
CONFIG_FILE="${ANESTRACE_CONFIG_FILE:-${AGENT_ROOT}/configs/level_two_aligned_qwen35_27b.json}"
OUTPUT_DIR="${ANESTRACE_OUTPUT_DIR:-${AGENT_ROOT}/outputs/level-three-qwen35-27b-level-two-aligned}"

[[ -x "${PYTHON_BIN}" ]] || { echo "Python does not exist: ${PYTHON_BIN}" >&2; exit 1; }
[[ -f "${INPUT_FILE}" ]] || { echo "Agent dataset does not exist: ${INPUT_FILE}" >&2; exit 1; }
[[ -f "${CONFIG_FILE}" ]] || { echo "Agent configuration does not exist: ${CONFIG_FILE}" >&2; exit 1; }

if (( $# )) && [[ "$1" == "--help" || "$1" == "-h" ]]; then
  cat <<'EOF'
Usage: scripts/inference/run_level_three_agent.sh [agent run options]

Environment:
  ANESBENCH_L3_AGENT_PYTHON_BIN  Python interpreter.
  ANESTRACE_INPUT_FILE           Level Three Agent JSONL.
  ANESTRACE_CONFIG_FILE          Agent configuration JSON.
  ANESTRACE_OUTPUT_DIR           Output directory.

Examples:
  scripts/inference/run_level_three_agent.sh --limit 1 --workers 1
  scripts/inference/run_level_three_agent.sh --resume
EOF
  exit 0
fi

cd -- "${AGENT_ROOT}"
exec "${PYTHON_BIN}" "${PROJECT_ROOT}/scripts/inference/run_level_three_agent.py" \
  --config "${CONFIG_FILE}" run --input "${INPUT_FILE}" \
  --output-dir "${OUTPUT_DIR}" "$@"
