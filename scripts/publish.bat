@echo off
REM ============================================
REM Hugo 博客 - 一键发布脚本 (Windows)
REM ============================================
REM 用法:
REM   scripts\publish.bat
REM   scripts\publish.bat "自定义提交信息"
REM ============================================
setlocal enabledelayedexpansion

if "%~1"=="" (
  set "COMMIT_MSG=post: 更新博客文章"
) else (
  set "COMMIT_MSG=%~1"
)

echo ========================================
echo  Hugo 博客 - 一键发布
echo ========================================

REM --- 1. 拉取远程更新 ---
echo [1/4] 拉取远程更新...
git pull --rebase origin master 2>nul || echo [INFO] 远程无更新

REM --- 2. 构建站点 ---
echo [2/4] 构建站点...
hugo --minify
if %ERRORLEVEL% NEQ 0 (
  echo [ERROR] 构建失败，请检查错误信息
  pause
  exit /b 1
)
echo [OK] 构建完成 -^> public\

REM --- 3. 提交变更 ---
echo [3/4] 提交变更...
git add -A

git diff --cached --quiet 2>nul
if %ERRORLEVEL% EQU 0 (
  echo [INFO] 没有需要提交的变更
) else (
  git commit -m "%COMMIT_MSG%"
  echo [OK] 已提交: %COMMIT_MSG%
)

REM --- 4. 推送到远程 ---
echo [4/4] 推送到远程...
git push origin master
if %ERRORLEVEL% NEQ 0 (
  echo [ERROR] 推送失败，请检查网络或权限
  pause
  exit /b 1
)

echo.
echo ========================================
echo  ✅ 发布完成！
echo ========================================
echo.
echo GitHub Actions 将自动部署到:
echo   https://peng-xiaojia.github.io/my-blog/

pause
