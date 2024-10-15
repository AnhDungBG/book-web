from django.db import models
from django.contrib.auth.models import AbstractUser
import random
import string
from django.utils import timezone
from notifications.utils import send_notification_email
from bookapp.models.product import SanPham


class KhachHang(AbstractUser):
    hoten = models.CharField(max_length=50)
    gioitinh = models.CharField(max_length=10, choices=[('Nam', 'Nam'), ('Nu', 'Nữ')])
    diachi = models.CharField(max_length=100)
    dienthoai = models.CharField(max_length=50,unique=True)
    ngaysinh = models.DateField(null=True, blank=True)
    cmnd = models.CharField(max_length=50, unique=True,null=True, blank=True)
    avatar = models.ImageField(upload_to='avatar/%Y/%m/',null=True, blank=True)
    otp = models.CharField(max_length=6,null=True, blank=True)
    otp_created_at = models.DateTimeField(null=True, blank=True)
    email_xac_thuc = models.BooleanField(default=False)

    def __str__(self):
        return self.hoten or self.username

class ChuDeGopY(models.Model):
    chude = models.CharField(max_length=255)

    def __str__(self):
        return self.chude

class GopY(models.Model):
    khachhang = models.ForeignKey(KhachHang, on_delete=models.CASCADE)
    chude = models.ForeignKey(ChuDeGopY, on_delete=models.SET_NULL, null=True, blank=True)
    noidung = models.TextField()
    ngaygopy = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Góp ý từ {self.khachhang.hoten} về {self.chude.chude}"

class YeuThich(models.Model):
    class Meta:
        unique_together = ('khachhang', 'sanpham')

    khachhang = models.ForeignKey(KhachHang, on_delete=models.CASCADE)
    sanpham = models.ForeignKey(SanPham, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.khachhang.username} favorites {self.sanpham.ten}"

class HinhThucThanhToan(models.Model):
    ten = models.CharField(max_length=200)
    active = models.BooleanField(default=True)

    def __str__(self):
        return self.ten

class ItemBaseLichSu(models.Model):
    class Meta:
        abstract = True

    khachhang = models.ForeignKey(KhachHang, on_delete=models.CASCADE)
    sanpham = models.ForeignKey(SanPham, on_delete=models.CASCADE)
    httt = models.ForeignKey(HinhThucThanhToan, on_delete=models.SET_NULL, null=True, blank=True)
    dienthoai = models.CharField(max_length=50)
    soluong = models.IntegerField()
    ngaydathang = models.DateTimeField()
    dongia = models.DecimalField(max_digits=12, decimal_places=2)
    noigiao = models.CharField(max_length=255)
    ghichu = models.CharField(max_length=255, null=True, blank=True)

class LichSuMua(ItemBaseLichSu):
    muahang = models.CharField(max_length=10,default="Mua")

    def __str__(self):
        return f"lịch sử mua: {self.sanpham.ten} số lượng: {self.soluong} - đơn giá: {self.dongia}"

class LichSuMuon(ItemBaseLichSu):
    muonhang = models.CharField(max_length=10,default="Mượn")
    ngaytra = models.DateField()

    def __str__(self):
        return f"lịch sử mượn: {self.sanpham.ten} số lượng: {self.soluong} - đơn giá: {self.dongia}"

class EmailVerification(models.Model):
    email = models.EmailField(unique=True)
    otp = models.CharField(max_length=6)
    otp_created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)
    otp_attempts = models.IntegerField(default=0)

    @staticmethod
    def tao_otp():
        return ''.join(random.choices(string.digits, k=6))

    def gui_otp_email(self):
        self.otp = self.tao_otp()
        self.otp_created_at = timezone.now()
        self.otp_attempts = 0
        self.save()
        
        subject = '[BookWebsite] Mã xác thực OTP cho email của bạn'
        message = f'Mã OTP của bạn là: {self.otp}'
        
        try:
            send_notification_email(self.email, subject, message)
            return True
        except Exception as e:
            print(f"Lỗi gửi email: {str(e)}")
            return False

    def xac_thuc_otp(self, otp_nhap):
        if self.otp_attempts >= 3:
            return False, "Bạn đã nhập sai OTP quá nhiều lần. Vui lòng yêu cầu OTP mới."

        if self.otp == otp_nhap:
            if (timezone.now() - self.otp_created_at).total_seconds() > 300:
                return False, "OTP đã hết hạn. Vui lòng yêu cầu OTP mới."

            self.is_verified = True
            self.save()
            return True, "Xác thực thành công."
        else:
            self.otp_attempts += 1
            self.save()
            return False, "Mã OTP không đúng."