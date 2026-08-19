@echo off
echo ============================================================
echo  Reproducing project from clone (Task 12)
echo ============================================================

REM Simulate cloning into a new folder
set CLONE_DIR=..\Mlops_exp3_clone

echo [STEP 1] Cloning repository...
git clone . %CLONE_DIR%
cd %CLONE_DIR%

echo.
echo [STEP 2] Installing dependencies...
pip install -r requirements.txt -q

echo.
echo [STEP 3] Pulling data and models from DVC remote...
dvc pull

echo.
echo [STEP 4] Verifying retrieved files...
echo --- Dataset files ---
dir data\
echo --- Model files ---
dir models\

echo.
echo [STEP 5] Re-running comparison to verify reproducibility...
python src/compare_versions.py

echo.
echo Reproducibility verified successfully!
cd ..\Mlops_exp3
