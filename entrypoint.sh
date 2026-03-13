#!/bin/bash
set -e

# 设置模型存储路径（确保使用镜像内预下载的模型）
export OLLAMA_MODELS=/root/.ollama/models

# 检查模型是否存在
if [ ! -d "/root/.ollama/models" ]; then
    echo "错误：模型目录不存在！"
    exit 1
fi

echo "======================================"
echo "Ollama CPU 离线服务启动中..."
echo "模型: qwen2.5:9b"
echo "监听地址: 0.0.0.0:11434"
echo "======================================"

# 显示已安装的模型
echo "已预装的模型列表："
ollama list || true

echo ""
echo "启动 Ollama 服务..."
echo "提示：首次加载模型到内存可能需要 1-3 分钟（取决于 CPU 性能）"
echo ""

# 启动 Ollama 服务（前台运行，保持容器活跃）
exec ollama serve
