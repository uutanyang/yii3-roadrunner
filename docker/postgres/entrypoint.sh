#!/bin/bash
set -e

# 执行原始的 entrypoint
exec docker-entrypoint.sh "$@"