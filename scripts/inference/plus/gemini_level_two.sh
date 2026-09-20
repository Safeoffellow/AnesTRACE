cd /home/huangziwei/workspace/AnesBench

/home/huangziwei/.conda/envs/anesagent/bin/python \
    scripts/inference/run_level_two.py \
    --language en \
    --api-provider gemini \
    --api-key-env GEMINI_API_KEY \
    --max-workers 4