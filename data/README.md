# Data Availability

**AnesTRACE benchmark data are not released due to license issues.** The public repository and website contain no patient records, clinical trajectories, gold answers, restricted imaging or waveform files, or source-derived benchmark questions. There is no public data-request process at present.

For evaluation of a locally runnable, fixed-version model, the required information is described in [the model submission template](../.github/ISSUE_TEMPLATE/model-submission.yml): a Hugging Face repository or cloud-storage download link and the fixed model revision. Submission links are withheld during anonymous review. The team runs the private test set; applicants do not receive test cases or reference answers. Submissions are public GitHub Issues: do not include passwords, access tokens, restricted files, or clinical data.

Sources used in the study include [VitalDB](https://vitaldb.net/dataset/), [MOVER](https://mover.ics.uci.edu/download.html), [INSPIRE](https://physionet.org/content/inspire/), and [EchoNet-TEE](https://github.com/echonet/tee-view-classifier). Each has its own access and reuse terms. The AnesTRACE code license grants no rights to these datasets and does not authorize redistribution.

For authorized internal testing, pass an explicit JSONL path or place private files under `data/private/`. This directory is Git-ignored. Files in `examples/synthetic/` are artificial interface checks, not benchmark data.
