#!/bin/sh

echo "Waiting for Postgres..."

while ! python -c "import socket; s=socket.socket(); s.connect(('db', 5432)); s.close()" 2>/dev/null; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "Postgres is ready"

echo "Applying migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput || true

echo "Starting Gunicorn..."
exec gunicorn carzone.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120