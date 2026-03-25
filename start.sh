#!/bin/bash
set -e

MODELS_DIR="/models"
mkdir -p "$MODELS_DIR"

# По умолчанию: один голос для начала
PRIMARY="en_US-lessac-medium"

# Дополнительные голоса для загрузки на старте
# Формат: VOICES="NAME1|URL1 NAME2|URL2"
# Замените URL на реальные файлы голоса Piper releases
VOICES="en_US-voice1|https://example.com/en_US-voice1.onnx en_US-voice2|https://example.com/en_US-voice2.onnx"

# Функция загрузки файла, если он ещё не скачан
download_if_missing() {
  local url="$1"
  local out="$2"
  if [ ! -f "$out" ]; then
    echo "Downloading $out from $url..."
    wget -q -O "$out" "$url"
  else
    echo "$out already exists, skipping download."
  fi
}

# Загружаем голос по умолчанию, если он ещё не дан
if [ ! -f "$MODELS_DIR/${PRIMARY}.onnx" ]; then
  download_if_missing "https://github.com/rhasspy/piper/releases/download/v0.0.2/${PRIMARY}.onnx" "$MODELS_DIR/${PRIMARY}.onnx"
  # json рядом с ней иногда требуется для описания
  download_if_missing "https://github.com/rhasspy/piper/releases/download/v0.0.2/${PRIMARY}.onnx.json" "$MODELS_DIR/${PRIMARY}.onnx.json" || true
fi

# Загружаем дополнительные голоса, указаные в VOICES
if [ -n "$VOICES" ]; then
  for spec in $VOICES; do
    NAME=$(echo "$spec" | cut -d'|' -f1)
    URL=$(echo "$spec" | cut -d'|' -f2-)
    if [ -z "$NAME" ] || [ -z "$URL" ]; then
      continue
    fi
    download_if_missing "$URL" "$MODELS_DIR/${NAME}.onnx"
    # Попытаться скачать json-описание, если доступно
    JSON_URL="${URL}.json"
    download_if_missing "$JSON_URL" "$MODELS_DIR/${NAME}.onnx.json" || true
  done
fi

# Запуск сервера Piper. По умолчанию используем первый голос
echo "Launching Piper TTS with voice: $PRIMARY"
python3 -m piper.server --model "$MODELS_DIR/${PRIMARY}.onnx" --port 8080 --host 0.0.0.0
