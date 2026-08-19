@echo off
echo ============================================================
echo  Restoring previous dataset and model versions
echo ============================================================

REM Show all commits
echo.
echo [INFO] Full commit history:
git log --oneline

REM Save current HEAD hash
for /f "tokens=1" %%i in ('git rev-parse HEAD') do set CURRENT=%%i
echo Current HEAD: %CURRENT%

REM Restore to the commit that has model v1 (2nd commit from top)
echo.
echo [RESTORE] Checking out model v1 commit...
for /f "tokens=1" %%i in ('git log --oneline ^| findstr "model v1"') do set V1_HASH=%%i
echo Restoring commit: %V1_HASH%

git checkout %V1_HASH%
dvc checkout

echo.
echo [VERIFY] Files after restore:
dir models\
dir data\

echo.
echo [RESTORE] Returning to latest commit...
git checkout main
dvc checkout

echo.
echo Done. Previous version restored and verified.
