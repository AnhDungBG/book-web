# Generated by Django 5.1 on 2024-09-13 02:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bookapp', '0010_emailverification_remove_khachhang_otp_attempts'),
    ]

    operations = [
        migrations.AddField(
            model_name='donhang',
            name='active',
            field=models.BooleanField(default=True),
        ),
        migrations.AddField(
            model_name='donhang',
            name='ghichu',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='lichsumua',
            name='ghichu',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='lichsumuon',
            name='ghichu',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='yeucaumua',
            name='ghichu',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='yeucaumuon',
            name='ghichu',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
