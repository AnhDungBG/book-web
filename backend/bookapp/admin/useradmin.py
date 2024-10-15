from django.contrib import admin
from django.contrib.auth.models import Permission
from bookapp.models.user import KhachHang, ChuDeGopY, GopY, YeuThich, LichSuMua, LichSuMuon, HinhThucThanhToan, EmailVerification


class ChuDeGopYAdmin(admin.ModelAdmin):
    list_display = ["id", "chude"]
    search_fields = ["chude"]


class GopYAdmin(admin.ModelAdmin):
    list_display = ["id", "khachhang","chude","noidung","ngaygopy"]
    search_fields = ["khachhang__hoten"]
    list_filter = ["chude"]


class YeuThichAdmin(admin.ModelAdmin):
    list_display = ["id", "khachhang", "sanpham"]
    search_fields = ["sanpham__ten","khachhang__hoten"]


class HinhThucThanhToanAdmin(admin.ModelAdmin):
    list_display = ["id", "ten", "active"]
    search_fields = ["ten"]
    list_filter = ["active"]

class LichSuMuaAdmin(admin.ModelAdmin):
    list_display = ["id", "khachhang", "sanpham", "httt","dienthoai", "soluong", "ngaydathang", "dongia", "noigiao","muahang","ghichu"]
    search_fields = ["sanpham__ten", "khachhang__hoten","dienthoai", "noigiao"]


class LichSuMuonAdmin(admin.ModelAdmin):
    list_display = ["id", "khachhang", "sanpham", "httt","dienthoai", "soluong", "ngaydathang", "dongia", "noigiao","muonhang","ngaytra","ghichu"]
    search_fields = ["sanpham__ten", "khachhang__hoten","dienthoai", "noigiao"]


class EmailVerificationAdmin(admin.ModelAdmin):
    list_display = ["id", "email", "is_verified", "otp_created_at", "otp_attempts"]
    list_filter = ["is_verified"]
    search_fields = ["email"]
    readonly_fields = ["otp", "otp_created_at", "otp_attempts"]
    
    def has_add_permission(self, request):
        return False  # Ngăn chặn việc thêm mới bản ghi EmailVerification từ trang admin

    def has_change_permission(self, request, obj=None):
        return False  # Ngăn chặn việc chỉnh sửa bản ghi EmailVerification từ trang admin

admin.site.register(KhachHang)
admin.site.register(ChuDeGopY,ChuDeGopYAdmin)
admin.site.register(GopY,GopYAdmin)
admin.site.register(YeuThich,YeuThichAdmin)
admin.site.register(HinhThucThanhToan,HinhThucThanhToanAdmin)
admin.site.register(LichSuMua,LichSuMuaAdmin)
admin.site.register(LichSuMuon,LichSuMuonAdmin)
admin.site.register(Permission)
admin.site.register(EmailVerification, EmailVerificationAdmin)