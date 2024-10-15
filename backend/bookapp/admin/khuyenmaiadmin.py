from django.contrib import admin
from bookapp.models.khuyenmai import KhuyenMai
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget


class KhuyenMaiForm(forms.ModelForm):
    noidung = forms.CharField(widget=CKEditorUploadingWidget())
    class Meta:
        model = KhuyenMai
        fields = '__all__'

class KhuyenMaiAdmin(admin.ModelAdmin):
    form = KhuyenMaiForm

    list_display = ["id","ten","khuyenmai_display","loaikhuyenmai","noidung","tungay","denngay"]
    search_fields = ["ten"]
    list_filter = ["loaikhuyenmai"]

    def khuyenmai_display(self, obj):
        return f"{obj.khuyenmai * 100}%"

    khuyenmai_display.short_description = 'Khuyến mại (%)'


admin.site.register(KhuyenMai,KhuyenMaiAdmin)
