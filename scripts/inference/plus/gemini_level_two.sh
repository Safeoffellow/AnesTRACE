set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../../.." && pwd)"
PYTHON_BIN="${ANESBENCH_PYTHON_BIN:-/home/huangziwei/.conda/envs/anesagent/bin/python}"
cd "${PROJECT_ROOT}"

"${PYTHON_BIN}" \
    scripts/inference/run_level_two.py \
    --language en \
    --api-provider gemini \
    --api-key-env GEMINI_API_KEY \
    --max-workers 4