#!/bin/bash
set -e

# Remove o PID do servidor Rails se ele ainda existir
rm -f /app/tmp/pids/server.pid

# Executa o comando que foi passado para o container
exec "$@"
