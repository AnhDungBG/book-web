from django import forms
from django.contrib import admin
from django.db import models
from bookapp.models.oder import YeuCauMua, YeuCauMuon, DonHang

# Register your models here.
class YeuCauMuaAdmin(admin.ModelAdmin):
    list_display = ["id","khachhang","ngaydat","noigiao","trangthai_thanhtoan","httt","dienthoai","sanpham","soluong","dongia","active","ghichu"]
    search_fields = ["khachhang__hoten", "sanpham__ten","dienthoai"]
    list_filter = ["active","ngaydat","trangthai_thanhtoan"]
    ordering = ['-active', 'ngaydat']  # Sắp xếp theo active trước, rồi đến ngày đặt


class YeuCauMuonAdmin(admin.ModelAdmin):
    list_display = ["id","khachhang","ngaydat","noigiao","trangthai_thanhtoan","httt","dienthoai",
                    "sanpham","soluong","dongia","ngaytra","active","ghichu"]
    search_fields = ["khachhang__hoten", "sanpham__ten","dienthoai"]
    list_filter = ["active","ngaydat","trangthai_thanhtoan"]
    ordering = ['-active', 'ngaydat']

class DonHangForm(forms.ModelForm):
    class Meta:
        model = DonHang
        # fields = [field.name for field in model._meta.get_fields()]
        fields = ["yeucaumua","yeucaumuon","ngaygiaotu","ngaygiaoden"]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Chỉ hiển thị những YeuCauMua và YeuCauMuon đang active
        self.fields['yeucaumua'].queryset = YeuCauMua.objects.filter(active=True)
        self.fields['yeucaumuon'].queryset = YeuCauMuon.objects.filter(active=True)

class DonHangAdmin(admin.ModelAdmin):
    form = DonHangForm
    list_display = ["id", "get_khachhang", "yeucaumua", "yeucaumuon", "ngaygiaotu", "ngaygiaoden", "xacnhandonhang", "ghichu"]
    search_fields = ["yeucaumua__khachhang__hoten", "yeucaumuon__khachhang__hoten","yeucaumua__sanpham__ten", "yeucaumuon__sanpham__ten"]

    def get_khachhang(self, obj):
        # Lấy tên khách hàng từ yeucaumua hoặc yeucaumuon
        if obj.yeucaumua:
            return obj.yeucaumua.khachhang.hoten  # Thay 'hoten' bằng trường tên thực tế
        elif obj.yeucaumuon:
            return obj.yeucaumuon.khachhang.hoten  # Thay 'hoten' bằng trường tên thực tế
        return "Không có"

    get_khachhang.short_description = "Tên Khách Hàng"  # Tiêu đề cột trong admin

    def get_queryset(self, request):
        queryset = super().get_queryset(request)
        return queryset

admin.site.register(YeuCauMua,YeuCauMuaAdmin)
admin.site.register(YeuCauMuon,YeuCauMuonAdmin)
admin.site.register(DonHang,DonHangAdmin)
