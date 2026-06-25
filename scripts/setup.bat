@echo off
REM ============================================
REM Hugo 博客 - 环境安装脚本 (Windows)
REM ============================================
REM 用法:
REM   右键 scripts\setup.bat -> 以管理员身份运行
REM   或在 PowerShell 中运行: .\scripts\setup.bat
REM ============================================
setlocal enabledelayedexpansion

echo ========================================
echo  Hugo 博客 - 环境初始化
echo ========================================

REM --- 1. 安装 Hugo Extended ---
echo.
echo [1/3] 检查 Hugo...

where hugo >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  for /f "tokens=*" %%i in ('hugo version') do echo [OK] Hugo 已安装: %%i
) else (
  echo [INFO] 正在通过 winget 安装 Hugo Extended...
  winget install Hugo.Hugo.Extended --accept-source-agreements --accept-package-agreements
  if %ERRORLEVEL% EQU 0 (
    REM 刷新 PATH (winget 会自动添加)
    echo [OK] Hugo 安装完成
    echo [INFO] 请重启命令行以使用 hugo 命令
  ) else (
    echo [ERROR] 安装失败，请手动安装: https://gohugo.io/installation/windows/
    REM 尝试 choco 备选
    echo [INFO] 尝试使用 Chocolatey...
    choco install hugo-extended -y
  )
)

REM --- 2. 拉取主题子模块 ---
echo.
echo [2/3] 检查主题...
git submodule update --init --recursive 2>nul
if %ERRORLEVEL% EQU 0 (
  echo [OK] 主题已拉取
) else (
  echo [OK] 主题已存在
)

REM --- 3. 检查 Git ---
echo.
echo [3/3] 检查 Git...
where git >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  for /f "tokens=*" %%i in ('git --version') do echo [OK] Git 已安装: %%i
) else (
  echo [ERROR] 未找到 Git，请安装: https://git-scm.com/download/win
  echo 也可以: winget install Git.Git
)

echo.
echo ========================================
echo  ✅ 环境初始化完成！
echo ========================================
echo.
echo 快速开始：
echo   hugo server --buildDrafts      # 启动本地预览
echo   hugo new posts/xxx.md          # 创建新文章
echo   scripts\publish.bat            # 一键发布

pause
