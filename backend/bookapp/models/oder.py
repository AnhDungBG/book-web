from django.db import models
from django.core.exceptions import ValidationError
from bookapp.models.product import SanPham
from bookapp.models.user import KhachHang, HinhThucThanhToan
from notifications.models import LoaiThongBao, ThongBao
from notifications.utils import send_notification_email
import logging
from django.utils import timezone

logger = logging.getLogger(__name__)

class ItemBaseOder(models.Model):
    class Meta:
        abstract = True

    khachhang = models.ForeignKey(KhachHang, on_delete=models.CASCADE)
    ngaydat = models.DateTimeField(auto_now_add=True)
    noigiao = models.CharField(max_length=255)
    trangthai_thanhtoan = models.BooleanField(default=False)
    httt = models.ForeignKey(HinhThucThanhToan, on_delete=models.SET_NULL, null=True, blank=True)
    dienthoai = models.CharField(max_length=50)
    sanpham = models.ForeignKey(SanPham, on_delete=models.CASCADE)
    soluong = models.IntegerField()
    dongia = models.DecimalField(max_digits=12, decimal_places=2)
    ghichu = models.CharField(max_length=255, null=True, blank=True)
    active = models.BooleanField(default=True)


class YeuCauMua(ItemBaseOder):

    def __str__(self):
        return f"Khách #{self.khachhang.id} - Đơn hàng #{self.id} - {self.sanpham.ten} - Số lượng: {self.soluong}"

class YeuCauMuon(ItemBaseOder):
    ngaytra = models.DateField()

    def __str__(self):
        return f"Khách #{self.khachhang.id} - Đơn hàng #{self.id} - {self.sanpham.ten} - Số lượng: {self.soluong}"

class DonHang(models.Model):
    yeucaumua = models.ForeignKey(YeuCauMua, on_delete=models.CASCADE, null=True, blank=True)
    yeucaumuon = models.ForeignKey(YeuCauMuon, on_delete=models.CASCADE, null=True, blank=True)
    ngaygiaotu = models.DateField()
    ngaygiaoden = models.DateField()
    xacnhandonhang = models.BooleanField(default=False)
    ghichu = models.CharField(max_length=255, null=True, blank=True)
    active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.id} - Ngày giao từ: {self.ngaygiaotu} - {self.ngaygiaoden}"

    def clean(self):
        # Kiểm tra nếu cả hai trường đều có dữ liệu
        if self.yeucaumua and self.yeucaumuon:
            # Kiểm tra nếu ID khách hàng không trùng nhau
            if self.yeucaumua.khachhang != self.yeucaumuon.khachhang:
                raise ValidationError("ID khách hàng trong Yeucaumua và Yeucaumuon phải trùng nhau.")

        # Kiểm tra nếu cả hai trường đều trống
        if not self.yeucaumua and not self.yeucaumuon:
            raise ValidationError("Phải có ít nhất một trong hai trường Yeucaumua hoặc Yeucaumuon được điền.")

    def save(self, *args, **kwargs):
        # Gọi clean trước khi lưu
        self.clean()
        super().save(*args, **kwargs)

        # Lấy giá trị yeucaumua và yeucaumuon đã lưu
        if self.yeucaumua:
            self.yeucaumua.active = False
            self.yeucaumua.save()

        if self.yeucaumuon:
            self.yeucaumuon.active = False
            self.yeucaumuon.save()
