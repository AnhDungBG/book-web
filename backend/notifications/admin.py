from django.contrib import admin
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget
from notifications.models import LoaiThongBao, ThongBao


# Register your models here.
class ThongBaoForm(forms.ModelForm):
    loinhan = forms.CharField(widget=CKEditorUploadingWidget())
    class Meta:
        model = ThongBao
        fields = '__all__'

class LoaiThongBaoAdmin(admin.ModelAdmin):
    list_display = ["id", "tieude","ngaytao","ngaycapnhap","active"]
    search_fields = ["tieude"]
    list_filter = ["active"]

class ThongBaoAdmin(admin.ModelAdmin):
    form = ThongBaoForm

    list_display = ["id", "khachhang","sanpham","ngaythongbao","loaithongbao", "loinhan","group","ngaytao","ngaycapnhap","active"]
    search_fields = ["sanpham", "khachhang"]
    list_filter = ["active"]

admin.site.register(LoaiThongBao, LoaiThongBaoAdmin)
admin.site.register(ThongBao,ThongBaoAdmin)
