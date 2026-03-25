# Используем легкий образ Python
FROM python:3.9-slim

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем сам Piper
RUN pip install piper-tts

# Копируем скрипт запуска
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Открываем порт для общения с сервером
EXPOSE 8080

# Запускаем скрипт
CMD ["/start.sh"]
