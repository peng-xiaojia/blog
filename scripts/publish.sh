#!/usr/bin/env bash
# ============================================
# Hugo 博客 - 一键发布脚本 (macOS / Linux)
# ============================================
# 用法:
#   chmod +x scripts/publish.sh
#   ./scripts/publish.sh "新文章的提交信息"
# ============================================
set -euo pipefail

COMMIT_MSG="${1:-post: 更新博客文章}"

echo "========================================"
echo " Hugo 博客 - 一键发布"
echo "========================================"

# --- 1. 拉取最新远程更新 ---
echo "[1/4] 拉取远程更新..."
git pull --rebase origin master 2>/dev/null || echo "[INFO] 远程无更新或无远程仓库"

# --- 2. 构建站点 ---
echo "[2/4] 构建站点..."
hugo --minify
echo "[OK] 构建完成 -> public/"

# --- 3. 提交并推送 ---
echo "[3/4] 提交变更..."
git add -A

if git diff --cached --quiet; then
  echo "[INFO] 没有需要提交的变更"
else
  git commit -m "$COMMIT_MSG"
  echo "[OK] 已提交: $COMMIT_MSG"
fi

echo "[4/4] 推送到远程..."
git push origin master

echo ""
echo "========================================"
echo " ✅ 发布完成！"
echo "========================================"
echo ""
echo "GitHub Actions 将自动部署到:"
echo "  https://peng-xiaojia.github.io/my-blog/"
