#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
PYTHON_BIN="${ANESBENCH_EVAL_PYTHON_BIN:-/home/huangziwei/.conda/envs/anesagent/bin/python}"

[[ -x "${PYTHON_BIN}" ]] || { echo "Python does not exist: ${PYTHON_BIN}" >&2; exit 1; }
exec "${PYTHON_BIN}" "${PROJECT_ROOT}/scripts/eval/evaluate_level_two.py" "$@"

