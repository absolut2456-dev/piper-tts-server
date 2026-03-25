#!/bin/bash

# Создаем папку для моделей
mkdir -p /models

# Скачиваем голос (en_US-lessac-medium - качественный средний голос)
if [ ! -f /models/en_US-lessac-medium.onnx ]; then
    echo "Downloading voice model..."
    wget -O /models/en_US-lessac-medium.onnx https://github.com/rhasspy/piper/releases/download/v0.0.2/en_US-lessac-medium.onnx
    wget -O /models/en_US-lessac-medium.onnx.json https://github.com/rhasspy/piper/releases/download/v0.0.2/en_US-lessac-medium.onnx.json
fi

# Запускаем сервер
# --host 0.0.0.0 делает его доступным извне
# --port 8080 соответствует порту Railway
python3 -m piper.server --model /models/en_US-lessac-medium.onnx --port 8080 --host 0.0.0.0
