#!/bin/bash
set -e

echo "======================================"
echo "开始下载 Qwen2.5-9B 模型..."
echo "======================================"

# 后台启动 ollama 服务
ollama serve &
SERVER_PID=$!

# 等待服务启动
sleep 5

# 等待 ollama 就绪
echo "等待 Ollama 服务就绪..."
until curl -s http://localhost:11434/api/tags > /dev/null 2>&1; do
    echo "  等待中..."
    sleep 2
done

echo "Ollama 服务已就绪！"

# 拉取 Qwen2.5-9B 模型
echo ""
echo "正在下载 qwen3.5:9b 模型（约 6GB，请耐心等待）..."
ollama pull qwen3.5:27b

# 验证模型是否下载成功
echo ""
echo "验证模型..."
ollama list

# 停止服务
echo ""
echo "停止临时服务..."
kill $SERVER_PID
wait $SERVER_PID 2>/dev/null || true

echo ""
echo "======================================"
echo "模型下载完成！"
echo "======================================"
