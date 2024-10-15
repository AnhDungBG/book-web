# Generated by Django 5.1 on 2024-08-20 09:25

import ckeditor.fields
import django.contrib.auth.models
import django.contrib.auth.validators
import django.db.models.deletion
import django.utils.timezone
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='ChuDeGopY',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('chude', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='HinhThucThanhToan',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=200)),
                ('active', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='KhuyenMai',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=255)),
                ('khuyenmai', models.DecimalField(decimal_places=2, help_text='Nhập giá trị khuyến mại dưới dạng phần trăm. Ví dụ: 20% = 0.20', max_digits=4)),
                ('loaikhuyenmai', models.CharField(choices=[('Mua', 'Mua'), ('Muon', 'Mượn')], max_length=10)),
                ('noidung', ckeditor.fields.RichTextField()),
                ('tungay', models.DateField()),
                ('denngay', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='LoaiSanPham',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=500)),
            ],
        ),
        migrations.CreateModel(
            name='NhaSanXuat',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=100)),
                ('active', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='Tag',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=100, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='KhachHang',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username')),
                ('first_name', models.CharField(blank=True, max_length=150, verbose_name='first name')),
                ('last_name', models.CharField(blank=True, max_length=150, verbose_name='last name')),
                ('email', models.EmailField(blank=True, max_length=254, verbose_name='email address')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('hoten', models.CharField(max_length=50)),
                ('gioitinh', models.CharField(choices=[('Nam', 'Nam'), ('Nu', 'Nữ')], max_length=10)),
                ('diachi', models.CharField(max_length=100)),
                ('dienthoai', models.CharField(max_length=50)),
                ('ngaysinh', models.DateField(blank=True, null=True)),
                ('cmnd', models.CharField(blank=True, max_length=50, null=True, unique=True)),
                ('otp', models.CharField(blank=True, max_length=6, null=True)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
            ],
            options={
                'verbose_name': 'user',
                'verbose_name_plural': 'users',
                'abstract': False,
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='GopY',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('noidung', models.TextField()),
                ('ngaygopy', models.DateTimeField(auto_now_add=True)),
                ('chude', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.chudegopy')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='SanPham',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ten', models.CharField(max_length=100)),
                ('giamua', models.DecimalField(decimal_places=2, max_digits=12)),
                ('giamuon', models.DecimalField(decimal_places=2, max_digits=12)),
                ('giathitruong', models.DecimalField(decimal_places=2, max_digits=12)),
                ('motangan', models.CharField(max_length=1000)),
                ('motachitiet', ckeditor.fields.RichTextField()),
                ('ngaycapnhat', models.DateTimeField(auto_now=True)),
                ('soluong', models.IntegerField()),
                ('hinhanh', models.ImageField(upload_to='hinhsanpham/%Y/%m/')),
                ('active', models.BooleanField(default=True)),
                ('ngayxuatban', models.DateField(blank=True, null=True)),
                ('tacgia', models.CharField(blank=True, max_length=255, null=True)),
                ('khuyenmai', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.khuyenmai')),
                ('loai', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.loaisanpham')),
                ('nsx', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.nhasanxuat')),
                ('tags', models.ManyToManyField(to='bookapp.tag')),
            ],
        ),
        migrations.CreateModel(
            name='LichSuMuon',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('dienthoai', models.CharField(max_length=50)),
                ('soluong', models.IntegerField()),
                ('ngaydathang', models.DateTimeField()),
                ('dongia', models.DecimalField(decimal_places=2, max_digits=12)),
                ('noigiao', models.CharField(max_length=255)),
                ('muonhang', models.CharField(default='Mượn', max_length=10)),
                ('ngaytra', models.DateTimeField()),
                ('httt', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.hinhthucthanhtoan')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('sanpham', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bookapp.sanpham')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='LichSuMua',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('dienthoai', models.CharField(max_length=50)),
                ('soluong', models.IntegerField()),
                ('ngaydathang', models.DateTimeField()),
                ('dongia', models.DecimalField(decimal_places=2, max_digits=12)),
                ('noigiao', models.CharField(max_length=255)),
                ('muahang', models.CharField(default='Mua', max_length=10)),
                ('httt', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.hinhthucthanhtoan')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('sanpham', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bookapp.sanpham')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='YeuCauMua',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ngaydat', models.DateTimeField(auto_now_add=True)),
                ('noigiao', models.CharField(max_length=255)),
                ('trangthai_thanhtoan', models.BooleanField(default=False)),
                ('dienthoai', models.CharField(max_length=50)),
                ('soluong', models.IntegerField()),
                ('dongia', models.DecimalField(decimal_places=2, max_digits=12)),
                ('active', models.BooleanField(default=True)),
                ('httt', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.hinhthucthanhtoan')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('sanpham', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bookapp.sanpham')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='YeuCauMuon',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ngaydat', models.DateTimeField(auto_now_add=True)),
                ('noigiao', models.CharField(max_length=255)),
                ('trangthai_thanhtoan', models.BooleanField(default=False)),
                ('dienthoai', models.CharField(max_length=50)),
                ('soluong', models.IntegerField()),
                ('dongia', models.DecimalField(decimal_places=2, max_digits=12)),
                ('active', models.BooleanField(default=True)),
                ('ngaytra', models.DateTimeField()),
                ('httt', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='bookapp.hinhthucthanhtoan')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('sanpham', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bookapp.sanpham')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='DonHang',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ngaygiaotu', models.DateTimeField()),
                ('ngaygiaoden', models.DateTimeField()),
                ('yeucaumua', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='bookapp.yeucaumua')),
                ('yeucaumuon', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='bookapp.yeucaumuon')),
            ],
        ),
        migrations.CreateModel(
            name='YeuThich',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('khachhang', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('sanpham', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bookapp.sanpham')),
            ],
            options={
                'unique_together': {('khachhang', 'sanpham')},
            },
        ),
    ]
