from django.contrib import admin
from django.utils.safestring import mark_safe
from bookapp.models.product import LoaiSanPham, NhaSanXuat, SanPham, Tag
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget

class TagAdmin(admin.ModelAdmin):
    list_display = ["id","ten"]
    search_fields = ["ten"]


class LoaiSanPhamAdmin(admin.ModelAdmin):
    list_display = ["id","ten"]
    search_fields = ["ten"]

class NhaSanXuatAdmin(admin.ModelAdmin):
    list_display = ["id","ten","active"]
    search_fields = ["ten"]

class SanPhamForm(forms.ModelForm):
    motachitiet = forms.CharField(widget=CKEditorUploadingWidget())
    class Meta:
        model = SanPham
        fields = '__all__'

class SanPhamAdmin(admin.ModelAdmin):
    form = SanPhamForm

    list_display = ["id", "display_image", "ten","tacgia", "giamua", "giamuon","giathitruong",
                  "ngaycapnhat", "soluong","khuyenmai","ngayxuatban", "loai", "nsx","active"]
    search_fields = ["ten", "nsx__ten","tacgia"]
    list_filter = ["loai","nsx"]

    readonly_fields = ["display_image"]
    def display_image(self, obj):
        if obj.hinhanh:  # Tham chiếu đúng trường hình ảnh
            return mark_safe(
                f'<img src="{obj.hinhanh.url}" width="100" height="150" />'
            )
        return "No Image"

    display_image.short_description = "Hình ảnh"  # Đặt mô tả cột trong admin


admin.site.register(Tag,TagAdmin)
admin.site.register(LoaiSanPham,LoaiSanPhamAdmin)
admin.site.register(NhaSanXuat,NhaSanXuatAdmin)
admin.site.register(SanPham,SanPhamAdmin)