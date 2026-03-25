#!/bin/bash

# Создаём директорию для голосов
mkdir -p /voices

# Основной голос (VOICE_URL из env)
if [ -n "$VOICE_URL" ]; then
  VOICE_NAME=$(basename "$VOICE_URL" .onnx)
  curl -L -o "/voices/${VOICE_NAME}.onnx" "$VOICE_URL"
  curl -L -o "/voices/${VOICE_NAME}.json" "${VOICE_URL%.onnx}.json"
  echo "Загружен основной голос: $VOICE_NAME"
else
  echo "Укажите VOICE_URL в env vars!"
  exit 1
fi

# Дополнительные голоса (через VOICE_URL_2, VOICE_URL_3 и т.д.)
for i in {2..5}; do
  EXTRA_URL="VOICE_URL_${i}"
  if [ -n "${!EXTRA_URL}" ]; then
    EXTRA_NAME=$(basename "${!EXTRA_URL}" .onnx)
    curl -L -o "/voices/${EXTRA_NAME}.onnx" "${!EXTRA_URL}"
    curl -L -o "/voices/${EXTRA_NAME}.json" "${!EXTRA_URL%.onnx}.json"
    echo "Загружен доп. голос: $EXTRA_NAME"
  fi
done

# Запускаем Piper HTTP сервер на порту 8080
echo "Запуск Piper сервера..."
exec piper --model /voices --server --server-port 8080 --server-address 0.0.0.0
