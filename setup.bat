@echo off
echo ============================================================
echo  MLOps Experiment 3: Git + DVC Version Control
echo ============================================================

REM ── Step 1: Install dependencies ──────────────────────────────
echo.
echo [STEP 1] Installing dependencies...
pip install -r requirements.txt -q

REM ── Step 2: Git init ──────────────────────────────────────────
echo.
echo [STEP 2] Initializing Git repository...
git init
git config user.email "student@mlops.com"
git config user.name "MLOps Student"

REM ── Step 3: DVC init ──────────────────────────────────────────
echo.
echo [STEP 3] Initializing DVC...
dvc init

REM ── Step 4: Configure local DVC remote ───────────────────────
echo.
echo [STEP 4] Configuring DVC remote storage...
if not exist "dvc_remote" mkdir dvc_remote
dvc remote add -d local_remote dvc_remote
dvc remote list

REM ── Step 5: Initial commit ────────────────────────────────────
echo.
echo [STEP 5] Initial Git commit (project structure)...
git add .gitignore requirements.txt src/ .dvc/config
git commit -m "Initial project structure with src scripts"

REM ── Step 6: Generate dataset v1 and track with DVC ───────────
echo.
echo [STEP 6] Generating dataset v1 and tracking with DVC...
python src/train_v1.py
dvc add data/iris.csv
git add data/iris.csv.dvc data/.gitignore
git commit -m "Add dataset v1 (iris.csv) tracked by DVC"
dvc push

REM ── Step 7: Train model v1 and track ─────────────────────────
echo.
echo [STEP 7] Tracking model v1 with DVC...
dvc add models/model_v1.pkl
git add models/model_v1.pkl.dvc models/.gitignore metrics/metrics_v1.json
git commit -m "Add model v1: RF n_estimators=10, max_depth=3"
dvc push

REM ── Step 8: Create dataset v2 ────────────────────────────────
echo.
echo [STEP 8] Creating dataset v2 (with petal_ratio feature)...
python src/modify_dataset.py
dvc add data/iris_v2.csv
git add data/iris_v2.csv.dvc
git commit -m "Add dataset v2: added petal_ratio feature"
dvc push

REM ── Step 9: Train model v2 and track ─────────────────────────
echo.
echo [STEP 9] Training model v2 and tracking with DVC...
python src/train_v2.py
dvc add models/model_v2.pkl
git add models/model_v2.pkl.dvc metrics/metrics_v2.json
git commit -m "Add model v2: RF n_estimators=100, max_depth=None"
dvc push

REM ── Step 10: Compare versions ─────────────────────────────────
echo.
echo [STEP 10] Comparing dataset and model versions...
python src/compare_versions.py

REM ── Step 11: Show Git log ─────────────────────────────────────
echo.
echo [STEP 11] Git commit history:
git log --oneline

echo.
echo ============================================================
echo  Setup complete! See reports/experiment_report.md
echo ============================================================
