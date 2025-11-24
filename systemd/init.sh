#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# install uv
# curl -LsSf https://astral.sh/uv/install.sh | sh
# cd "${SCRIPT_DIR}/myapp" && uv sync

sudo ln -svf "${SCRIPT_DIR}/mysvc.service" /etc/systemd/system/
