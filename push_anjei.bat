@echo off
set /p BRANCH=Branch name: 

set BRANCH_NAME=anjei-%BRANCH%

git checkout master
git pull origin master

git switch %BRANCH_NAME% 2>nul || git switch -c %BRANCH_NAME%

git add .
git commit -m "Update anjei" 2>nul
git push origin %BRANCH_NAME% -u --force

echo.
echo Pushed to %BRANCH_NAME%
pause