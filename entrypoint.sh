#!/bin/sh

for file in /iptv-api-config/*; do
  filename=$(basename "$file")
  target_file="$APP_WORKDIR/config/$filename"
  cp -r "$file" "$target_file"
done

. /.venv/bin/activate

nginx -g 'daemon off;' &

python $APP_WORKDIR/main.py &

python -m gunicorn service.app:app -b 0.0.0.0:$APP_PORT --timeout=1000
