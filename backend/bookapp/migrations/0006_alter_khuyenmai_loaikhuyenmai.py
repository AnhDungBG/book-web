# Generated by Django 5.1 on 2024-08-26 07:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bookapp', '0005_alter_khuyenmai_loaikhuyenmai'),
    ]

    operations = [
        migrations.AlterField(
            model_name='khuyenmai',
            name='loaikhuyenmai',
            field=models.CharField(choices=[('Mua', 'Mua'), ('Muon', 'Mượn'), ('All;', 'All')], max_length=10),
        ),
    ]
