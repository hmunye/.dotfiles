#!/usr/bin/env bash

set -euo pipefail
# set -x

MOE=false
SERVER_ONLY=false

usage() {
    echo "usage: $(basename "$0") [options]"
    echo
    echo "options:"
    echo "  --moe           enables flags tuned for MOE models"
    echo "  --server-only   runs llama-server without open-webui"
    echo "  -h, --help      prints help summary"
}

for arg in "$@"; do
    case "$arg" in
        --moe)
            MOE=true
            ;;
        --server-only)
            SERVER_ONLY=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown option '$arg'" >&2
            usage
            exit 1
            ;;
    esac
done

if [ "$MOE" = true ]; then
    LLAMA_CMD=(
        llama-server --port 8082
        -t 16
        -c 0
        -b 4096
        -ub 1024
        -fa on
        -ctk q8_0
        -ctv q8_0
        -ncmoe 28
        -ngl 999
        --offline
        --repeat-penalty 1.0
        --presence-penalty 1.5
        -np 1
        --reasoning_budget 1024
        --no-mmproj
        --no-ui
        --chat-template-kwargs '{"preserve_thinking": true}'
        --spec-type draft-mtp
        --spec-draft-n-max 2
    )
else
    LLAMA_CMD=(
        llama-server --port 8082
        -t 16
        -c 0
        -b 2048
        -ub 512
        -fa on
        -ctk q8_0
        -ctv q8_0
        -ngl 57
        --offline
        --repeat-penalty 1.0
        --presence-penalty 1.5
        -np 1
        --reasoning_budget 1024
        --no-mmproj
        --no-ui
        --chat-template-kwargs '{"preserve_thinking": true}'
    )
fi

if [ "$SERVER_ONLY" = true ]; then
    xdg-open http://localhost:8082 && "${LLAMA_CMD[@]}" --ui
    exit 0
fi

trap "docker stop open-webui searxng comfyui >/dev/null || true" EXIT SIGINT SIGTERM

if docker ps -a --format '{{.Names}}' | grep -q '^open-webui$'; then
    docker start open-webui >/dev/null
else
    mkdir -p "$HOME/.volumes/open-webui"

    docker run -d \
        --network=host \
        -v "$HOME/.volumes/open-webui:/app/backend/data" \
        --name open-webui \
        --restart unless-stopped \
        ghcr.io/open-webui/open-webui:main \
        >/dev/null
fi

if docker ps -a --format '{{.Names}}' | grep -q '^searxng$'; then
    docker start searxng >/dev/null
else
    mkdir -p "$HOME/.volumes/searxng"

    docker run -d \
        -p 127.0.0.1:8081:8080 \
        -v "$HOME/.volumes/searxng:/etc/searxng:rw" \
        --name searxng \
        --restart unless-stopped \
        searxng/searxng:latest \
        >/dev/null
fi

if docker ps -a --format '{{.Names}}' | grep -q '^comfyui$'; then
    docker start comfyui >/dev/null
else
    mkdir -p \
        "$HOME/.volumes/comfyui/cache/dot-cache" \
        "$HOME/.volumes/comfyui/cache/dot-config" \
        "$HOME/.volumes/comfyui/nodes/dot-local" \
        "$HOME/.volumes/comfyui/nodes/custom_nodes" \
        "$HOME/.volumes/comfyui/models/models" \
        "$HOME/.volumes/comfyui/models/hf-hub" \
        "$HOME/.volumes/comfyui/models/torch-hub" \
        "$HOME/.volumes/comfyui/user/input" \
        "$HOME/.volumes/comfyui/user/output" \
        "$HOME/.volumes/comfyui/user/user-profile" \
        "$HOME/.volumes/comfyui/user/user-scripts"

    docker run -d \
        -p 127.0.0.1:8188:8188 \
        -v "$HOME/.volumes/comfyui/cache/dot-cache:/root/.cache" \
        -v "$HOME/.volumes/comfyui/cache/dot-config:/root/.config" \
        -v "$HOME/.volumes/comfyui/nodes/dot-local:/root/.local" \
        -v "$HOME/.volumes/comfyui/nodes/custom_nodes:/root/ComfyUI/custom_nodes" \
        -v "$HOME/.volumes/comfyui/models/models:/root/ComfyUI/models" \
        -v "$HOME/.volumes/comfyui/models/hf-hub:/root/.cache/huggingface/hub" \
        -v "$HOME/.volumes/comfyui/models/torch-hub:/root/.cache/torch/hub" \
        -v "$HOME/.volumes/comfyui/user/input:/root/ComfyUI/input" \
        -v "$HOME/.volumes/comfyui/user/output:/root/ComfyUI/output" \
        -v "$HOME/.volumes/comfyui/user/user-profile:/root/ComfyUI/user" \
        -v "$HOME/.volumes/comfyui/user/user-scripts:/root/user-scripts" \
        --gpus all \
        --name comfyui \
        --restart unless-stopped \
        yanwk/comfyui-boot:cu130-slim-v2 \
        >/dev/null
fi

while ! nc -z -w 1 localhost 8080 >/dev/null 2>&1; do
    sleep 0.5
done

if command -v xdg-open >/dev/null; then
    xdg-open http://localhost:8080
else
    echo -e "\n-> http://localhost:8080\n"
fi

"${LLAMA_CMD[@]}"
