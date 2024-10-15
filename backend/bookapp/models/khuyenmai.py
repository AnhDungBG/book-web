from django.db import models
from ckeditor.fields import RichTextField

class KhuyenMai(models.Model):
    ten = models.CharField(max_length=255)
    khuyenmai = models.DecimalField(max_digits=4, decimal_places=2, help_text="Nhập giá trị khuyến mại dưới dạng phần trăm. Ví dụ: 20% = 0.20")
    loaikhuyenmai = models.CharField(max_length=10, choices=[('Mua', 'Mua'), ('Muon', 'Mượn'),('All', 'All')])
    noidung = RichTextField()
    tungay = models.DateField()
    denngay = models.DateField()

    def __str__(self):
        return self.ten
