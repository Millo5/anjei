@echo off

for /f "delims=" %%b in ('git rev-parse --abrev-ref HEAD') do set CURRENT_BRANCH=%%b

git fetch origin
git rebase origin/master

echo.
echo Pulled latest changes to %CURRENT_BRANCH%
pause