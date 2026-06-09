@echo off
set /p BRANCH=Branch name: 

set BRANCH_NAME=anjei-%BRANCH%

git checkout master
git pull origin master
git checkout -b %BRANCH_NAME%
git push origin %BRANCH_NAME% -u --force

echo.
echo Pushed to %BRANCH_NAME%
pause