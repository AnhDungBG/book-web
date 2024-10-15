from django.contrib.auth.models import Group
from django.db import models
from ckeditor.fields import RichTextField
from bookapp.models.product import SanPham
from bookapp.models.user import KhachHang


# Create your models here.
class ItemBaseNotifications(models.Model):
    class Meta:
        abstract = True

    ngaytao = models.DateTimeField(auto_now_add=True)
    ngaycapnhap = models.DateTimeField(auto_now=True)
    active = models.BooleanField(default=True)


class LoaiThongBao(ItemBaseNotifications):
    tieude = models.CharField(max_length=255, null=False)

    def __str__(self):
        return self.tieude


class ThongBao(ItemBaseNotifications):
    khachhang = models.ForeignKey(KhachHang, on_delete=models.CASCADE, null=True, blank=True)
    sanpham = models.ForeignKey(SanPham, on_delete=models.CASCADE, null=True, blank=True)
    ngaythongbao = models.DateTimeField()
    loaithongbao = models.ForeignKey(LoaiThongBao, on_delete=models.SET_NULL, null=True, blank=True)
    loinhan = RichTextField()
    group = models.ForeignKey(Group, on_delete=models.SET_NULL, null=True, blank=True, help_text="Chọn nhóm khách hàng nhận thông báo")

    def __str__(self):
        recipient = self.khachhang.hoten if self.khachhang else f"Group: {self.group.name}" if self.group else "Unknown"
        return f"Notification for {recipient} - {self.loaithongbao.tieude} về {self.sanpham.ten if self.sanpham else 'N/A'}"