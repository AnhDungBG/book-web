"""
Django settings for BookWebsite project.

Generated by 'django-admin startproject' using Django 5.1.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.1/ref/settings/
"""

from pathlib import Path
import os
from .celery import app
from celery.schedules import crontab
# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
# SECRET_KEY = 'django-insecure-s&usw+6ubgt7+=cf_&jn#)j_+b9lx5@$18hi&+sijno%fv%y#p'
SECRET_KEY = os.getenv('SECRET_KEY', 'django-insecure-s&usw+6ubgt7+=cf_&jn#)j_+b9lx5@$18hi&+s')

# SECURITY WARNING: don't run with debug turned on in production!
# DEBUG = os.getenv('DEBUG', False)
DEBUG = os.getenv('DEBUG', True)

# ALLOWED_HOSTS = [os.getenv('ALLOWED_HOSTS', True)]
# ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', '127.0.0.1').split(',')
# ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
ALLOWED_HOSTS = ['*']
CORS_ALLOW_ALL_ORIGINS = True

# Application definition

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'  # Sử dụng dịch vụ SMTP của Google
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'trungquansieudeptrai@gmail.com'  # Địa chỉ email của bạn
EMAIL_HOST_PASSWORD = 'pxgk yviv dxjp deso'  # Mật khẩu ứng dụng email
DEFAULT_FROM_EMAIL = 'trungquansieudeptrai@gmail.com'

INSTALLED_APPS = [
    'django_celery_beat',
    'jazzmin',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'corsheaders',
    'rest_framework',
    'drf_yasg',
    'ckeditor',
    'ckeditor_uploader',
    'oauth2_provider',
    'notifications.apps.NotificationsConfig',
    'bookapp.apps.BookappConfig',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'oauth2_provider.middleware.OAuth2TokenMiddleware',
]

REST_FRAMEWORK = {'DEFAULT_PAGINATION_CLASS':
                 'rest_framework.pagination.PageNumberPagination',
                  'PAGE_SIZE': 10,
                  'DEFAULT_AUTHENTICATION_CLASSES':[
                      'oauth2_provider.contrib.rest_framework.OAuth2Authentication'
                  ]
                  }

AUTHENTICATION_BACKENDS = (
    'oauth2_provider.backends.OAuth2Backend',
    'django.contrib.auth.backends.ModelBackend',
)

ROOT_URLCONF = 'BookWebsite.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates']
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'BookWebsite.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases
# if DEBUG:
#     ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
#     DATABASES = {
#         'default': {
#             'ENGINE': 'django.db.backends.mysql',
#             'NAME': 'bookwebsitedb',
#             'USER': 'root',
#             'PASSWORD': '123456',
#             'HOST': 'localhost',
#             'PORT': '3306',
#         }
#     }
# else:
#     DATABASES = {
#         'default': {
#             'ENGINE': 'django.db.backends.mysql',
#             'NAME': os.getenv('DATABASE_NAME', 'bookwebsitedb'),
#             'USER': os.getenv('DATABASE_USER', 'root'),
#             'PASSWORD': os.getenv('DATABASE_PASSWORD', '123456'),
#             'HOST': os.getenv('DATABASE_HOST', 'db'),
#             'PORT': os.getenv('DATABASE_PORT', '3306'),
#         }
#     }
if DEBUG:
    ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        }
    }

AUTH_USER_MODEL = 'bookapp.KhachHang'

#Cấu hình Celery
REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
REDIS_PORT = os.getenv('REDIS_PORT', '6379')
CELERY_BROKER_URL = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"
CELERY_RESULT_BACKEND = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"

# # task chạy định kỳ xoá khuyến mại hết hạn
# CELERY_BEAT_SCHEDULE = {
#     'xoa-khuyenmai-hethan-hang-ngay': {
#         'task': 'bookapp.tasks.xoa_khuyenmai_hethan',
#         'schedule': crontab(minute='*/1'),  # Chạy mỗi 5 phút
#     },
#     'xoa-token-hethan-hang-ngay': {
#         'task': 'bookapp.tasks.xoa_token_hethan',
#         'schedule': crontab(minute='*/5'),  # Chạy mỗi 5 phút
#     },
#         'gui-thong-bao-tra-sach-hang-ngay': {
#             'task': 'bookapp.tasks.gui_thong_bao_tra_sach',
#             'schedule': crontab(hour=3, minute=0),  # Chạy lúc 8 giờ sáng mỗi ngày
#         },
#         'gui-thong-bao-qua-han-tra-sach-hang-ngay': {
#         'task': 'bookapp.tasks.gui_thong_bao_qua_han_tra_sach',
#         'schedule': crontab(hour=3, minute=0),  # Chạy lúc 9 giờ sáng mỗi ngày
#     },
#
# }


OAUTH2_PROVIDER = {
    'ACCESS_TOKEN_EXPIRE_SECONDS': 86400,  #3600 1 giờ - Thời gian sống của Access Token
    'REFRESH_TOKEN_EXPIRE_SECONDS': 86400,  #86400 1 ngày -Thời gian sống của Refresh Token
}

# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

# JAZZMIN_SETTINGS = {
#     "site_title": "Quản lý sách",
#     "site_header": "Book Admin",
#     "welcome_sign": "Chào mừng bạn đến với hệ thống quản lý sách",
#     "show_sidebar": True,  # Hiển thị thanh sidebar
#     "navigation_expanded": True,  # Menu mặc định sẽ được mở rộng
#     # Các tùy chỉnh khác
# }


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.1/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT =os.path.join(BASE_DIR, "staticfiles")
STATICFILES_DIRS = [
]
# print(STATIC_ROOT)
STATICFILES_FINDERS = [
    "django.contrib.staticfiles.finders.FileSystemFinder",
    "django.contrib.staticfiles.finders.AppDirectoriesFinder",
]

# Media files (User uploaded images)
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
CKEDITOR_UPLOAD_PATH = 'uploads/'


# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'