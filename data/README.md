# Dataset placement

Clinical datasets are intentionally not included in this repository.

The default filenames are:

- `Level_two_B5_v2_zh.jsonl`
- `Level_two_B5_v2_en.jsonl`

Place authorized copies in this directory, set `ANESTRACE_DATA_DIR`, or pass
an explicit JSONL path to `run_inference.py`.

Each record must contain non-empty `qa_id`, `sample_id`, and
`patient_information` fields, with:

- `task_name`: `B5_complete_plan`
- `answer_type`: `open_ended`
- `split`: `train`, `validation`, or `test`

Other fields may be present, but the model receives only
`patient_information`. Dataset files are ignored by Git to reduce the risk
of committing protected clinical content.
