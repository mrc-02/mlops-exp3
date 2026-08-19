# Experiment 3: Git + DVC for ML Version Control

**Aim:** Implement Git for source code version control and DVC for dataset and model versioning, enabling reproducible ML experiments.

---

## Project Structure

```
Mlops_exp3/
├── src/
│   ├── train_v1.py          # Train RF model v1 (n_estimators=10, max_depth=3)
│   ├── train_v2.py          # Train RF model v2 (n_estimators=100, max_depth=None)
│   ├── modify_dataset.py    # Add petal_ratio feature → iris_v2.csv
│   └── compare_versions.py  # Compare dataset & model versions
├── data/                    # Tracked by DVC (gitignored)
│   ├── iris.csv             # Dataset v1
│   ├── iris.csv.dvc         # DVC pointer (committed to Git)
│   ├── iris_v2.csv          # Dataset v2
│   └── iris_v2.csv.dvc
├── models/                  # Tracked by DVC (gitignored)
│   ├── model_v1.pkl
│   ├── model_v1.pkl.dvc
│   ├── model_v2.pkl
│   └── model_v2.pkl.dvc
├── metrics/
│   ├── metrics_v1.json
│   └── metrics_v2.json
├── dvc_remote/              # Local DVC remote storage
├── .dvc/config              # DVC configuration
├── .gitignore
├── requirements.txt
├── setup.bat                # Full automation script
├── restore_version.bat      # Version restoration demo
└── reproduce.bat            # Clone & reproduce demo
```

---

## Task Execution

### Task 1 & 2 — Git Init & Project Structure
```bash
git init
git add .
git commit -m "Initial project structure with src scripts"
# Push to GitHub:
git remote add origin https://github.com/<username>/Mlops_exp3.git
git push -u origin main
```

### Task 3 — Install & Initialize DVC
```bash
pip install dvc
dvc init
git add .dvc/
git commit -m "Initialize DVC"
```

### Task 4 — Download Dataset & Track with DVC
```bash
python src/train_v1.py        # generates data/iris.csv
dvc add data/iris.csv         # creates data/iris.csv.dvc
git add data/iris.csv.dvc data/.gitignore
git commit -m "Add dataset v1 (iris.csv) tracked by DVC"
```

### Task 5 — Configure DVC Remote & Push
```bash
mkdir dvc_remote
dvc remote add -d local_remote dvc_remote
dvc push
```
> For cloud storage, replace with:
> `dvc remote add -d myremote s3://my-bucket/dvc-store`

### Task 6 — Modify Dataset & Create v2
```bash
python src/modify_dataset.py  # adds petal_ratio column → iris_v2.csv
dvc add data/iris_v2.csv
git add data/iris_v2.csv.dvc
git commit -m "Add dataset v2: added petal_ratio feature"
dvc push
```

**Dataset Comparison:**
| Property     | Dataset V1         | Dataset V2                        |
|--------------|--------------------|-----------------------------------|
| File         | iris.csv           | iris_v2.csv                       |
| Shape        | (150, 5)           | (150, 6)                          |
| Columns      | 4 features+target  | 4 features + petal_ratio + target |
| New Feature  | —                  | petal_ratio = petal_len/petal_wid |

### Task 7 — Restore Previous Dataset Version
```bash
git log --oneline
git checkout <commit-hash-of-v1>
dvc checkout          # restores data/iris.csv from DVC cache
# Verify, then return:
git checkout main
dvc checkout
```

### Task 8 & 9 — Train & Track Model v1
```bash
python src/train_v1.py        # trains RF(n_estimators=10, max_depth=3)
dvc add models/model_v1.pkl
git add models/model_v1.pkl.dvc metrics/metrics_v1.json
git commit -m "Add model v1: RF n_estimators=10, max_depth=3"
dvc push
```

### Task 10 — Train & Track Model v2
```bash
python src/train_v2.py        # trains RF(n_estimators=100, max_depth=None)
dvc add models/model_v2.pkl
git add models/model_v2.pkl.dvc metrics/metrics_v2.json
git commit -m "Add model v2: RF n_estimators=100, max_depth=None"
dvc push
```

**Model Comparison:**
| Metric        | Model V1 | Model V2 |
|---------------|----------|----------|
| n_estimators  | 10       | 100      |
| max_depth     | 3        | None     |
| Accuracy      | ~0.9333  | ~0.9667  |

### Task 11 — Restore Previous Model Version
```bash
git checkout <commit-hash-of-model-v1>
dvc checkout          # restores model_v1.pkl
python -c "import joblib; m=joblib.load('models/model_v1.pkl'); print(m)"
git checkout main && dvc checkout
```

### Task 12 — Clone & Reproduce
```bash
git clone https://github.com/<username>/Mlops_exp3.git Mlops_exp3_clone
cd Mlops_exp3_clone
pip install -r requirements.txt
dvc pull              # retrieves all data and models from remote
python src/compare_versions.py   # verify reproducibility
```

---

## Git Commit History

```
* <hash>  Add model v2: RF n_estimators=100, max_depth=None
* <hash>  Add dataset v2: added petal_ratio feature
* <hash>  Add model v1: RF n_estimators=10, max_depth=3
* <hash>  Add dataset v1 (iris.csv) tracked by DVC
* <hash>  Initialize DVC
* <hash>  Initial project structure with src scripts
```

---

## DVC Metadata Files

**data/iris.csv.dvc**
```yaml
outs:
- md5: <hash>
  size: 3716
  path: iris.csv
```

**data/iris_v2.csv.dvc**
```yaml
outs:
- md5: <hash>
  size: 4521
  path: iris_v2.csv
```

**.dvc/config**
```ini
[core]
    remote = local_remote
['remote "local_remote"']
    url = dvc_remote
```

---

## Task 13 — Git vs DVC Comparison

| Aspect              | Git                                      | DVC                                              |
|---------------------|------------------------------------------|--------------------------------------------------|
| Code Versioning     | Full support — tracks every line change  | Not designed for code                            |
| Data Versioning     | Impractical — binary/large files bloat repo | Purpose-built — stores .dvc pointer files in Git |
| Model Versioning    | Impractical for large .pkl/.h5 files     | Efficient — tracks model binaries via content hash |
| Collaboration       | GitHub/GitLab PRs, branches, merges      | Shared remote (S3, GCS, Azure, SSH) for data/models |
| Reproducibility     | Reproduces code state at any commit      | `dvc checkout` restores exact data/model at any commit |
| Storage Backend     | Git objects (local + remote repo)        | Pluggable: local, S3, GCS, Azure Blob, SSH, etc. |
| Workflow            | `git add/commit/push`                    | `dvc add/push` + `git commit` the .dvc file     |
| Key Strength        | Source code history & branching          | Large file versioning without bloating Git repo  |

**Summary:** Git and DVC are complementary. Git tracks code and DVC pointer files; DVC tracks the actual large data/model binaries. Together they provide full reproducibility for ML experiments.

---

## How to Run

```bash
# Full automated setup
setup.bat

# Restore a previous version
restore_version.bat

# Reproduce from clone
reproduce.bat
```
