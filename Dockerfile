FROM python:3.9-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip и устанавливаем Piper
RUN python3 -m pip install --upgrade pip
RUN pip install --no-cache-dir piper-tts piper

# Копируем скрипт запуска
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Открываем порт для общения с сервером
EXPOSE 8080

# Запуск сервера
CMD ["/start.sh"]
