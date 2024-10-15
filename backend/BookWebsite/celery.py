import os
from celery import Celery
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'BookWebsite.settings')

app = Celery('BookWebsite', include=['bookapp.tasks'])
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()

