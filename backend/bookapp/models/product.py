from django.db import models
from ckeditor.fields import RichTextField

from bookapp.models.khuyenmai import KhuyenMai


class Tag(models.Model):
    ten = models.CharField(max_length=100,unique=True,null=False)

    def __str__(self):
        return self.ten


class LoaiSanPham(models.Model):
    ten = models.CharField(max_length=500)

    def __str__(self):
        return self.ten


class NhaSanXuat(models.Model):
    ten = models.CharField(max_length=100)
    active = models.BooleanField(default=True)

    def __str__(self):
        return self.ten


class SanPham(models.Model):
    ten = models.CharField(max_length=100)
    giamua = models.DecimalField(max_digits=12, decimal_places=2)
    giamuon = models.DecimalField(max_digits=12, decimal_places=2)
    giathitruong = models.DecimalField(max_digits=12, decimal_places=2)
    motangan = models.CharField(max_length=1000)
    motachitiet = RichTextField()
    ngaycapnhat = models.DateTimeField(auto_now=True)
    soluong = models.IntegerField()
    loai = models.ForeignKey(LoaiSanPham, on_delete=models.SET_NULL, null=True, blank=True)
    nsx = models.ForeignKey(NhaSanXuat, on_delete=models.SET_NULL, null=True, blank=True)
    hinhanh = models.ImageField(upload_to='hinhsanpham/%Y/%m/')
    tags = models.ManyToManyField(Tag)
    active = models.BooleanField(default=True)
    khuyenmai = models.ForeignKey(KhuyenMai, on_delete=models.SET_NULL, null=True, blank=True)
    ngayxuatban = models.DateField(null=True, blank=True)
    tacgia = models.CharField(max_length=255,null=True, blank=True)

    def __str__(self):
        return self.ten

    def save(self, *args, **kwargs):
        if self.soluong > 0 and not self.active:
            self.active = True
        elif self.soluong <= 0:
            self.active = False

        super().save(*args, **kwargs)