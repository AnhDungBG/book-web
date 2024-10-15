from rest_framework.serializers import ModelSerializer

from bookapp.serializers import SanPhamSerializer, KhachHangSerializer, KhachHangMiniSerializer
from notifications.models import LoaiThongBao, ThongBao
from django.contrib.auth.models import Group

class LoaiThongBaoSerializer(ModelSerializer):
    class Meta:
        model = LoaiThongBao
        fields = ["id", "tieude","ngaytao","ngaycapnhap"]

class GroupSerializer(ModelSerializer):
    class Meta:
        model = Group
        fields = "__all__"


class ThongBaoSerializer(ModelSerializer):
    khachhang = KhachHangMiniSerializer()
    sanpham = SanPhamSerializer()
    loaithongbao = LoaiThongBaoSerializer()
    group = GroupSerializer()
    class Meta:
        model = ThongBao
        fields = ["id", "khachhang","sanpham","ngaythongbao","loaithongbao", "loinhan","group","ngaytao","ngaycapnhap"]
