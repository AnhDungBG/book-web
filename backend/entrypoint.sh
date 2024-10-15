#!/bin/sh
python manage.py migrate
# Collect static files
python manage.py collectstatic --no-input --clear
python -m celery -A BookWebsite worker -l info --without-gossip --without-mingle --without-heartbeat -Ofair --pool=solo --scheduler django_celery_beat.schedulers:DatabaseScheduler &
python -m celery -A BookWebsite beat -l INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler &
exec "$@"